import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/config/ml_kit/custom_pose_painter.dart';
import 'package:pocket_pose/data/remote/provider/popo_skeleton_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_player_list_item.dart';
import 'package:pocket_pose/ui/view/ml_kit_camera_view.dart';

enum StagePlayScore { bad, good, great, excellent, perfect, none }

// ml_kit_skeleton_custom_view
class PoPoPlayView extends StatefulWidget {
  final List<StagePlayerListItem> players;
  const PoPoPlayView(
      {Key? key, required this.isResultState, required this.players})
      : super(key: key);
  final bool isResultState;

  @override
  State<StatefulWidget> createState() => _PoPoPlayViewState();
}

class _PoPoPlayViewState extends State<PoPoPlayView> {
  // 스켈레톤 추출 변수 선언(google_mlkit_pose_detection 라이브러리)
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  // 스켈레톤 모양을 그려주는 변수
  CustomPaint? _customPaintLeft;
  CustomPaint? _customPaintMid;
  CustomPaint? _customPaintRight;
  // 스켈레톤 추출할지 안할지, 추출한다면 배열에 저장할지 할지 관리하는 변수
  SkeletonDetectMode _skeletonDetectMode = SkeletonDetectMode.userMode;
  final bool _isPlayer = true;
  // input Lists
  final List<List<double>> _inputLists = [];
  final _provider = PoPoSkeletonProviderImpl();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.players.length > 1)
                getProfile(widget.players[1].profileImg,
                    widget.players[1].nickname, StagePlayScore.good)
              else
                Visibility(
                    visible: false,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: getProfile(null, "", StagePlayScore.none)),
              if (widget.players.isNotEmpty)
                getProfile(widget.players[0].profileImg,
                    widget.players[0].nickname, StagePlayScore.bad)
              else
                Visibility(
                    visible: false,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: getProfile(null, "", StagePlayScore.none)),
              if (widget.players.length > 2)
                getProfile(widget.players[2].profileImg,
                    widget.players[2].nickname, StagePlayScore.excellent)
              else
                Visibility(
                    visible: false,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: getProfile(null, "", StagePlayScore.none)),
            ],
          ),
        ),
        CameraView(
          isResultState: widget.isResultState,
          setIsSkeletonDetectMode: setIsSkeletonDetectMode,
          // 스켈레톤 그려주는 객체 전달
          customPaintLeft: _customPaintLeft,
          customPaintMid: _customPaintMid,
          customPaintRight: _customPaintRight,
          // 카메라에서 전해주는 이미지 받을 때마다 아래 함수 실행
          onImage: (inputImage) {
            // user이거나 노래가 종료된 거 아닌 이상 항상 스켈레톤 추출
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

  Column getProfile(String? profileImg, String nickName, StagePlayScore score) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: (profileImg == null)
              ? Image.asset(
                  'assets/images/charactor_popo_default.png',
                  width: 50,
                  height: 50,
                )
              : Image.network(
                  profileImg,
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          nickName,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(
          height: 8,
        ),
        getScoreNeonText(score),
      ],
    );
  }

  Widget getScoreNeonText(StagePlayScore score) {
    String scoreText = "";
    Color scoreNeonColor = Colors.transparent;
    switch (score) {
      case StagePlayScore.bad:
        scoreText = "Bad";
        scoreNeonColor = Colors.red;
        break;
      case StagePlayScore.good:
        scoreText = "Good";
        scoreNeonColor = AppColor.purpleColor2;
        break;
      case StagePlayScore.great:
        scoreText = "Great";
        scoreNeonColor = AppColor.greenColor;
        break;
      case StagePlayScore.excellent:
        scoreText = "Excellent";
        scoreNeonColor = AppColor.blueColor2;
        break;
      case StagePlayScore.perfect:
        scoreText = "Perfect";
        scoreNeonColor = AppColor.yellowColor2;
        break;
      case StagePlayScore.none:
        scoreText = "";
        break;
    }

    return SizedBox(
      width: 90,
      child: Text(
        scoreText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          shadows: [
            for (double i = 1; i < 6; i++)
              Shadow(color: scoreNeonColor, blurRadius: 3 * i)
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

    // 사용자가 춤 추기 시작할 때 스켈레톤 배열에 저장
    if (_skeletonDetectMode == SkeletonDetectMode.musicStartMode) {
      for (final pose in poses) {
        _inputLists.add(_poseMapToInputList(pose.landmarks));
      }
    }

    // 이미지가 정상적이면 포즈에 스켈레톤 그려주기
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      // 여기만 2개만 수정 ! PosePainter -> CustomPosePainter
      final painterLeft = CustomPosePainter(
          poses,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation,
          AppColor.yellowNeonColor);
      final painterMid = CustomPosePainter(
          poses,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation,
          AppColor.mintNeonColor);
      final painterRignt = CustomPosePainter(
          poses,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation,
          AppColor.greenNeonColor);
      _customPaintLeft = CustomPaint(painter: painterLeft);
      _customPaintMid = CustomPaint(painter: painterMid);
      _customPaintRight = CustomPaint(painter: painterRignt);
    } else {
      // 추출된 포즈 없음
      _customPaintLeft = null;
      _customPaintMid = null;
      _customPaintRight = null;
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

        // 노래 끝나면 스켈레톤 서버에 보내기
        if (_skeletonDetectMode == SkeletonDetectMode.musicEndMode) {
          // 스켈레톤 파일로 저장: 실행 안 되도록 설정
          if (1 > 2) {
            skeletonToFile(_inputLists);
          }

          // // ai 서버 오류로 잠시 주석처리
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
              .then((_) => _inputLists.clear());
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

  Future<void> skeletonToFile(List<List<double>> inputLists) async {
    var today = DateTime.now().toString().substring(0, 9);
    var now = DateTime.now();

    final dir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOCUMENTS);
    // 폴더 생성
    String folderPath = '$dir/PoPo';
    await Directory(folderPath).create(recursive: true);
    // 파일 생성 및 저장
    final path =
        '$dir/PoPo/popo-skeleton-$today-${now.hour}-${now.minute}-${now.second}.txt';
    File(path).writeAsString(inputLists.toString());
  }
}
