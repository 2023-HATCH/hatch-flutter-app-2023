import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pocket_pose/config/ml_kit/custom_pose_painter.dart';
import 'package:pocket_pose/ui/screen/popo_stage_screen.dart';
import 'package:pocket_pose/ui/view/ml_kit_camera_view.dart';

class PoPoResultView extends StatefulWidget {
  PoPoResultView(
      {Key? key, required this.setStageState, required this.isResultState})
      : super(key: key);
  Function setStageState;
  bool isResultState;

  @override
  State<StatefulWidget> createState() => _PoPoResultViewState();
}

class _PoPoResultViewState extends State<PoPoResultView> {
  // 스켈레톤 추출 변수 선언(google_mlkit_pose_detection 라이브러리)
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  // 스켈레톤 모양을 그려주는 변수
  CustomPaint? _customPaint;
  // start, end btn trigger
  bool _isStarted = false;
  int _seconds = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 5) {
        _stopTimer();
        widget.setStageState(StageStage.waitState);
      } else {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 카메라뷰 보이기
    return CameraView(
      isResultState: widget.isResultState,
      setIsSkeletonDetectStart: setIsStarted,
      // 스켈레톤 그려주는 객체 전달
      customPaint: _customPaint,
      // 카메라에서 전해주는 이미지 받을 때마다 아래 함수 실행
      onImage: (inputImage) {
        // start 버튼 눌렀을 때만 스켈레톤 추출
        if (_isStarted) {
          processImage(inputImage);
        }
      },
    );
  }

  // 카메라에서 실시간으로 받아온 이미지 처리: 이미지에 포즈가 추출되었으면 스켈레톤 그려주기
  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    // poseDetector에서 추출된 포즈 가져오기
    List<Pose> poses = await _poseDetector.processImage(inputImage);

    // 이미지가 정상적이면 포즈에 스켈레톤 그려주기
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      // 여기만 2개만 수정 ! PosePainter -> CustomPosePainter
      final painter = CustomPosePainter(poses, inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      // 추출된 포즈 없음
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  void setIsStarted(bool bool) async {
    setState(() {
      _isStarted = bool;
    });
  }
}
