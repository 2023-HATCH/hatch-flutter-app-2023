import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/chat_list_response.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:provider/provider.dart';

final chatListString = {
  "list": [
    {
      "chatRoomId": "1",
      "opponentUser": {
        "userId": "11",
        "profileImg": "assets/images/chat_user1.jpg",
        "nickname": "고양이"
      },
      "recentContent": "뭐해?"
    },
    {
      "chatRoomId": "2",
      "opponentUser": {
        "userId": "22",
        "profileImg": "assets/images/chat_user2.jpg",
        "nickname": "고양이"
      },
      "recentContent": "뭐해?"
    },
    {
      "chatRoomId": "3",
      "opponentUser": {
        "userId": "33",
        "profileImg": "assets/images/chat_user3.jpg",
        "nickname": "고양이"
      },
      "recentContent": "뭐해?"
    },
    {
      "chatRoomId": "4",
      "opponentUser": {
        "userId": "44",
        "profileImg": "assets/images/chat_user4.jpg",
        "nickname": "고양이"
      },
      "recentContent": "뭐해?"
    },
    {
      "chatRoomId": "5",
      "opponentUser": {
        "userId": "55",
        "profileImg": "assets/images/chat_user5.jpg",
        "nickname": "고양이"
      },
      "recentContent": "뭐해?"
    },
  ]
};

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late VideoPlayProvider _videoPlayProvider;
  Future<ChatListResponse>? chatList;

  @override
  void initState() {
    _videoPlayProvider = Provider.of(context, listen: false);
    _videoPlayProvider.pauseVideo();

    chatList = Future.value(ChatListResponse.fromJson(chatListString));

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayProvider.playVideo();
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
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.list.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        final chatInfo = snapshot.data!.list[index];
        return Column(
          children: [
            Text(chatInfo.chatRoomId),
          ],
        );
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
        child: SvgPicture.asset(
          'assets/icons/ic_left_purple.svg',
          width: 11,
          height: 19,
        ),
      ),
    );
  }
}
