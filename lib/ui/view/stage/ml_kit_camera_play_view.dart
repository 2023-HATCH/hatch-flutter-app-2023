// 카메라 화면
import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/config/ml_kit/custom_pose_painter.dart';
import 'package:pocket_pose/data/entity/socket_request/send_skeleton_request.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_skeleton_pose_landmark.dart';
import 'package:pocket_pose/main.dart';
import 'package:pocket_pose/ui/widget/stage/stage_appbar_music_info_widget.dart';
import 'package:provider/provider.dart';

class MlKitCameraPlayView extends StatefulWidget {
  const MlKitCameraPlayView({
    Key? key,
    this.initialDirection = CameraLensDirection.back,
    required this.playerNum,
    required this.midEnterSeconds,
  }) : super(key: key);
  // 카메라 렌즈 방향 변수
  final CameraLensDirection initialDirection;
  // 플레이어인지 확인하는 변수
  final int playerNum;
  // 중간 입장한 초
  final int midEnterSeconds;

  @override
  State<MlKitCameraPlayView> createState() => _MlKitCameraPlayViewState();
}

class _MlKitCameraPlayViewState extends State<MlKitCameraPlayView> {
  // 카메라를 다루기 위한 변수
  CameraController? _controller;
  // 카메라 인덱스
  int _cameraIndex = -1;
  // 확대 축소 레벨
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  // 스켈레톤 모양을 그려주는 변수
  CustomPaint? _customPaintLeft;
  CustomPaint? _customPaintMid;
  CustomPaint? _customPaintRight;
  // ml kit 변수
  bool _canProcess = true;
  bool _isBusy = false;
  int _frameNum = 0;
  // 5초 카운트다운변수
  bool _countdownVisibility = false;
  final List<String> _countdownSVG = [
    'assets/icons/ic_countdown_1.png',
    'assets/icons/ic_countdown_2.png',
    'assets/icons/ic_countdown_3.png',
    'assets/icons/ic_countdown_4.png',
    'assets/icons/ic_countdown_5.png',
  ];
  int _seconds = 5;
  Timer? _timer;
  AssetsAudioPlayer? _assetsAudioPlayer;
  // 스켈레톤 추출 변수 선언(google_mlkit_pose_detection 라이브러리)
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  late StageProviderImpl _stageProvider;
  late SocketStageProviderImpl _socketStageProvider;

  @override
  Widget build(BuildContext context) {
    print("mmm camera play build");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: _liveFeedBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _stageProvider = Provider.of<StageProviderImpl>(context, listen: false);
    _socketStageProvider =
        Provider.of<SocketStageProviderImpl>(context, listen: false);
    _assetsAudioPlayer = AssetsAudioPlayer();

    // 카메라 설정. 기기에서 실행 가능한 카메라, 카메라 방향 설정...
    if (cameras.any(
      (element) =>
          element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
            element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == widget.initialDirection) {
          _cameraIndex = i;
          break;
        }
      }
    }

    // 중간 입장 처리
    _onMidEnter();

