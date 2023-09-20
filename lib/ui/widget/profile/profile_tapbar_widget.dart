import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/ui/screen/main_screen.dart';
import 'package:pocket_pose/ui/screen/profile/profile_edit_screen.dart';
import 'package:pocket_pose/ui/screen/profile/profile_setting_screen.dart';
import 'package:pocket_pose/ui/widget/page_route_with_animation.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfileTapbarWidget extends StatelessWidget {
  ProfileTapbarWidget({
    super.key,
    required this.profileResponse,
    required this.isBottomNavi,
    required this.isNotification,
  });

  final ProfileResponse profileResponse;
  final bool isBottomNavi;
  final bool? isNotification;
  late MultiVideoPlayProvider _multiVideoPlayProvider;

  @override
  Widget build(BuildContext context) {
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);

    return Container(
        color: AppColor.whiteColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: !profileResponse.profile.isMe ||
                  (profileResponse.profile.isMe && !isBottomNavi),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      if (isNotification != null && isNotification!) {
                        _multiVideoPlayProvider.resetVideoPlayer(0);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                          (route) => false,
                        );
                      } else {
                        Navigator.of(context).pop();
                      }
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
            ),
            Visibility(
              visible: profileResponse.profile.isMe,
              child: Row(
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
            ),
          ],
        ));
  }
}
