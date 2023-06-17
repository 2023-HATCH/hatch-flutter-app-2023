<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pocket_pose/config/ml_kit/custom_pose_painter.dart';
<<<<<<<< HEAD:lib/ui/view/popo_result_view.dart
import 'package:pocket_pose/ui/screen/popo_stage_screen.dart';
<<<<<<< HEAD
import 'package:pocket_pose/ui/view/ml_kit_camera_view.dart';
=======
import 'package:pocket_pose/ui/view/camera_view.dart';
>>>>>>> 37d01c2 (:pencil2: [fix] #10 머지 오류 해결)

// ml_kit_skeleton_custom_view
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
========
import 'package:pocket_pose/data/remote/provider/popo_skeleton_provider_impl.dart';
import 'package:pocket_pose/ui/screen/popo_stage_screen.dart';
import 'package:pocket_pose/ui/view/ml_kit_camera_view.dart';

// ml_kit_skeleton_custom_view
class PoPoPlayView extends StatefulWidget {
  PoPoPlayView(
=======
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pocket_pose/config/ml_kit/custom_pose_painter.dart';
import 'package:pocket_pose/ui/screen/popo_stage_screen.dart';
import 'package:pocket_pose/ui/view/ml_kit_camera_view.dart';

class PoPoResultView extends StatefulWidget {
  PoPoResultView(
>>>>>>> 123816c (:sparkles: [feat] 포포 스테이지: 스테이지 상태에 따른 화면 이동 구현)
      {Key? key, required this.setStageState, required this.getStageState})
      : super(key: key);
  Function setStageState;
  Function getStageState;

  @override
<<<<<<< HEAD
  State<StatefulWidget> createState() => _PoPoPlayViewState();
}

class _PoPoPlayViewState extends State<PoPoPlayView> {
>>>>>>>> 123816c (:sparkles: [feat] 포포 스테이지: 스테이지 상태에 따른 화면 이동 구현):lib/ui/view/popo_play_view.dart
=======
  State<StatefulWidget> createState() => _PoPoResultViewState();
}

class _PoPoResultViewState extends State<PoPoResultView> {
>>>>>>> 123816c (:sparkles: [feat] 포포 스테이지: 스테이지 상태에 따른 화면 이동 구현)
  // 스켈레톤 추출 변수 선언(google_mlkit_pose_detection 라이브러리)
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  // 스켈레톤 모양을 그려주는 변수
  CustomPaint? _customPaint;
  // start, end btn trigger
  bool _isStarted = false;
<<<<<<< HEAD
  // input Lists
  final List<List<double>> _inputLists = [];
=======
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
>>>>>>> 123816c (:sparkles: [feat] 포포 스테이지: 스테이지 상태에 따른 화면 이동 구현)

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
<<<<<<< HEAD
=======
    _stopTimer();
>>>>>>> 123816c (:sparkles: [feat] 포포 스테이지: 스테이지 상태에 따른 화면 이동 구현)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 카메라뷰 보이기
    return CameraView(
<<<<<<< HEAD
<<<<<<<< HEAD:lib/ui/view/popo_result_view.dart
      isResultState: widget.isResultState,
========
      getStageState: widget.getStageState,
>>>>>>>> 123816c (:sparkles: [feat] 포포 스테이지: 스테이지 상태에 따른 화면 이동 구현):lib/ui/view/popo_play_view.dart
=======
      getStageState: widget.getStageState,
>>>>>>> 123816c (:sparkles: [feat] 포포 스테이지: 스테이지 상태에 따른 화면 이동 구현)
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

<<<<<<< HEAD
    for (final pose in poses) {
      _inputLists.add(_poseMapToInputList(pose.landmarks));
    }

=======
>>>>>>> 123816c (:sparkles: [feat] 포포 스테이지: 스테이지 상태에 따른 화면 이동 구현)
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
<<<<<<< HEAD

      if (!_isStarted) {
<<<<<<<< HEAD:lib/ui/view/popo_result_view.dart
        _inputLists.clear();
        widget.setStageState(StageStage.waitState);
========
        _provider
            .postSkeletonList(_inputLists)
            .then((value) => Fluttertoast.showToast(
                  msg: value.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                ))
            .then((_) => _inputLists.clear())
            .then((_) => widget.setStageState(StageStage.resultState));
>>>>>>>> 123816c (:sparkles: [feat] 포포 스테이지: 스테이지 상태에 따른 화면 이동 구현):lib/ui/view/popo_play_view.dart
      }
    });
  }

  List<double> _poseMapToInputList(Map<PoseLandmarkType, PoseLandmark> entry) {
    return [
      entry[PoseLandmarkType.nose]!.x,
      entry[PoseLandmarkType.nose]!.y,
      entry[PoseLandmarkType.rightShoulder]!.x,
      entry[PoseLandmarkType.rightShoulder]!.y,
      entry[PoseLandmarkType.rightElbow]!.x,
      entry[PoseLandmarkType.rightElbow]!.y,
      entry[PoseLandmarkType.rightWrist]!.x,
      entry[PoseLandmarkType.rightWrist]!.y,
      entry[PoseLandmarkType.leftShoulder]!.x,
      entry[PoseLandmarkType.leftShoulder]!.y,
      entry[PoseLandmarkType.leftElbow]!.x,
      entry[PoseLandmarkType.leftElbow]!.y,
      entry[PoseLandmarkType.leftWrist]!.x,
      entry[PoseLandmarkType.leftWrist]!.y,
      entry[PoseLandmarkType.rightHip]!.x,
      entry[PoseLandmarkType.rightHip]!.y,
      entry[PoseLandmarkType.rightKnee]!.x,
      entry[PoseLandmarkType.rightKnee]!.y,
      entry[PoseLandmarkType.rightAnkle]!.x,
      entry[PoseLandmarkType.rightAnkle]!.y,
      entry[PoseLandmarkType.leftHip]!.x,
      entry[PoseLandmarkType.leftHip]!.y,
      entry[PoseLandmarkType.leftKnee]!.x,
      entry[PoseLandmarkType.leftKnee]!.y,
      entry[PoseLandmarkType.leftAnkle]!.x,
      entry[PoseLandmarkType.leftAnkle]!.y
    ];
  }
=======
    });
  }
>>>>>>> 123816c (:sparkles: [feat] 포포 스테이지: 스테이지 상태에 따른 화면 이동 구현)
}
