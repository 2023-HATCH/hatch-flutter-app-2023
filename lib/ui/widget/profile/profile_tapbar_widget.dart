import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/ui/screen/profile/profile_edit_screen.dart';
import 'package:pocket_pose/ui/screen/profile/profile_setting_screen.dart';
import 'package:pocket_pose/ui/widget/page_route_with_animation.dart';

class ProfileTapbarWidget extends StatelessWidget {
  const ProfileTapbarWidget({
    super.key,
    required this.profileResponse,
    required this.isNotBottomNavi,
  });

  final ProfileResponse profileResponse;
  final bool isNotBottomNavi;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.whiteColor,
      child: Visibility(
        visible: profileResponse.profile.isMe,
        replacement: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                child: Image.asset(
                  'assets/icons/ic_back.png',
                ),
              ),
            ),
          ],
        ),
        child: Visibility(
          visible: isNotBottomNavi,
          replacement: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  PageRouteWithSlideAnimation pageRouteWithAnimation =
                      PageRouteWithSlideAnimation(
                          ProfileEditScreen(profileResponse: profileResponse));
                  Navigator.push(
                      context, pageRouteWithAnimation.slideRitghtToLeft());
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 36, 14, 0),
                  child: SvgPicture.asset('assets/icons/ic_profile_edit.svg'),
                ),
              ),
              InkWell(
                onTap: () {
                  PageRouteWithSlideAnimation pageRouteWithAnimation =
                      PageRouteWithSlideAnimation(const ProfileSettingScreen());
                  Navigator.push(
                      context, pageRouteWithAnimation.slideRitghtToLeft());
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 36, 14, 0),
                  child:
                      SvgPicture.asset('assets/icons/ic_profile_setting.svg'),
                ),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                  child: Image.asset(
                    'assets/icons/ic_back.png',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      PageRouteWithSlideAnimation pageRouteWithAnimation =
                          PageRouteWithSlideAnimation(ProfileEditScreen(
                              profileResponse: profileResponse));
                      Navigator.push(
                          context, pageRouteWithAnimation.slideRitghtToLeft());
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 36, 14, 0),
                      child:
                          SvgPicture.asset('assets/icons/ic_profile_edit.svg'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      PageRouteWithSlideAnimation pageRouteWithAnimation =
                          PageRouteWithSlideAnimation(
                              const ProfileSettingScreen());
                      Navigator.push(
                          context, pageRouteWithAnimation.slideRitghtToLeft());
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 36, 14, 0),
                      child: SvgPicture.asset(
                          'assets/icons/ic_profile_setting.svg'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
