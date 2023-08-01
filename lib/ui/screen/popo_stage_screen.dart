import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/api_url.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/data/entity/base_socket_response.dart';
import 'package:pocket_pose/data/entity/request/stage_enter_request.dart';
import 'package:pocket_pose/data/entity/socket_response/talk_message_response.dart';
import 'package:pocket_pose/data/entity/socket_response/user_count_response.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/domain/entity/stage_talk_list_item.dart';
import 'package:pocket_pose/domain/entity/stage_user_list_item.dart';
import 'package:pocket_pose/ui/view/popo_play_view.dart';
import 'package:pocket_pose/ui/view/popo_catch_view.dart';
import 'package:pocket_pose/ui/view/popo_result_view.dart';
import 'package:pocket_pose/ui/view/popo_wait_view.dart';
import 'package:pocket_pose/ui/widget/stage/stage_live_chat_bar_widget.dart';
import 'package:pocket_pose/ui/widget/stage/stage_live_chat_list.widget.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

enum StageType {
  WAIT, // only front
  CATCH_START,
  CATCH_END,
  PLAY_START,
  MVP_START,
  USER_COUNT,
  STAGE_ROUTINE_STOP,
  TALK_MESSAGE
}

class PoPoStageScreen extends StatefulWidget {
  const PoPoStageScreen({super.key, required this.getIndex()});
  final Function getIndex;

  @override
  State<PoPoStageScreen> createState() => _PoPoStageScreenState();
}

class _PoPoStageScreenState extends State<PoPoStageScreen> {
  int _userCount = 1;
  bool _isEnter = false;
  late VideoPlayProvider _videoPlayProvider;
  late StageProviderImpl _stageProvider;
  StageType _stageType = StageType.WAIT;
  StompClient? stompClient;

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
    _stageProvider = Provider.of<StageProviderImpl>(context, listen: true);
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
                  _buildStageView(_stageType),
                  const Positioned(
                    bottom: 68,
                    left: 0,
                    right: 0,
                    child: StageLiveChatListWidget(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: StageLiveChatBarWidget(sendMessage: sendMessage),
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
    if (stompClient == null) {
      _connectWebSocket();
    }
  }

  @override
  void dispose() {
    AudioPlayerUtil().stop();
    if (widget.getIndex() == 0) {
      _videoPlayProvider.playVideo();
    }
    stompClient?.deactivate();
    if (_isEnter) {
      _stageProvider.getStageExit();
      _isEnter = false;
    }

    super.dispose();
  }

  void _connectWebSocket() async {
    const storage = FlutterSecureStorage();
    const storageKey = 'kakaoAccessToken';
    String token = await storage.read(key: storageKey) ?? "";

    stompClient = StompClient(
        config: StompConfig(
      url: AppUrl.webSocketUrl,
      onConnect: (frame) {
        _onConnect(frame, token);
      },
      stompConnectHeaders: {'x-access-token': token},
      webSocketConnectHeaders: {'x-access-token': token},
      onDebugMessage: (p0) => print("mmm socket: $p0"),
    ));
    stompClient!.activate();
  }

  void _onConnect(StompFrame frame, String token) {
    // 입장 요청
    if (!_isEnter) {
      _stageProvider
          .getStageEnter(StageEnterRequest(page: 0, size: 10))
          .then((value) => _userCount = value.data.userCount);
      _isEnter = true;
    }
    // 연결 되면 구독
    stompClient?.subscribe(
        destination: AppUrl.subscribeStageUrl,
        callback: (StompFrame frame) {
          if (frame.body != null) {
            // stage 상태 변경
            var socketResponse = BaseSocketResponse.fromJson(
                jsonDecode(frame.body.toString()), null);
            setStageType(socketResponse, frame);
          }
        });
  }

  void sendMessage(String message) async {
    const storage = FlutterSecureStorage();
    const storageKey = 'kakaoAccessToken';
    String token = await storage.read(key: storageKey) ?? "";

    if (stompClient != null) {
      stompClient?.send(
          destination: '/app/talks/messages',
          headers: {'x-access-token': token},
          body: json.encode({"content": message}));
    }
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

  void setStageType(BaseSocketResponse response, StompFrame frame) {
    switch (response.type) {
      case StageType.USER_COUNT:
        var socketResponse = BaseSocketResponse<UserCountResponse>.fromJson(
            jsonDecode(frame.body.toString()),
            UserCountResponse.fromJson(
                jsonDecode(frame.body.toString())['data']));
        setState(() {
          _userCount = socketResponse.data!.userCount;
        });

        break;
      case StageType.TALK_MESSAGE:
        var socketResponse = BaseSocketResponse<TalkMessageResponse>.fromJson(
            jsonDecode(frame.body.toString()),
            TalkMessageResponse.fromJson(
                jsonDecode(frame.body.toString())['data']));

        var talk = StageTalkListItem(
            content: socketResponse.data!.content,
            sender: socketResponse.data!.sender);
        _stageProvider.addTalk(talk);
        break;
      default:
        if (mounted) {
          setState(() {
            _stageType = response.type;
          });
        }
    }
  }

  bool getIsResultState() => _stageType == StageType.MVP_START;

  Container _buildUserCountWidget() {
    return Container(
      margin: const EdgeInsets.only(right: 16.0, top: 10.0, bottom: 10.0),
      child: OutlinedButton.icon(
        onPressed: () async {
          var response = await _stageProvider.getUserList();

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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child:
                                (userList.elementAt(index).profileImg == null)
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
                )),
          );
        });
  }

  Widget _buildStageView(StageType type) {
    switch (type) {
      case StageType.STAGE_ROUTINE_STOP:
      case StageType.WAIT:
        return const PoPoWaitView();
      case StageType.CATCH_START:
        return const PoPoCatchView();
      case StageType.PLAY_START:
        return PoPoPlayView(isResultState: getIsResultState());
      case StageType.MVP_START:
        return PoPoResultView(isResultState: getIsResultState());
      default:
        return const PoPoWaitView();
    }
  }
}
