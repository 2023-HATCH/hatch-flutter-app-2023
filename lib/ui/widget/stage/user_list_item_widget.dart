import 'package:flutter/material.dart';
import 'package:pocket_pose/domain/entity/stage_user_list_item.dart';

class UserListItemWidget extends StatelessWidget {
  final StageUserListItem user;

  const UserListItemWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: (user.profileImg == null)
              ? Image.asset(
                  'assets/images/charactor_popo_default.png',
                  width: 58,
                  height: 58,
                )
              : Image.network(
                  user.profileImg!,
                  fit: BoxFit.cover,
                  width: 58,
                  height: 58,
                ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          user.nickname,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
