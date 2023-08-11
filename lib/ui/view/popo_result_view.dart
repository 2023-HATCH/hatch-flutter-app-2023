import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

// ml_kit_skeleton_custom_view
class PoPoResultView extends StatefulWidget {
  const PoPoResultView(
      {Key? key, required this.isResultState, this.mvp, required this.userId})
      : super(key: key);
  final bool isResultState;
  final StagePlayerListItem? mvp;
  final String userId;

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
  CustomPaint? _customPaintMid;
  bool _isPlayer = false;
  // 스켈레톤 전송
  int _frameNum = 0;
  late SocketStageProviderImpl _socketStageProvider;
  final skeletonColorList = [
    AppColor.mintNeonColor,
    AppColor.yellowNeonColor,
    AppColor.greenNeonColor
  ];

  @override
  void initState() {
    if (widget.userId == widget.mvp?.userId) {
      _isPlayer = true;
    }

    if (_isPlayer) {
      Fluttertoast.showToast(
        msg: "춤 짱은 바로 나!!",
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

    if (_socketStageProvider.isMVPSkeletonChange) {
      _socketStageProvider.setIsMVPSkeletonChange(false);
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (widget.mvp != null) ? buildMVPWidget(widget.mvp!) : Container()
            ],
          ),
        ),
        CameraView(
          isResultState: widget.isResultState,
          // 스켈레톤 그려주는 객체 전달
          customPaintMid: _customPaintMid,
          // 카메라에서 전해주는 이미지 받을 때마다 아래 함수 실행
          onImage: (inputImage) {
            // 플레이어만 스켈레톤 추출
            if (_isPlayer) {
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

  void _paintSkeleton() {
    CustomPosePainter painterMid = CustomPosePainter(
        [Pose(landmarks: _socketStageProvider.mvpSkeleton ?? {})],
        const Size(1280.0, 720.0),
        InputImageRotation.rotation270deg,
        skeletonColorList[widget.mvp!.playerNum!]);
    _customPaintMid = CustomPaint(painter: painterMid);
  }

  Container buildMVPWidget(StagePlayerListItem user) {
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
                fontSize: 22,
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
                    child: (user.profileImg == null)
                        ? Image.asset(
                            'assets/images/charactor_popo_default.png',
                            width: 62,
                            height: 62,
                          )
                        : Image.network(
                            user.profileImg!,
                            fit: BoxFit.cover,
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
              user.nickname,
              style: const TextStyle(color: Colors.white, fontSize: 12),
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
    if (mounted) {
      setState(() {});
    }
  }
}
