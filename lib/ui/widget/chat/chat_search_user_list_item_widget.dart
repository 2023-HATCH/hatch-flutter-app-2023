import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/request/chat_room_request.dart';
import 'package:pocket_pose/data/remote/provider/chat_provider_impl.dart';
import 'package:pocket_pose/domain/entity/chat_user_list_item.dart';
import 'package:provider/provider.dart';

class ChatSearchUserListItemWidget extends StatelessWidget {
  final ChatUserListItem chatUser;
  final Function showChatDetailScreen;

  const ChatSearchUserListItemWidget(
      {super.key, required this.chatUser, required this.showChatDetailScreen});

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ChatProviderImpl>(context, listen: false);

    // showChatDetailScreen(String chatRoomId) {
    //   PageRouteWithSlideAnimation pageRouteWithAnimation =
    //       PageRouteWithSlideAnimation(ChatDetailScreen(
    //     chatRoomId: chatRoomId,
    //     opponentUserNickName: chatUser.nickname,
    //   ));
    //   Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
    // }

    return SafeArea(
      child: InkWell(
        onTap: () async {
          // 채팅방 생성
          var result = await chatProvider
              .putChatRoom(ChatRoomRequest(opponentUserId: chatUser.userId));

          // 채팅 상세 화면으로 이동
          showChatDetailScreen(result.data.chatRoomId, chatUser.nickname);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: (chatUser.profileImg == null)
                    ? Image.asset(
                        'assets/images/charactor_popo_default.png',
                        width: 40,
                        height: 40,
                      )
                    : Image.network(
                        chatUser.profileImg!,
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
                    chatUser.nickname,
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
                    width: 200,
                    child: Text(
                      chatUser.introduce ?? "",
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
