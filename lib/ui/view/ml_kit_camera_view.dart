// 카메라 화면
import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/main.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CameraView extends StatefulWidget {
  CameraView(
      {Key? key,
      required this.isResultState,
      this.customPaintLeft,
      required this.customPaintMid,
      this.customPaintRight,
      required this.onImage,
      this.initialDirection = CameraLensDirection.back})
      : super(key: key);
  bool isResultState;
  // 스켈레톤을 그려주는 객체
  final CustomPaint? customPaintLeft;
  final CustomPaint? customPaintMid;
  final CustomPaint? customPaintRight;
  // 이미지 받을 때마다 실행하는 함수
  final Function(InputImage inputImage) onImage;
  // 카메라 렌즈 방향 변수
  final CameraLensDirection initialDirection;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  // 카메라를 다루기 위한 변수
  CameraController? _controller;
  // 카메라 인덱스
  int _cameraIndex = -1;
  // 확대 축소 레벨
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  // 5초 카운트다운 텍스트
  bool _countdownVisibility = false;
  int _seconds = 5;
  Timer? _timer;
  AssetsAudioPlayer? _assetsAudioPlayer;
  late StageProviderImpl _stageProvider;
  late SocketStageProviderImpl _socketStageProvider;

  @override
  Widget build(BuildContext context) {
    _socketStageProvider =
        Provider.of<SocketStageProviderImpl>(context, listen: true);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      // 결과 화면이면 1명의 스켈레톤, 플레이 화면이면 3명의 스켈레톤 출력
      body: _liveFeedBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _stageProvider = Provider.of<StageProviderImpl>(context, listen: false);

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

    // 카메라 실행 가능하면 포즈 추출 시작
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }

    _assetsAudioPlayer = AssetsAudioPlayer();

    // 중간입장 처리
    _onMidEnter();
  }

  void _onMidEnter() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 플레이 상태인 경우
      if (!widget.isResultState) {
        AudioPlayerUtil()
            .setMusicUrl(_socketStageProvider.catchMusicData!.musicUrl);

        // 중간임장인 경우
        if (_stageProvider.stageCurTime != null) {
          // 중간 입장한 초부터 시작
          _seconds = (_stageProvider.stageCurTime! / (1000000 * 1000)).round();
          _stageProvider.setStageCurSecondNULL();
        } else {
          // 중간입장 아닐 시 0초부터 시작
          _seconds = 0;
        }
        // 카운트다운
        if (_seconds < 5) {
          // 카운트다운 시작 후 노래 재생
          setState(() {
            _seconds = 5 - _seconds;
            _countdownVisibility = true;
          });
          _startTimer();
        }
        // 노래 재생
        else {
          AudioPlayerUtil().playSeek(_seconds - 5);
        }
      }
      // 결과 상태인 경우
      else {
        AudioPlayerUtil().setMusicUrl(
            "https://popo2023.s3.ap-northeast-2.amazonaws.com/effect/Happyhappy.mp3");
        // 중간임장인 경우
        if (_stageProvider.stageCurTime != null) {
          // 중간 입장한 초부터 시작
          _seconds = (_stageProvider.stageCurTime! / (1000000 * 1000)).round();
          _stageProvider.setStageCurSecondNULL();
          AudioPlayerUtil().playSeek(_seconds);
        } else {
          // 중간입장 아닐 시 0초부터 시작
          _seconds = 0;
          AudioPlayerUtil().play();
        }
      }
    });
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

  @override
  void dispose() {
    // AudioPlayerUtil().stop();
    _assetsAudioPlayer = null;
    _assetsAudioPlayer?.dispose();
    _stopTimer();

    super.dispose();
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
        buildMusicInfoWidget(),
        // 추출된 스켈레톤 그리기
        (widget.isResultState) ? _liveFeedBodyResult() : _liveFeedBodyPlay(),
        buildCountdownWidget()
      ],
    );
  }

  // 결과 화면: MVP 1명의 스켈레톤만 보임
  Widget _liveFeedBodyResult() {
    return Row(
      children: [
        Expanded(flex: 2, child: Container()),
        Expanded(
            flex: 4,
            child: (widget.customPaintMid != null)
                ? SizedBox(height: 300, child: widget.customPaintMid!)
                : Container()),
        Expanded(flex: 2, child: Container()),
      ],
    );
  }

  // 플레이 화면: 플레이어 3명 스켈레톤 보임
  Widget _liveFeedBodyPlay() {
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: (widget.customPaintLeft != null)
                ? SizedBox(height: 200, child: widget.customPaintLeft!)
                : Container()),
        Expanded(
            flex: 4,
            child: (widget.customPaintMid != null)
                ? SizedBox(height: 200, child: widget.customPaintMid!)
                : Container()),
        Expanded(
            flex: 3,
            child: (widget.customPaintRight != null)
                ? SizedBox(height: 150, child: widget.customPaintRight!)
                : Container()),
      ],
    );
  }

  Column buildCountdownWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: _countdownVisibility,
          child: Text('$_seconds',
              style: const TextStyle(fontSize: 72, color: Colors.white)),
        )
      ],
    );
  }

  Positioned buildMusicInfoWidget() {
    return Positioned(
      top: 80,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/ic_music_note_small.svg',
          ),
          const SizedBox(width: 8.0),
          Text(
            '${_socketStageProvider.catchMusicData?.singer} - ${_socketStageProvider.catchMusicData?.title}',
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        ],
      ),
    );
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

  // 카메라에서 실시간으로 받아온 이미치 처리: PoseDetectorView에서 받아온 함수인 onImage(이미지에 포즈가 추출되었으면 스켈레톤 그려주는 함수) 실행
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

    // PoseDetectorView에서 받아온 함수인 onImage(이미지에 포즈가 추출되었으면 스켈레톤 그려주는 함수) 실행
    widget.onImage(inputImage);
  }
}
