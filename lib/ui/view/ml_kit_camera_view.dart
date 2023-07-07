// 카메라 화면
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/main.dart';

enum SkeletonDetectMode {
  playerWaitMode, // 플레이어가 춤 추기 전 준비하는 모드(스켈레톤 추출 O, 스켈레톤 배열에 저장 X)
  musicStartMode, // 노래 시작. 플레이어의 스켈레톤을 배열에 저장하는 모드 (스켈레톤 추출 O, 스켈레톤 배열에 저장 시작)
  musicEndMode, // 노래 종료. 플레이어의 스켈레톤을 서버에 전달  (스켈레톤 추출 종료, 스켈레톤 배열에 저장 종료)
  resultMode, // 결과 화면. 항상 스켈레톤 추출 (스켈레톤 추출 O, 스켈레톤 배열에 저장 X)
  userMode // 유저 모드. 스켈레톤 추출 안 함 (스켈레톤 추출 X, 스켈레톤 배열에 저장 X)
}

// ignore: must_be_immutable
class CameraView extends StatefulWidget {
  CameraView(
      {Key? key,
      required this.isResultState,
      required this.setIsSkeletonDetectMode,
      required this.customPaint,
      required this.onImage,
      this.initialDirection = CameraLensDirection.back})
      : super(key: key);
  bool isResultState;
  // skeleton 트리거
  Function setIsSkeletonDetectMode;
  // 스켈레톤을 그려주는 객체
  final CustomPaint? customPaint;
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
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
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

    // AudioPlayer 초기화
    AudioPlayerUtil().setPlayerCompletion(widget.setIsSkeletonDetectMode);
    AudioPlayerUtil().setCameraController(_controller);

    // 결과 상태인 경우
    if (widget.isResultState) {
      AudioPlayerUtil().play(
          "https://popo2023.s3.ap-northeast-2.amazonaws.com/effect/Happyhappy.mp3",
          widget.setIsSkeletonDetectMode);
    }
    // 플레이 상태인 경우
    else {
      // 카운트다운 시작 후 노래 재생
      setState(() {
        _countdownVisibility = true;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 1) {
        _stopTimer();

        if (mounted) {
          setState(() {
            _countdownVisibility = false;
          });
        }
        AudioPlayerUtil().play(
            "https://popo2023.s3.ap-northeast-2.amazonaws.com/music/M3-1.mp3",
            widget.setIsSkeletonDetectMode);
      } else {
        if (mounted) {
          setState(() {
            _seconds--;
          });
        }
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  @override
  void dispose() {
    if (widget.isResultState) {
      AudioPlayerUtil().stop();
    }
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
            child: (widget.customPaint != null)
                ? SizedBox(height: 300, child: widget.customPaint!)
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
            flex: 3,
            child: (widget.customPaint != null)
                ? SizedBox(height: 150, child: widget.customPaint!)
                : Container()),
        Expanded(
            flex: 4,
            child: (widget.customPaint != null)
                ? SizedBox(height: 200, child: widget.customPaint!)
                : Container()),
        Expanded(
            flex: 3,
            child: (widget.customPaint != null)
                ? SizedBox(height: 150, child: widget.customPaint!)
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
          const Text(
            "I AM-IVE",
            style: TextStyle(fontSize: 10, color: Colors.white),
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
