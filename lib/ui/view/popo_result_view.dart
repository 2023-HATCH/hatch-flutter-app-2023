import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/config/ml_kit/custom_pose_painter.dart';
import 'package:pocket_pose/ui/screen/popo_stage_screen.dart';
import 'package:pocket_pose/ui/view/ml_kit_camera_view.dart';

// ml_kit_skeleton_custom_view
class PoPoResultView extends StatefulWidget {
  const PoPoResultView(
      {Key? key, required this.setStageState, required this.isResultState})
      : super(key: key);
  final Function setStageState;
  final bool isResultState;

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
  // 스켈레톤 추출할지 안할지, 추출한다면 배열에 저장할지 할지 관리하는 변수
  SkeletonDetectMode _skeletonDetectMode = SkeletonDetectMode.userMode;
  final bool _isPlayer = true;
  // input Lists
  final List<List<double>> _inputLists = [];

  @override
  Widget build(BuildContext context) {
    // 카메라뷰 보이기
    return Stack(
      children: [
        Positioned(
          top: 115,
          left: 35,
          right: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildMVPWidget('assets/images/home_profile_1.jpg', 'okoi2202'),
            ],
          ),
        ),
        CameraView(
          isResultState: widget.isResultState,
          setIsSkeletonDetectMode: setIsSkeletonDetectMode,
          // 스켈레톤 그려주는 객체 전달
          customPaint: _customPaint,
          // 카메라에서 전해주는 이미지 받을 때마다 아래 함수 실행
          onImage: (inputImage) {
            // player는 항상 스켈레톤 추출
            if (_skeletonDetectMode != SkeletonDetectMode.userMode ||
                _skeletonDetectMode != SkeletonDetectMode.musicEndMode) {
              processImage(inputImage);
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  Container buildMVPWidget(String profileImg, String nickName) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white, width: 3.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            for (double i = 1; i < 5; i++)
              BoxShadow(
                  color: AppColor.yellowColor,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 3 * i)
          ]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 8, 28, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'MVP',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                shadows: [
                  for (double i = 1; i < 6; i++)
                    Shadow(color: AppColor.yellowColor, blurRadius: 3 * i)
                ],
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SvgPicture.asset(
                  'assets/images/img_stage_result_mvp.svg',
                  width: 80,
                  height: 90,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 0, 0, 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      profileImg,
                      width: 62,
                      height: 62,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              nickName,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // 카메라에서 실시간으로 받아온 이미지 처리: 이미지에 포즈가 추출되었으면 스켈레톤 그려주기
  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    // poseDetector에서 추출된 포즈 가져오기
    List<Pose> poses = await _poseDetector.processImage(inputImage);

    for (final pose in poses) {
      _inputLists.add(_poseMapToInputList(pose.landmarks));
    }

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

  void setIsSkeletonDetectMode(SkeletonDetectMode mode) async {
    if (_isPlayer && mounted) {
      setState(() {
        _skeletonDetectMode = mode;

        // 노래 끝나면 대기 화면으로 이동
        if (_skeletonDetectMode == SkeletonDetectMode.musicEndMode) {
          _inputLists.clear();
          widget.setStageState(StageStage.waitState);
        }
      });
    }
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
}
