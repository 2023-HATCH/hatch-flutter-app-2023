import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/chat_list_response.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/ui/widget/chat/chat_list_item_widget.dart';
import 'package:provider/provider.dart';

final chatListString = {
  "list": [
    {
      "chatRoomId": "1",
      "opponentUser": {
        "userId": "11",
        "profileImg": "assets/images/chat_user_1.png",
        "nickname": "hello_kiti"
      },
      "recentContent": "놀자"
    },
    {
      "chatRoomId": "2",
      "opponentUser": {
        "userId": "22",
        "profileImg": "assets/images/chat_user_2.png",
        "nickname": "pochako"
      },
      "recentContent": "뭐해?"
    },
    {
      "chatRoomId": "3",
      "opponentUser": {
        "userId": "33",
        "profileImg": "assets/images/chat_user_3.png",
        "nickname": "pom_pom_pulin"
      },
      // "recentContent": "밥먹자"
    },
    {
      "chatRoomId": "4",
      "opponentUser": {
        "userId": "44",
        "profileImg": "assets/images/chat_user_4.png",
        "nickname": "kelo_kelo_kelopi"
      },
      "recentContent": "산책하자산책하자산책하자산책하자산책하자산책하자산책하자산책하자"
    },
    {
      "chatRoomId": "5",
      "opponentUser": {
        "userId": "55",
        // "profileImg": "",
        "nickname": "kogimyung_"
      },
      "recentContent": "졸려..."
    },
  ]
};

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  Future<ChatListResponse>? chatList;

  @override
  void initState() {
    _multiVideoPlayProvider = Provider.of(context, listen: false);
    _multiVideoPlayProvider.pauseVideo();

    chatList = Future.value(ChatListResponse.fromJson(chatListString));

    super.initState();
  }

  @override
  void dispose() {
    _multiVideoPlayProvider.playVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Container(
            color: AppColor.purpleColor,
            height: 3,
          ),
          FutureBuilder(
            future: chatList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: buildChatList(snapshot),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  ListView buildChatList(AsyncSnapshot<ChatListResponse> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: snapshot.data!.list.length,
      itemBuilder: (context, index) {
        final chatInfo = snapshot.data!.list[index];
        return ChatListItemWidget(chat: chatInfo);
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "메시지",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      backgroundColor: Colors.white,
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
