import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/config/ml_kit/custom_pose_painter.dart';
import 'package:pocket_pose/data/entity/socket_request/send_skeleton_request.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_player_list_item.dart';
import 'package:pocket_pose/domain/entity/stage_skeleton_pose_landmark.dart';
import 'package:pocket_pose/ui/view/ml_kit_camera_view.dart';
import 'package:provider/provider.dart';

enum StagePlayScore { bad, good, great, excellent, perfect, none }

// ml_kit_skeleton_custom_view
class PoPoPlayView extends StatefulWidget {
  final List<StagePlayerListItem> players;
  const PoPoPlayView(
      {Key? key,
      required this.isResultState,
      required this.players,
      this.userId})
      : super(key: key);
  final bool isResultState;
  final String? userId;

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
  bool _isPlayer = false;
  int _playerNum = -1;
  int _frameNum = 0;

  late SocketStageProviderImpl _socketStageProvider;

  @override
  void initState() {
    for (var player in widget.players) {
      if (player.userId == widget.userId) {
        _isPlayer = true;
        _playerNum = player.playerNum!;
      }
    }

    if (_isPlayer) {
      Fluttertoast.showToast(
        msg: "캐치 성공!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _socketStageProvider =
        Provider.of<SocketStageProviderImpl>(context, listen: true);

    if (_socketStageProvider.isPlaySkeletonChange) {
      _socketStageProvider.setIsPlaySkeletonChange(false);
      _paintSkeleton();
    }

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
                    widget.players[0].nickname, StagePlayScore.perfect)
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
        if (_isPlayer)
          CameraView(
            isResultState: widget.isResultState,
            // 스켈레톤 그려주는 객체 전달
            customPaintLeft: _customPaintLeft,
            customPaintMid: _customPaintMid,
            customPaintRight: _customPaintRight,
            // 카메라에서 전해주는 이미지 받을 때마다 아래 함수 실행
            onImage: (inputImage) {
              processImage(inputImage);
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
          playerNum: _playerNum, frameNum: _frameNum, skeleton: resultMap);
      _socketStageProvider.sendPlaySkeleton(resuest);
    }
    _frameNum++;

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _paintSkeleton() {
    if (_socketStageProvider.player1 != null) {
      CustomPosePainter painterLeft = CustomPosePainter(
          [Pose(landmarks: _socketStageProvider.player1 ?? {})],
          const Size(1280.0, 720.0),
          InputImageRotation.rotation270deg,
          AppColor.yellowNeonColor);
      _customPaintLeft = CustomPaint(painter: painterLeft);
    } else {
      _customPaintLeft = null;
    }

    if (_socketStageProvider.player0 != null) {
      CustomPosePainter painterMid = CustomPosePainter(
          [Pose(landmarks: _socketStageProvider.player0 ?? {})],
          const Size(1280.0, 720.0),
          InputImageRotation.rotation270deg,
          AppColor.mintNeonColor);
      _customPaintMid = CustomPaint(painter: painterMid);
    } else {
      _customPaintMid = null;
    }

    if (_socketStageProvider.player2 != null) {
      CustomPosePainter painterRignt = CustomPosePainter(
          [Pose(landmarks: _socketStageProvider.player2 ?? {})],
          const Size(1280.0, 720.0),
          InputImageRotation.rotation270deg,
          AppColor.greenNeonColor);
      _customPaintRight = CustomPaint(painter: painterRignt);
    } else {
      _customPaintRight = null;
    }
  }
}
