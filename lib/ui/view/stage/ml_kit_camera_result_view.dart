// 카메라 화면
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pocket_pose/config/ml_kit/custom_pose_painter.dart';
import 'package:pocket_pose/data/entity/socket_request/send_skeleton_request.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_skeleton_pose_landmark.dart';
import 'package:pocket_pose/main.dart';
import 'package:pocket_pose/ui/widget/stage/stage_appbar_music_info_widget.dart';
import 'package:provider/provider.dart';

class MlKitCameraResultView extends StatefulWidget {
  const MlKitCameraResultView(
      {Key? key,
      required this.color,
      required this.isMVP,
      this.initialDirection = CameraLensDirection.back})
      : super(key: key);
  // 카메라 렌즈 방향 변수
  final CameraLensDirection initialDirection;
  // mvp 스켈레톤 색
  final Color color;
  // 자신이 mvp인지 아닌지
  final bool isMVP;

  @override
  State<MlKitCameraResultView> createState() => _MlKitCameraResultViewState();
}

class _MlKitCameraResultViewState extends State<MlKitCameraResultView> {
  // 카메라를 다루기 위한 변수
  CameraController? _controller;
  // 카메라 인덱스
  int _cameraIndex = -1;
  // 확대 축소 레벨
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  // 스켈레톤 모양을 그려주는 변수
  CustomPaint? _customPaintMVP;
  // ml kit 변수
  bool _canProcess = true;
  bool _isBusy = false;
  int _frameNum = 0;
  // 스켈레톤 추출 변수 선언(google_mlkit_pose_detection 라이브러리)
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  late SocketStageProviderImpl _socketStageProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: _liveFeedBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    _socketStageProvider =
        Provider.of<SocketStageProviderImpl>(context, listen: false);

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

    // mvp고 카메라 실행 가능하면 포즈 추출 시작
    if (_cameraIndex != -1 && widget.isMVP) {
      _startLiveFeed();
    }
  }

  @override
  void dispose() {
    _canProcess = false;
    _isBusy = true;
    _customPaintMVP = null;
    _poseDetector.close();
    _controller?.dispose;

    super.dispose();
  }

  // 카메라 화면 보여주기 + 화면에서 실시간으로 포즈 추출
  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }
    if (widget.isMVP) {
      final size = MediaQuery.of(context).size;
      // 화면 및 카메라 비율에 따른 스케일 계산
      var scale = size.aspectRatio * _controller!.value.aspectRatio;

      // to prevent scaling down, invert the value
      if (scale < 1) scale = 1 / scale;
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const StageAppbarMusicInfoWidget(),
        // 추출된 스켈레톤 그리기
        _liveFeedBodyResult(),
      ],
    );
  }

  // 결과 화면: MVP 1명의 스켈레톤만 보임
  Widget _liveFeedBodyResult() {
    return Row(
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 4,
          child: Selector<SocketStageProviderImpl,
                  Map<PoseLandmarkType, PoseLandmark>?>(
              selector: (context, socketProvider) => socketProvider.mvpSkeleton,
              shouldRebuild: (prev, next) {
                return true;
              },
              builder: (context, mvp, child) {
                if (mvp != null) {
                  CustomPosePainter painterMVP = CustomPosePainter(
                      [Pose(landmarks: mvp)],
                      const Size(1280.0, 720.0),
                      InputImageRotation.rotation270deg,
                      widget.color);
                  _customPaintMVP = CustomPaint(painter: painterMVP);
                } else {
                  _customPaintMVP = null;
                }
                return (_customPaintMVP != null)
                    ? SizedBox(height: 200, child: _customPaintMVP!)
                    : Container();
              }),
        ),
        Expanded(flex: 2, child: Container()),
      ],
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
    // print("mmm 겨롸 저옹");
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

      var resuest =
          SendSkeletonRequest(frameNum: _frameNum, skeleton: resultMap);
      _socketStageProvider.sendMVPSkeleton(resuest);
    }
    _frameNum++;

    _isBusy = false;
  }
}
