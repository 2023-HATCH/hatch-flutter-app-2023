import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/ui/screen/profile/follow_tab_screen.dart';
import 'package:pocket_pose/ui/view/profile/profile_buttons_view.dart';
import 'package:pocket_pose/ui/widget/page_route_with_animation.dart';

class ProfileUserInfoWidget extends StatelessWidget {
  const ProfileUserInfoWidget({
    super.key,
    required this.profileResponse,
  });

  final ProfileResponse profileResponse;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.whiteColor,
      height: 300,
      child: Center(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            width: 100,
            height: 100,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  profileResponse.user.profileImg ??
                      'assets/images/charactor_popo_default.png',
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
                    width: 35,
                    height: 35,
                  ),
                  fit: BoxFit.cover,
                  width: 35,
                  height: 35,
                )),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 14),
            child: Text(
              profileResponse.user.nickname,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _follow(
                    context, "팔로워", profileResponse.profile.followerCount, 0),
                _follow(
                    context, "팔로잉", profileResponse.profile.followingCount, 1),
              ],
            ),
          ),
          ProfileButtonsWidget(profileResponse: profileResponse),
          Text(profileResponse.profile.introduce ?? ''),
        ],
      )),
    );
  }

  GestureDetector _follow(
      BuildContext context, String title, int count, int tapNum) {
    return GestureDetector(
        child: Container(
          margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 위 아래 정렬을 중앙으로 설정
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Text(count.toString())),
              Text(title),
            ],
          ),
        ),
        onTap: () {
          PageRouteWithSlideAnimation pageRouteWithAnimation =
              PageRouteWithSlideAnimation(FollowTabScreen(
                  tapNum: tapNum, profileResponse: profileResponse));
          Navigator.push(context, pageRouteWithAnimation.fadeInFadeOutRoute());
        });
  }
}
