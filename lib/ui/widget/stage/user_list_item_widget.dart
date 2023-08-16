import 'package:flutter/material.dart';
import 'package:pocket_pose/domain/entity/user_list_item.dart';

class UserListItemWidget extends StatelessWidget {
  final UserListItem user;

  const UserListItemWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: ClipRRect(
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
