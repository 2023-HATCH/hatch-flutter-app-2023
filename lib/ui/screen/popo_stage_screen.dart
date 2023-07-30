import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_user_list_item.dart';
import 'package:pocket_pose/domain/provider/stage_provider.dart';
import 'package:pocket_pose/ui/view/popo_play_view.dart';
import 'package:pocket_pose/ui/view/popo_catch_view.dart';
import 'package:pocket_pose/ui/view/popo_result_view.dart';
import 'package:pocket_pose/ui/view/popo_wait_view.dart';
import 'package:pocket_pose/ui/widget/stage/stage_live_chat_bar_widget.dart';
import 'package:pocket_pose/ui/widget/stage/stage_live_chat_list.widget.dart';
import 'package:provider/provider.dart';

enum StageStage { waitState, catchState, playState, resultState }

class PoPoStageScreen extends StatefulWidget {
  const PoPoStageScreen({super.key, required this.getIndex()});
  final Function getIndex;

  @override
  State<PoPoStageScreen> createState() => _PoPoStageScreenState();
}

class _PoPoStageScreenState extends State<PoPoStageScreen> {
  int _userCount = 1;
  int _count = 1;
  late Timer _timer;
  late VideoPlayProvider _videoPlayProvider;
  final StageProvider _stageProvider = StageProviderImpl();
  StageStage _stageStage = StageStage.waitState;

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            // 플레이, 결과 상태에 따라 배경화면 변경
            decoration: buildBackgroundImage(),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              appBar: buildAppBar(context),
              body: Stack(
                children: [
                  _buildStageView(_stageStage),
                  const Positioned(
                    bottom: 68,
                    left: 0,
                    right: 0,
                    child: StageLiveChatListWidget(),
                  ),
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: StageLiveChatBarWidget(),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  @override
  void dispose() {
    AudioPlayerUtil().stop();
    if (widget.getIndex() == 0) {
      _videoPlayProvider.playVideo();
    }
    super.dispose();
  }

  BoxDecoration buildBackgroundImage() {
    return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage((getIsResultState())
            ? 'assets/images/bg_popo_result.png'
            : 'assets/images/bg_popo_comm.png'),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "PoPo 스테이지",
        style: TextStyle(fontSize: 18),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        onPressed: () {
          AudioPlayerUtil().stop();
          if (widget.getIndex() == 0) {
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        },
        icon: SvgPicture.asset(
          'assets/icons/ic_stage_back_white.svg',
        ),
      ),
      actions: [
        _buildUserCountWidget(),
      ],
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_userCount >= 5) {
          _stopTimer();

          setState(() {
            _stageStage = StageStage.catchState;
          });
        } else {
          setState(() {
            _count++;
            _userCount = _count;
          });
        }
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  void setStageState(StageStage newStageStage) {
    if (mounted) {
      setState(() {
        _stageStage = newStageStage;
      });
    }
  }

  bool getIsResultState() => _stageStage == StageStage.resultState;

  Container _buildUserCountWidget() {
    return Container(
      margin: const EdgeInsets.only(right: 16.0, top: 10.0, bottom: 10.0),
      child: OutlinedButton.icon(
        onPressed: () async {
          var response = await _stageProvider.getUserList();
          print("mmm rrrr: ${response.data}");

          _showUserListDialog(response.data.list ?? []);
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          side: const BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        icon: SvgPicture.asset(
          'assets/icons/ic_users.svg',
        ),
        label: Text(
          '$_userCount',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<dynamic> _showUserListDialog(List<StageUserListItem> userList) {
    return showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              backgroundColor: Colors.white.withOpacity(0.3),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      '참여자 목록',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 265,
                height: 365,
                child: GridView.builder(
                  itemCount: userList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: (userList.elementAt(index).profileImg == null)
                              ? Image.asset(
                                  'assets/images/charactor_popo_default.png',
                                  width: 58,
                                  height: 58,
                                )
                              : Image.network(
                                  userList.elementAt(index).profileImg!,
                                  fit: BoxFit.cover,
                                  width: 58,
                                  height: 58,
                                ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          userList.elementAt(index).nickname,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  Widget _buildStageView(StageStage state) {
    switch (state) {
      case StageStage.waitState:
        return (_userCount < 3)
            ? const PoPoWaitView()
            : PoPoCatchView(setStageState: setStageState);
      case StageStage.catchState:
        return PoPoCatchView(setStageState: setStageState);
      case StageStage.playState:
        return PoPoPlayView(
            setStageState: setStageState, isResultState: getIsResultState());
      case StageStage.resultState:
        return PoPoResultView(
            setStageState: setStageState, isResultState: getIsResultState());
      default:
        return const PoPoWaitView();
    }
  }
}
