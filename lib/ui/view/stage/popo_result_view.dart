import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_player_list_item.dart';
import 'package:pocket_pose/ui/view/stage/ml_kit_camera_result_view.dart';
import 'package:pocket_pose/ui/widget/stage/stage_result_player_info_widget.dart';
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
  final _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
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
  void dispose() {
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 카메라뷰 보이기
    return Stack(
      children: [
        MlKitCameraResultView(
          color: skeletonColorList[widget.mvp?.playerNum ?? 0],
          isMVP: widget.isMVP,
        ),
        Positioned(
          top: 0,
          right: 15,
          bottom: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var index = 0;
                      index < _socketStageProvider.playerInfos.length;
                      index++)
                    StageResultPlayerInfoWidget(
                        player: _socketStageProvider.playerInfos[index],
                        index: index)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onMidEnter() {
    AudioPlayerUtil().setVolume(0.8);

    // 중간임장인 경우
    if (_stageProvider.stageCurTime != null) {
      // 중간 입장한 초부터 시작
      var seconds = (_stageProvider.stageCurTime! / (1000000 * 1000)).round();
      _stageProvider.setStageCurSecondNULL();
      (_socketStageProvider.catchMusicData != null)
          ? AudioPlayerUtil()
              .playSeek(seconds, _socketStageProvider.catchMusicData!.musicUrl)
          : AudioPlayerUtil().playSeek(seconds, _stageProvider.music!.musicUrl);
      _playResultSound(seconds);
    } else {
      (_socketStageProvider.catchMusicData != null)
          ? AudioPlayerUtil()
              .play(_socketStageProvider.catchMusicData!.musicUrl)
          : AudioPlayerUtil().play(_stageProvider.music!.musicUrl);
      _playResultSound(0);
    }
  }

  void _playResultSound(int startSecond) {
    _assetsAudioPlayer.setVolume(0.4);
    _assetsAudioPlayer.open(Audio("assets/audios/sound_stage_result.mp3"),
        seek: Duration(microseconds: startSecond));
  }
}