    // 플레이어이면서 카메라 실행 가능하면 포즈 추출 시작
    if (widget.playerNum != -1 && _cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  void dispose() {
    _stopTimer();
    _assetsAudioPlayer = null;
    _assetsAudioPlayer?.dispose();
    _canProcess = false;
    _poseDetector.close();
    _controller?.dispose;

    super.dispose();
  }

  void _onMidEnter() {
    (_socketStageProvider.catchMusicData != null)
        ? AudioPlayerUtil()
            .setMusicUrl(_socketStageProvider.catchMusicData!.musicUrl)
        : AudioPlayerUtil().setMusicUrl(_stageProvider.music!.musicUrl);

    // 중간임장인 경우
    if (widget.midEnterSeconds != -1) {
      // 중간 입장한 초부터 시작
      _seconds = widget.midEnterSeconds;
    } else {
      // 중간입장 아닐 시 처음부터 시작(0초)
      _seconds = 0;
    }

    // 카운트다운
    if (_seconds < 5) {
      // 카운트다운 시작 후 노래 재생
      _seconds = 5 - _seconds;
      _countdownVisibility = true;

      _startTimer();
    }
    // 노래 재생
    else {
      AudioPlayerUtil().playSeek(_seconds - 5);
    }
  }

  // 카메라 화면 보여주기 + 화면에서 실시간으로 포즈 추출
  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    // 화면 및 카메라 비율에 따른 스케일 계산
    var scale = size.aspectRatio * _controller!.value.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const StageAppbarMusicInfoWidget(),
        // 추출된 스켈레톤 그리기
        _liveFeedBodyPlay(),
        buildCountdownWidget(),
      ],
    );
  }

  // 플레이 화면: 플레이어 3명 스켈레톤 보임
  Widget _liveFeedBodyPlay() {
    switch (_socketStageProvider.players.length) {
      case 1:
        return Row(
          children: [
            Expanded(flex: 2, child: Container()),
            Expanded(
              flex: 4,
              child: Selector<SocketStageProviderImpl,
                      Map<PoseLandmarkType, PoseLandmark>?>(
                  selector: (context, socketProvider) => socketProvider.player0,
                  shouldRebuild: (prev, next) {
                    return true;
                  },
                  builder: (context, player0, child) {
                    if (player0 != null) {
                      CustomPosePainter painterMid = CustomPosePainter(
                          [Pose(landmarks: player0)],
                          const Size(1280.0, 720.0),
                          InputImageRotation.rotation270deg,
                          AppColor.mintNeonColor);
                      _customPaintMid = CustomPaint(painter: painterMid);
                    } else {
                      _customPaintMid = null;
                    }
                    return (_customPaintMid != null)
                        ? SizedBox(height: 200, child: _customPaintMid!)
                        : Container();
                  }),
            ),
            Expanded(flex: 2, child: Container()),
          ],
        );
      case 2:
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: Selector<SocketStageProviderImpl,
                      Map<PoseLandmarkType, PoseLandmark>?>(
                  selector: (context, socketProvider) => socketProvider.player1,
                  shouldRebuild: (prev, next) {
                    return true;
                  },
                  builder: (context, player1, child) {
                    if (player1 != null) {
                      CustomPosePainter painterLeft = CustomPosePainter(
                          [Pose(landmarks: player1)],
                          const Size(1280.0, 720.0),
                          InputImageRotation.rotation270deg,
                          AppColor.yellowNeonColor);
                      _customPaintLeft = CustomPaint(painter: painterLeft);
                    } else {
                      _customPaintLeft = null;
                    }
                    return (_customPaintLeft != null)
                        ? SizedBox(height: 200, child: _customPaintLeft!)
                        : Container();
                  }),
            ),
            Expanded(
              flex: 1,
              child: Selector<SocketStageProviderImpl,
                      Map<PoseLandmarkType, PoseLandmark>?>(
                  selector: (context, socketProvider) => socketProvider.player0,
                  shouldRebuild: (prev, next) {
                    return true;
                  },
                  builder: (context, player0, child) {
                    if (player0 != null) {
                      CustomPosePainter painterMid = CustomPosePainter(
                          [Pose(landmarks: player0)],
                          const Size(1280.0, 720.0),
                          InputImageRotation.rotation270deg,
                          AppColor.mintNeonColor);
                      _customPaintMid = CustomPaint(painter: painterMid);
                    } else {
                      _customPaintMid = null;
                    }
                    return (_customPaintMid != null)
                        ? SizedBox(height: 200, child: _customPaintMid!)
                        : Container();
                  }),
            ),
          ],
        );
      default:
        return Row(
          children: [
            Expanded(
              flex: 4,
              child: Selector<SocketStageProviderImpl,
                      Map<PoseLandmarkType, PoseLandmark>?>(
                  selector: (context, socketProvider) => socketProvider.player1,
                  shouldRebuild: (prev, next) {
                    return true;
                  },
                  builder: (context, player1, child) {
                    if (player1 != null) {
                      CustomPosePainter painterLeft = CustomPosePainter(
                          [Pose(landmarks: player1)],
                          const Size(1280.0, 720.0),
                          InputImageRotation.rotation270deg,
                          AppColor.yellowNeonColor);
                      _customPaintLeft = CustomPaint(painter: painterLeft);
                    } else {
                      _customPaintLeft = null;
                    }
                    return (_customPaintLeft != null)
                        ? SizedBox(height: 200, child: _customPaintLeft!)
                        : Container();
                  }),
            ),
            Expanded(
              flex: 4,
              child: Selector<SocketStageProviderImpl,
                      Map<PoseLandmarkType, PoseLandmark>?>(
                  selector: (context, socketProvider) => socketProvider.player0,
                  shouldRebuild: (prev, next) {
                    return true;
                  },
                  builder: (context, player0, child) {
                    if (player0 != null) {
                      CustomPosePainter painterMid = CustomPosePainter(
                          [Pose(landmarks: player0)],
                          const Size(1280.0, 720.0),
                          InputImageRotation.rotation270deg,
                          AppColor.mintNeonColor);
                      _customPaintMid = CustomPaint(painter: painterMid);
                    } else {
                      _customPaintMid = null;
                    }
                    return (_customPaintMid != null)
                        ? SizedBox(height: 200, child: _customPaintMid!)
                        : Container();
                  }),
            ),
            Expanded(
              flex: 3,
              child: Selector<SocketStageProviderImpl,
                      Map<PoseLandmarkType, PoseLandmark>?>(
                  selector: (context, socketProvider) => socketProvider.player2,
                  shouldRebuild: (prev, next) {
                    return true;
                  },
                  builder: (context, player2, child) {
                    if (player2 != null) {
                      CustomPosePainter painterRignt = CustomPosePainter(
                          [Pose(landmarks: player2)],
                          const Size(1280.0, 720.0),
                          InputImageRotation.rotation270deg,
                          AppColor.greenNeonColor);
                      _customPaintRight = CustomPaint(painter: painterRignt);
                    } else {
                      _customPaintRight = null;
                    }
                    return (_customPaintRight != null)
                        ? SizedBox(height: 200, child: _customPaintRight!)
                        : Container();
                  }),
            ),
          ],
        );
    }
  }

  Widget buildCountdownWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
            visible: _countdownVisibility,
            child: (6 > _seconds) && (_seconds > 0)
                ? Image.asset(_countdownSVG[_seconds - 1])
                : Container())
      ],
    );
  }

  void _startTimer() {
    _assetsAudioPlayer?.open(Audio("assets/audios/sound_play_wait.mp3"));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 1) {
        _stopTimer();

        if (mounted) {
          setState(() {
            _countdownVisibility = false;
          });
        }
        _seconds = 5;
        AudioPlayerUtil().play();
      } else {
        if (mounted) {
          _assetsAudioPlayer?.open(Audio("assets/audios/sound_play_wait.mp3"));
          setState(() {
            _seconds--;
          });
        }
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // 실시간으로 카메라에서 이미지 받기(비동기적)
  Future _startLiveFeed() async {
    final camera = cameras[(_cameraIndex + 1) % cameras.length];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      // 이미지 받은 것을 _processCameraImage 함수로 처리
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  // 카메라에서 실시간으로 받아온 이미치 처리
  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[(_cameraIndex + 1) % cameras.length];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    // 스켈레톤 전송
    _sendSkeleton(inputImage);
  }

  // 카메라에서 실시간으로 받아온 이미지 처리: 스켈레톤 전송
  Future<void> _sendSkeleton(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    // poseDetector에서 추출된 포즈 가져오기
    List<Pose> poses = await _poseDetector.processImage(inputImage);
    // 소켓에 스켈레톤 전송
    for (final pose in poses) {
      Map<String, StageSkeletonPoseLandmark> resultMap = {};

      pose.landmarks.forEach((key, value) {
        var poseLandmark = StageSkeletonPoseLandmark(
            type: value.type.index,
            x: value.x,
            y: value.y,
            z: value.z,
            likelihood: value.likelihood);

        resultMap[key.index.toString()] = poseLandmark;
      });

      var resuest = SendSkeletonRequest(
          playerNum: widget.playerNum,
          frameNum: _frameNum,
          skeleton: resultMap);
      _socketStageProvider.sendPlaySkeleton(resuest);
    }
    _frameNum++;

    _isBusy = false;
  }
}
