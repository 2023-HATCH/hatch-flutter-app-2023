import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/chat_room_list_response.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/chat_provider_impl.dart';
import 'package:pocket_pose/domain/entity/chat_room_list_item.dart';
import 'package:pocket_pose/ui/widget/chat/chat_room_list_item_widget.dart';
import 'package:provider/provider.dart';

class ChatRoomListScreen extends StatefulWidget {
  const ChatRoomListScreen({super.key});

  @override
  State<ChatRoomListScreen> createState() => _ChatListRoomScreenState();
}

class _ChatListRoomScreenState extends State<ChatRoomListScreen> {
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late ChatProviderImpl _chatProvider;
  Future<ChatRoomListResponse>? chatList;

  @override
  void initState() {
    _multiVideoPlayProvider = Provider.of(context, listen: false);
    _multiVideoPlayProvider.pauseVideo();

    super.initState();
  }

  @override
  void dispose() {
    _multiVideoPlayProvider.playVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _chatProvider = Provider.of<ChatProviderImpl>(context, listen: false);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Container(
            color: AppColor.purpleColor,
            height: 3,
          ),
          FutureBuilder(
            future: _chatProvider.getChatRoomList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ((snapshot.data?.data.chatRooms ?? []).isEmpty)
                      ? Center(
                          child: Text(
                            "아직 채팅이 없습니다.🥲\n '메시지' 버튼을 눌러 채팅을 시작해보세요!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.grayColor,
                            ),
                          ),
                        )
                      : buildChatList(snapshot.data?.data.chatRooms ?? []),
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

  ListView buildChatList(List<ChatRoomListItem> chatRooms) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: chatRooms.length,
      itemBuilder: (context, index) {
        final chatRoom = chatRooms[index];
        return ChatRoomListItemWidget(chatRoom: chatRoom);
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
