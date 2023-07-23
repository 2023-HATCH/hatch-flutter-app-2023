import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/chat_detail_list_response.dart';
import 'package:pocket_pose/domain/entity/chat_detail_list_item.dart';
import 'package:pocket_pose/ui/widget/chat/chat_detail_left_bubble_widget.dart';
import 'package:pocket_pose/ui/widget/chat/chat_detail_right_bubble_widget.dart';

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
      "createdAt": "2023-07-23T11:58:20.551705"
    },
    {
      "content": "뭐해!!!",
      "sender": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "createdAt": "2023-07-23T11:58:20.551705"
    },
    {
      "content": "낼 같이 공부할래?",
      "sender": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "createdAt": "2023-07-23T11:58:20.551705"
    },
    {
      "content": "응?",
      "sender": {
        "userId": "11",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "min0"
      },
      "createdAt": "2023-07-23T11:58:20.551705"
    },
    {
      "content": "공부하자",
      "sender": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "createdAt": "2023-07-23T11:58:20.551705"
    },
    {
      "content": "공부하자공부하자공부하자공부하자공부하자공부하자",
      "sender": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "createdAt": "2023-07-23T11:58:20.551705"
    },
    {
      "content": "뭐 뭐야",
      "sender": {
        "userId": "11",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "min0"
      },
      "createdAt": "2023-07-23T11:58:20.551705"
    },
    {
      "content": "싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어싫어",
      "sender": {
        "userId": "11",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "min0"
      },
      "createdAt": "2023-07-23T11:58:20.551705"
    },
    {
      "content": "그래",
      "sender": {
        "userId": "11",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "min0"
      },
      "createdAt": "2023-07-23T11:58:20.551705"
    },
    {
      "content": "아싸",
      "sender": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "createdAt": "2023-07-23T11:58:20.551705"
    },
    {
      "content": "낼 덕다 ㄱ",
      "sender": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "createdAt": "2023-07-23T11:58:20.551705"
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
  final List<ChatDetailListItem> _messageList = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    setState(() {
      var chatDetailJson =
          ChatDetailListResponse.fromJson(chatDetailListString);
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
    // build마다 채팅 스크롤 맨 밑으로
    if (_messageList.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
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
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 7),
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                controller: _scrollController,
                itemCount: _messageList.length,
                itemBuilder: (BuildContext context, int index) {
                  return _messageList[index].sender.nickname != "pochako"
                      ? ChatDetailRightBubbleWidget(
                          chatDetail: _messageList[index],
                        )
                      : ChatDetailLeftBubbleWidget(
                          chatDetail: _messageList[index]);
                },
              ),
            ),
          ),
        ],
      ),
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
}
