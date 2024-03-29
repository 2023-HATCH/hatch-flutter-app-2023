import 'package:flutter/material.dart';
import 'package:pocket_pose/domain/entity/stage_talk_list_item.dart';

class TalkListItemWidget extends StatelessWidget {
  final StageTalkListItem talk;

  const TalkListItemWidget({super.key, required this.talk});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: (talk.sender.profileImg == null)
              ? Image.asset(
                  'assets/images/charactor_popo_default.png',
                  width: 35,
                  height: 35,
                )
              : Image.network(
                  talk.sender.profileImg!,
                  fit: BoxFit.cover,
                  width: 35,
                  height: 35,
                ),
        ),
        const SizedBox(
          width: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              talk.sender.nickname,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              talk.content,
              style: const TextStyle(color: Colors.white),
            )
          ],
        )
      ],
    );
  }
}
