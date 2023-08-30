import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/domain/entity/chat_room_list_item.dart';
import 'package:pocket_pose/ui/screen/chat/chat_detail_screen.dart';

class ChatRoomListItemWidget extends StatelessWidget {
  final ChatRoomListItem chatRoom;

  const ChatRoomListItemWidget({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatDetailScreen(
                      chatRoomId: chatRoom.chatRoomId,
                      opponentUserNickName: chatRoom.opponentUser.nickname,
                    )),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: (chatRoom.opponentUser.profileImg == null)
                    ? Image.asset(
                        'assets/images/charactor_popo_default.png',
                        width: 40,
                        height: 40,
                      )
                    : Image.network(
                        chatRoom.opponentUser.profileImg!,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
              ),
              const SizedBox(
                width: 14,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatRoom.opponentUser.nickname,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                    width: 250,
                    child: Text(
                      chatRoom.recentContent ?? "",
                      style:
                          TextStyle(fontSize: 12, color: AppColor.grayColor5),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
