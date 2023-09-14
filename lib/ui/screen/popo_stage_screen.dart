import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/data/entity/request/stage_enter_request.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/domain/entity/user_list_item.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/ui/widget/stage/stage_live_chat_bar_widget.dart';
import 'package:pocket_pose/ui/widget/stage/stage_live_talk_list_widget.dart';
import 'package:pocket_pose/ui/widget/stage/user_list_item_widget.dart';
import 'package:provider/provider.dart';

class PoPoStageScreen extends StatefulWidget {
  const PoPoStageScreen(
      {super.key, required this.getIndex(), required this.userData});
  final Function getIndex;
  final UserData userData;

  @override
  State<PoPoStageScreen> createState() => _PoPoStageScreenState();
}

class _PoPoStageScreenState extends State<PoPoStageScreen> {
  bool _isEnter = false;
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late StageProviderImpl _stageProvider;
  late SocketStageProviderImpl _socketStageProvider;

  @override
  Widget build(BuildContext context) {
    _stageProvider = Provider.of<StageProviderImpl>(context, listen: true);
    _socketStageProvider =
        Provider.of<SocketStageProviderImpl>(context, listen: true);
    print("mmm rebuild");

    // 입장
    _popoStageEnter();
    // 소켓 반응 처리
    _onSocketResponse();

    return Selector<SocketStageProviderImpl, SocketType>(
        selector: (_, socketProvider) => socketProvider.stageType,
        builder: (context, stageType, _) {
          return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              onHorizontalDragUpdate: (details) {
                if (details.primaryDelta! > 10) {
                  // 왼쪽에서 오른쪽으로 드래그했을 때 pop
                  Navigator.of(context).pop();
                }
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Container(
                    // 플레이, 결과 상태에 따라 배경화면 변경
                    decoration: _buildBackgroundImage(stageType),
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      extendBodyBehindAppBar: true,
                      backgroundColor: Colors.transparent,
                      appBar: _buildAppBar(context),
                      body: Stack(
                        children: [
                          Navigator(
                            key: _socketStageProvider.navigatorKey,
                            initialRoute: socketTypeList[0],
                            onGenerateRoute:
                                _socketStageProvider.onGenerateRoute,
                          ),
                          const Positioned(
                            bottom: 68,
                            left: 0,
                            right: 0,
                            child: StageLiveTalkListWidget(),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: StageLiveChatBarWidget(
                                nickName: widget.userData.nickname),
                          ),
                        ],
                      ),
                    )),
              ));
        });
  }

  @override
  void initState() {
    super.initState();
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
  }

  @override
  void dispose() {
    AudioPlayerUtil().stop();
    if (widget.getIndex() == 0) {
      _multiVideoPlayProvider.playVideo(0);
    }

    if (_isEnter) {
      _socketStageProvider.exitStage();
      _isEnter = false;
    }

    super.dispose();
  }

  void _popoStageEnter() {
    if (!_isEnter) {
      _isEnter = true;
      _socketStageProvider.connectWebSocket();
    }
  }

  void _onSocketResponse() {
    var isConnect = context.select<SocketStageProviderImpl, bool>(
        (provider) => provider.isConnect);

    // 입장 완료 후 구독
    if (isConnect) {
      SocketType stageType = SocketType.WAIT;
      _socketStageProvider.setIsConnect(false);
      _stageProvider
          .getStageEnter(StageEnterRequest(page: 0, size: 10))
          .then((value) {
            stageType = SocketType.values.byName(value.data.stageStatus);
            _socketStageProvider.setUserCount(value.data.userCount);
            if (stageType == SocketType.CATCH) {
              _socketStageProvider.setIsCatchMidEnter(true);
            }
          })
          .then((_) => _socketStageProvider.setStageView(stageType))
          .then((_) => _socketStageProvider.onSubscribe());
    }
  }

  BoxDecoration _buildBackgroundImage(SocketType type) {
    String bgImage;
    switch (type) {
      case SocketType.WAIT:
        bgImage = 'assets/images/bg_popo_wait.png';
        break;
      case SocketType.CATCH_START:
      case SocketType.PLAY_START:
        bgImage = 'assets/images/bg_popo_comm.png';
        break;
      case SocketType.MVP_START:
        bgImage = 'assets/images/bg_popo_result.png';
        break;
      default:
        bgImage = 'assets/images/bg_popo_wait.png';
        break;
    }

    return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(bgImage),
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

  Widget _buildUserCountWidget() {
    return Selector<SocketStageProviderImpl, int>(
        selector: (context, socketProvider) => socketProvider.userCount,
        shouldRebuild: (prev, next) {
          return true;
        },
        builder: (context, data, child) {
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
                '$data',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  Future<dynamic> _showUserListDialog(List<UserListItem> userList) {
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
