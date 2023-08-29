import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';

class ProfileEditImgNameWidget extends StatelessWidget {
  const ProfileEditImgNameWidget({
    super.key,
    required this.profileResponse,
  });

  final ProfileResponse profileResponse;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                profileResponse.user.profileImg!,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColor.purpleColor,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/charactor_popo_default.png',
                  fit: BoxFit.cover,
                ),
                fit: BoxFit.cover,
              )),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 14),
          child: Text(
            profileResponse.user.nickname,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
