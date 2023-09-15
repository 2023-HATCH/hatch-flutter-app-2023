import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_player_list_item.dart';
import 'package:pocket_pose/ui/view/stage/ml_kit_camera_play_view.dart';
import 'package:provider/provider.dart';

enum StagePlayScore { bad, good, great, excellent, perfect, none }

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
  int _playerNum = -1;

  @override
  void initState() {
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("mmm play rebuild");

    // 카메라뷰 보이기
    return Stack(
      children: [
        _buildPlayerProfile(),
        MlKitCameraPlayView(
          playerNum: _playerNum,
        ),
      ],
    );
  }

  Positioned _buildPlayerProfile() {
    var players =
        context.select<SocketStageProviderImpl, List<StagePlayerListItem>>(
            (provider) => provider.players);
    switch (players.length) {
      case 1:
        return Positioned(
          top: 115,
          left: 100,
          right: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getProfile(widget.players[0].profileImg,
                  widget.players[0].nickname, StagePlayScore.perfect),
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
              getProfile(widget.players[1].profileImg,
                  widget.players[1].nickname, StagePlayScore.good),
              getProfile(widget.players[0].profileImg,
                  widget.players[0].nickname, StagePlayScore.perfect),
            ],
          ),
        );
      default:
        return Positioned(
          top: 115,
          left: 35,
          right: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getProfile(widget.players[1].profileImg,
                  widget.players[1].nickname, StagePlayScore.good),
              getProfile(widget.players[0].profileImg,
                  widget.players[0].nickname, StagePlayScore.perfect),
              getProfile(widget.players[2].profileImg,
                  widget.players[2].nickname, StagePlayScore.excellent),
            ],
          ),
        );
    }
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
}
