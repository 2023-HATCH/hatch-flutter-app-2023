import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/domain/entity/chat_detail_list_item.dart';

class ChatDetailLeftBubbleWidget extends StatelessWidget {
  final ChatDetailListItem chatDetail;

  const ChatDetailLeftBubbleWidget({super.key, required this.chatDetail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 7, 24, 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildUserProfileAndContent(),
          const SizedBox(width: 8),
          buildTimeStamp(),
        ],
      ),
    );
  }

  Widget buildUserProfileAndContent() {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              (chatDetail.sender.profileImg == null)
                  ? 'assets/images/charactor_popo_default.png'
                  : chatDetail.sender.profileImg!,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  chatDetail.content,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeStamp() {
    return Flexible(
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          refomatTimeStamp(chatDetail.createdAt),
          style: TextStyle(
              fontSize: 10,
              color: AppColor.blackColor,
              fontWeight: FontWeight.w300),
        ),
      ),
    );
  }

  String refomatTimeStamp(String timeStamp) {
    var temp = timeStamp.split(' ');
    temp = temp[1].split(':');
    var ampm = int.parse(temp[0]) < 12 ? "오전" : "오후";
    var hour = (ampm == "오후") ? int.parse(temp[0].toString()) - 12 : temp[0];
    return "$ampm $hour:${temp[1]}";
  }
}
