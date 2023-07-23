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
        children: [
          Flexible(
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
          ),
        ],
      ),
    );
  }
}
