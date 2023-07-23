import 'package:flutter/material.dart';
import 'package:pocket_pose/domain/entity/chat_detail_list_item.dart';

class ChatDetailLeftBubbleWidget extends StatelessWidget {
  final ChatDetailListItem chatDetail;

  const ChatDetailLeftBubbleWidget({super.key, required this.chatDetail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 7, 24, 7),
      child: Row(
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatDetail.content,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
