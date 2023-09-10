import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/socket_request/send_chat_request.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/chat_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/data/remote/provider/socket_chat_provider_impl.dart';
import 'package:pocket_pose/domain/entity/chat_detail_list_item.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/ui/widget/chat/chat_detail_left_bubble_widget.dart';
import 'package:pocket_pose/ui/widget/chat/chat_detail_right_bubble_widget.dart';
import 'package:provider/provider.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen(
      {Key? key, required this.chatRoomId, required this.opponentUserNickName})
      : super(key: key);

  final String chatRoomId;
  final String opponentUserNickName;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late SocketChatProviderImpl _socketChatProvider;
  late ChatProviderImpl _chatProvider;
  late KaKaoLoginProvider _loginProvider;
  String _userId = "";
  bool _isEnter = false;
  int _page = 1;
  String? _curDate;
  String? _nextDate;
  bool _isHeaderVisible = false;

  final List<ChatDetailListItem> _messageList = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  bool _isNextSenderRight = false;
  bool _isMessageFillOut = false;

  @override
  void initState() {
    super.initState();

    _initUserId();

    _multiVideoPlayProvider = Provider.of(context, listen: false);
    _multiVideoPlayProvider.pauseVideo(0);

    _scrollController.addListener(_scrollListener);

    // 선택한 채팅방 채팅메세지 조회
    _chatProvider = Provider.of<ChatProviderImpl>(context, listen: false);
    _chatProvider.getChatDetailList(widget.chatRoomId, 0).then((value) {
      setState(() {
        for (var chat in value.data.messages) {
          _messageList.add(chat);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  _initUserId() async {
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: false);
    UserData user = await _loginProvider.getUser();

    setState(() {
      _userId = user.userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    _socketChatProvider =
        Provider.of<SocketChatProviderImpl>(context, listen: true);

    // 입장
    _chatEnter();
    // 소켓 반응 처리
    _onSocketResponse();

    return GestureDetector(
      onHorizontalDragStart: (details) {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        backgroundColor: AppColor.purpleColor3,
        body: Column(
          children: [
            Container(
              color: AppColor.purpleColor,
              height: 3,
            ),
            _buildChatsArea(),
            const SizedBox(
              height: 10,
            ),
            _buildChatTextField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChatsArea() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Align(
          alignment: Alignment.topCenter,
          child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            controller: _scrollController,
            itemCount: _messageList.length,
            itemBuilder: (BuildContext context, int index) {
              // 날짜 헤더
              _isHeaderVisible = false;

              _curDate = _messageList[index].createdAt.split(' ')[0];
              if (index < _messageList.length - 1) {
                _nextDate = _messageList[index + 1].createdAt.split(' ')[0];
              }
              if (_curDate != null && _nextDate != null) {
                _isHeaderVisible = (_curDate != _nextDate) ? true : false;
              }
              if (index == _messageList.length - 1) _isHeaderVisible = true;

              // 말풍선 왼쪽 오른쪽 구분
              if (index < _messageList.length - 1 &&
                  _messageList[index + 1].sender.userId == _userId) {
                _isNextSenderRight = true;
              } else if (index == _messageList.length - 1) {
                _isNextSenderRight = true;
              } else {
                _isNextSenderRight = false;
              }
              return _messageList[index].sender.userId == _userId
                  ? ChatDetailRightBubbleWidget(
                      chatDetail: _messageList[index],
                      headerVisiblity: _isHeaderVisible,
                    )
                  : ChatDetailLeftBubbleWidget(
                      chatDetail: _messageList[index],
                      profileVisiblity: _isNextSenderRight,
                      headerVisiblity: _isHeaderVisible);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChatTextField(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(14, 0, 0, 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppColor.grayColor4,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _isMessageFillOut = value.isNotEmpty;
                            });
                          },
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          controller: _textController,
                          cursorColor: AppColor.grayColor4,
                          decoration: InputDecoration(
                            hintText: '메시지 보내기...',
                            hintStyle: TextStyle(
                                color: AppColor.grayColor4,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                            labelStyle: TextStyle(color: AppColor.grayColor4),
                            border: InputBorder.none,
                            suffixIcon: TextButton(
                                style: TextButton.styleFrom(
                                    splashFactory: NoSplash.splashFactory),
                                onPressed: () {
                                  _socketChatProvider.sendMessage(
                                      SendChatRequest(
                                          chatRoomId: widget.chatRoomId,
                                          content: _textController.text));
                                  _textController.clear();
                                  setState(() {
                                    _isMessageFillOut = false;
                                  });
                                },
                                child: Text(
                                  '보내기',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: _isMessageFillOut
                                          ? AppColor.blueColor5
                                          : AppColor.blueColor4),
                                )),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        widget.opponentUserNickName,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      backgroundColor: AppColor.purpleColor3,
      elevation: 0.0,
      leading: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Image.asset(
          'assets/icons/ic_back.png',
        ),
      ),
    );
  }

  void _chatEnter() {
    if (!_isEnter) {
      _isEnter = true;
      _socketChatProvider.connectWebSocket();
    }
  }

  void _onSocketResponse() {
    if (_socketChatProvider.isConnect) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _socketChatProvider.setIsConnect(false);
        _socketChatProvider.onSubscribe(widget.chatRoomId);
      });
    }

    // 실시간 채팅
    if (_socketChatProvider.isChat) {
      _socketChatProvider.setIsChat(false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _messageList.insert(0, _socketChatProvider.chat!);
        });
      });
    }
  }

  _scrollListener() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      var response =
          await _chatProvider.getChatDetailList(widget.chatRoomId, _page);
      _page++;
      var talkList = response.data.messages;

      setState(() {
        for (var chat in talkList) {
          _messageList.add(chat);
        }
      });
    }
  }
}
