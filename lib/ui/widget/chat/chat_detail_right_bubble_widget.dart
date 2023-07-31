import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/domain/entity/chat_detail_list_item.dart';

class ChatDetailRightBubbleWidget extends StatelessWidget {
  final ChatDetailListItem chatDetail;

  const ChatDetailRightBubbleWidget({super.key, required this.chatDetail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 7, 24, 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTimeStamp(),
          const SizedBox(width: 8),
          _buildBubble(),
        ],
      ),
    );
  }

  Flexible _buildBubble() {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.yellowColor3,
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
    );
  }

  Widget _buildTimeStamp() {
    return Flexible(
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          _refomatTimeStamp(chatDetail.createdAt),
          style: TextStyle(
              fontSize: 10,
              color: AppColor.blackColor,
              fontWeight: FontWeight.w300),
          textAlign: TextAlign.end,
        ),
      ),
    );
  }

  String _refomatTimeStamp(String timeStamp) {
    var temp = timeStamp.split(' ');
    temp = temp[1].split(':');
    var ampm = int.parse(temp[0]) < 12 ? "오전" : "오후";
    var hour = (ampm == "오후") ? int.parse(temp[0].toString()) - 12 : temp[0];
    return "$ampm $hour:${temp[1]}";
  }
}
