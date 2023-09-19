import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_player_list_item.dart';
import 'package:pocket_pose/ui/view/stage/ml_kit_camera_play_view.dart';
import 'package:provider/provider.dart';

// ml_kit_skeleton_custom_view
class PoPoPlayView extends StatefulWidget {
  final List<StagePlayerListItem> players;
  const PoPoPlayView({Key? key, required this.players, this.userId})
      : super(key: key);
  final String? userId;

  @override
  State<StatefulWidget> createState() => _PoPoPlayViewState();
}

class _PoPoPlayViewState extends State<PoPoPlayView> {
  late StageProviderImpl _stageProvider;

  int _playerNum = -1;
  int _midEnterSeconds = -1;

  @override
  void initState() {
    _stageProvider = Provider.of<StageProviderImpl>(context, listen: false);
    AudioPlayerUtil().stop();

    for (var player in widget.players) {
      if (player.userId == widget.userId) {
        _playerNum = player.playerNum!;
      }
    }

    if (_playerNum != -1) {
      Fluttertoast.showToast(
        msg: "캐치 성공!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    _onMidEnter();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 카메라뷰 보이기
    return Stack(
      children: [
        _buildPlayerProfile(),
        MlKitCameraPlayView(
          playerNum: _playerNum,
          midEnterSeconds: _midEnterSeconds,
        ),
      ],
    );
  }

  void _onMidEnter() {
    // 중간 입장인 경우
    if (_stageProvider.stageCurTime != null) {
      // 중간 입장한 초부터 시작
      _midEnterSeconds =
          (_stageProvider.stageCurTime! / (1000000 * 1000)).round();
      _stageProvider.setStageCurSecondNULL();
    }
  }

  Widget _buildPlayerProfile() {
    switch (widget.players.length) {
      case 1:
        return Positioned(
          top: 115,
          left: 100,
          right: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getProfile(
                  widget.players[0].profileImg,
                  widget.players[0].nickname,
                  context.select<SocketStageProviderImpl, double?>(
                      (provider) => provider.midScores?[0].similarity)),
            ],
          ),
        );

      case 2:
        return Positioned(
          top: 115,
          left: 65,
          right: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getProfile(
                  widget.players[1].profileImg,
                  widget.players[1].nickname,
                  context.select<SocketStageProviderImpl, double?>(
                      (provider) => provider.midScores?[1].similarity)),
              getProfile(
                  widget.players[0].profileImg,
                  widget.players[0].nickname,
                  context.select<SocketStageProviderImpl, double?>(
                      (provider) => provider.midScores?[0].similarity)),
            ],
          ),
        );
      case 3:
        return Positioned(
          top: 115,
          left: 35,
          right: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getProfile(
                  widget.players[1].profileImg,
                  widget.players[1].nickname,
                  context.select<SocketStageProviderImpl, double?>(
                      (provider) => provider.midScores?[1].similarity)),
              getProfile(
                  widget.players[0].profileImg,
                  widget.players[0].nickname,
                  context.select<SocketStageProviderImpl, double?>(
                      (provider) => provider.midScores?[0].similarity)),
              getProfile(
                  widget.players[2].profileImg,
                  widget.players[2].nickname,
                  context.select<SocketStageProviderImpl, double?>(
                      (provider) => provider.midScores?[2].similarity)),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  Column getProfile(String? profileImg, String nickName, double? score) {
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

  Widget getScoreNeonText(double? similarity) {
    String scoreText = "";
    Color scoreNeonColor = Colors.transparent;

    if (similarity == null) {
      scoreText = "";
    } else if (similarity < -1) {
      scoreText = "Bad";
      scoreNeonColor = Colors.red;
    } else if (similarity < 0.4) {
      scoreText = "Good";
      scoreNeonColor = AppColor.purpleColor2;
    } else if (similarity < 0.6) {
      scoreText = "Great";
      scoreNeonColor = AppColor.greenColor;
    } else if (similarity < 0.8) {
      scoreText = "Excellent";
      scoreNeonColor = AppColor.blueColor2;
    } else if (similarity <= 1.0) {
      scoreText = "Perfect";
      scoreNeonColor = AppColor.yellowColor2;
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
}
