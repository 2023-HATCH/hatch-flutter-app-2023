import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_player_list_item.dart';
import 'package:pocket_pose/ui/view/stage/ml_kit_camera_result_view.dart';
import 'package:provider/provider.dart';

// ml_kit_skeleton_custom_view
class PoPoResultView extends StatefulWidget {
  const PoPoResultView({Key? key, this.mvp, required this.isMVP})
      : super(key: key);
  final StagePlayerListItem? mvp;
  final bool isMVP;

  @override
  State<StatefulWidget> createState() => _PoPoResultViewState();
}

class _PoPoResultViewState extends State<PoPoResultView> {
  late StageProviderImpl _stageProvider;
  late SocketStageProviderImpl _socketStageProvider;
  // 스켈레톤 색 배열
  final skeletonColorList = [
    AppColor.mintNeonColor,
    AppColor.yellowNeonColor,
    AppColor.greenNeonColor
  ];

  @override
  void initState() {
    _stageProvider = Provider.of<StageProviderImpl>(context, listen: false);
    _socketStageProvider =
        Provider.of<SocketStageProviderImpl>(context, listen: false);

    if (widget.isMVP) {
      Fluttertoast.showToast(
        msg: "춤 짱은 바로 나!!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    // 입장 처리
    _onMidEnter();

    super.initState();
  }

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
              (widget.mvp != null) ? buildMVPWidget(widget.mvp!) : Container()
            ],
          ),
        ),
        Positioned(
          top: 115,
          right: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _socketStageProvider.playerInfos.map((element) {
              return Text(
                "${element.player.nickname}: ${element.similarity}",
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              );
            }).toList(),
          ),
        ),
        MlKitCameraResultView(
          color: skeletonColorList[widget.mvp?.playerNum ?? 0],
          isMVP: widget.isMVP,
        ),
      ],
    );
  }

  void _onMidEnter() {
    (_socketStageProvider.catchMusicData != null)
        ? AudioPlayerUtil()
            .setMusicUrl(_socketStageProvider.catchMusicData!.musicUrl)
        : AudioPlayerUtil().setMusicUrl(_stageProvider.music!.musicUrl);
    AudioPlayerUtil().setVolume(0.8);

    // 중간임장인 경우
    if (_stageProvider.stageCurTime != null) {
      // 중간 입장한 초부터 시작
      var seconds = (_stageProvider.stageCurTime! / (1000000 * 1000)).round();
      _stageProvider.setStageCurSecondNULL();
      AudioPlayerUtil().playSeek(seconds);
    } else {
      AudioPlayerUtil().play();
    }
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
}
