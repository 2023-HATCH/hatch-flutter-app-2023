import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/data/entity/request/stage_enter_request.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_user_list_item.dart';
import 'package:pocket_pose/ui/widget/stage/stage_live_chat_bar_widget.dart';
import 'package:pocket_pose/ui/widget/stage/stage_live_talk_list_widget.dart';
import 'package:pocket_pose/ui/widget/stage/user_list_item_widget.dart';
import 'package:provider/provider.dart';

class PoPoStageScreen extends StatefulWidget {
  const PoPoStageScreen({super.key, required this.getIndex()});
  final Function getIndex;

  @override
  State<PoPoStageScreen> createState() => _PoPoStageScreenState();
}

class _PoPoStageScreenState extends State<PoPoStageScreen> {
  bool _isEnter = false;
  late VideoPlayProvider _videoPlayProvider;
  late StageProviderImpl _stageProvider;
  late SocketStageProviderImpl _socketStageProvider;

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
    _stageProvider = Provider.of<StageProviderImpl>(context, listen: true);
    _socketStageProvider =
        Provider.of<SocketStageProviderImpl>(context, listen: true);

    // 입장
    _popoStageEnter();
    // 소켓 반응 처리
    _onSocketResponse();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            // 플레이, 결과 상태에 따라 배경화면 변경
            decoration: _buildBackgroundImage(),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
              appBar: _buildAppBar(context),
              body: Stack(
                children: [
                  _socketStageProvider
                      .buildStageView(_socketStageProvider.stageType),
                  const Positioned(
                    bottom: 68,
                    left: 0,
                    right: 0,
                    child: StageLiveTalkListWidget(),
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
  }

  @override
  void dispose() {
    AudioPlayerUtil().stop();
    if (widget.getIndex() == 0) {
      _videoPlayProvider.playVideo();
    }

    if (_isEnter) {
      _socketStageProvider.deactivateWebSocket();
      _stageProvider.getStageExit();
      _isEnter = false;
    }

    super.dispose();
  }

  void _popoStageEnter() {
    if (!_isEnter) {
      _isEnter = true;
      _socketStageProvider.connectWebSocket();
      if (_socketStageProvider.isConnect) {
        _stageProvider
            .getStageEnter(StageEnterRequest(page: 0, size: 10))
            .then((value) =>
                _socketStageProvider.setUserCount(value.data.userCount))
            .then((_) => _socketStageProvider.onSubscribe());
      }
    }
  }

  void _onSocketResponse() {
    // 실시간 사용자 숫자
    if (_socketStageProvider.isUserCountChange) {
      _socketStageProvider.setIsUserCountChange(false);
      _stageProvider.getUserList();
    }

    // 실시간 채팅
    if (_socketStageProvider.isTalk) {
      _socketStageProvider.setIsTalk(false);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _stageProvider.addTalk(_socketStageProvider.talk!);
      });
    }

    // 실시간 반응
    if (_socketStageProvider.isReaction) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _socketStageProvider.setIsReaction(false);
        _stageProvider.setIsClicked(true);
        _stageProvider.toggleIsLeft();
      });
    }
  }

  BoxDecoration _buildBackgroundImage() {
    return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage((_socketStageProvider.IsMVPStart)
            ? 'assets/images/bg_popo_result.png'
            : 'assets/images/bg_popo_comm.png'),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
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

  Container _buildUserCountWidget() {
    return Container(
      margin: const EdgeInsets.only(right: 16.0, top: 10.0, bottom: 10.0),
      child: OutlinedButton.icon(
        onPressed: () async {
          await _stageProvider.getUserList();
          _showUserListDialog(_stageProvider.userList);
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
          '${_socketStageProvider.userCount}',
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
                itemCount: context.watch<StageProviderImpl>().userList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return UserListItemWidget(
                      user: context.watch<StageProviderImpl>().userList[index]);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
