import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/ui/screen/profile/profile_edit_screen.dart';
import 'package:pocket_pose/ui/screen/profile/profile_setting_screen.dart';

class ProfileTapbarWidget extends StatelessWidget {
  const ProfileTapbarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfileEditScreen()),
              );
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 36, 14, 0),
              child: SvgPicture.asset('assets/icons/ic_profile_edit.svg'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfileSettingScreen()),
              );
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 36, 14, 0),
              child: SvgPicture.asset('assets/icons/ic_profile_setting.svg'),
            ),
          )
        ],
      ),
    );
  }
}
