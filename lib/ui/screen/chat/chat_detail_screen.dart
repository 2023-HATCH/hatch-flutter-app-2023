import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/chat_detail_list_response.dart';
import 'package:pocket_pose/data/remote/provider/socket_chat_provider_impl.dart';
import 'package:pocket_pose/domain/entity/chat_detail_list_item.dart';
import 'package:pocket_pose/ui/widget/chat/chat_detail_left_bubble_widget.dart';
import 'package:pocket_pose/ui/widget/chat/chat_detail_right_bubble_widget.dart';
import 'package:provider/provider.dart';

final chatDetailListString = {
  "pageNum": 1,
  "size": 20,
  "messeges": [
    {
      "content": "야~~",
      "sender": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "createdAt": "2023-07-23 11:58:20.551705"
    },
    {
      "content": "뭐해!!!",
      "sender": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "createdAt": "2023-07-23 11:58:20.551705"
    },
    {
      "content": "낼 같이 공부할래?",
      "sender": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "createdAt": "2023-07-23 11:58:20.551705"
    },
    {
      "content": "응?",
      "sender": {
        "userId": "11",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "min0"
      },
      "createdAt": "2023-07-23 11:58:20.551705"
    },
    {
      "content": "공부하자",
      "sender": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "createdAt": "2023-07-23 11:58:20.551705"
    },
    {
      "content": "공부하자공부하자공부하자공부하자공부하자공부하자공부하자공부하자공부하자공부하자공부하자공부하자",
      "sender": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "createdAt": "2023-07-23 11:58:20.551705"
    },
    {
      "content": "뭐 뭐야",
      "sender": {
        "userId": "11",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "min0"
      },
      "createdAt": "2023-07-23 11:58:20.551705"
    },
    {
      "content": "싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어",
      "sender": {
        "userId": "11",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "min0"
      },
      "createdAt": "2023-07-23 11:58:20.551705"
    },
    {
      "content": "그래",
      "sender": {
        "userId": "11",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "min0"
      },
      "createdAt": "2023-07-23 11:58:20.551705"
    },
    {
      "content": "아싸",
      "sender": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "createdAt": "2023-07-23 11:58:20.551705"
    },
    {
      "content": "낼 덕다 ㄱ",
      "sender": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "createdAt": "2023-07-23 11:58:20.551705"
    },
  ]
};

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late SocketChatProviderImpl _socketChatProvider;
  bool _isEnter = false;

  final List<ChatDetailListItem> _messageList = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  bool _isNextSenderRight = false;
  bool _isMessageFillOut = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      var chatDetailJson =
          ChatDetailListResponse.fromJson(chatDetailListString);
      chatDetailJson.messeges = chatDetailJson.messeges.reversed.toList();
      for (var element in chatDetailJson.messeges) {
        _messageList.add(element);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _socketChatProvider =
        Provider.of<SocketChatProviderImpl>(context, listen: true);

    // 입장
    _chatEnter();
    // 소켓 반응 처리
    _onSocketResponse();

    // build마다 채팅 스크롤 맨 밑으로
    if (_messageList.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 50),
          curve: Curves.easeOut,
        );
      });
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: AppColor.purpleColor3,
      body: Column(
        children: [
          Container(
            color: AppColor.purpleColor,
            height: 3,
          ),
          _buildChatsArea(),
          _buildChatTextField(context),
        ],
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
              if (index < _messageList.length - 1 &&
                  _messageList[index + 1].sender.nickname != "pochako") {
                _isNextSenderRight = true;
              } else if (index == _messageList.length - 1) {
                _isNextSenderRight = true;
              } else {
                _isNextSenderRight = false;
              }
              return _messageList[index].sender.nickname != "pochako"
                  ? ChatDetailRightBubbleWidget(chatDetail: _messageList[index])
                  : ChatDetailLeftBubbleWidget(
                      chatDetail: _messageList[index],
                      profileVisiblity: _isNextSenderRight);
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
      title: const Text(
        "pochako",
        style: TextStyle(
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
      print("mmm 구독 완");
    }
  }
}
