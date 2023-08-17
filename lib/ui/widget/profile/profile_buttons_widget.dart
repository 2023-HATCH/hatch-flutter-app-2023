import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';

class ProfileButtonsWidget extends StatelessWidget {
  const ProfileButtonsWidget({
    required this.profileResponse,
    super.key,
  });

  final ProfileResponse profileResponse;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: OutlinedButton(
              onPressed: () {
                // Respond to button press
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                minimumSize: const Size(100, 30), // 원하는 가로 길이와 세로 길이 지정
              ),
              child: const Text(
                "메시지",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
            child: OutlinedButton(
              onPressed: () {
                // Respond to button press
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(30, 30),
              ),
              child: SvgPicture.asset(
                'assets/icons/ic_profile_unfollow.svg',
                width: 14,
              ),
            ),
          ),
          Visibility(
            visible: profileResponse.profile.instagramId != null,
            child: OutlinedButton(
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: profileResponse.profile.instagramId!));
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(30, 30),
              ),
              child: SvgPicture.asset(
                'assets/icons/ic_profile_insta.svg',
                width: 18,
              ),
            ),
          ),
          Visibility(
            visible: profileResponse.profile.twitterId != null,
            child: OutlinedButton(
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: profileResponse.profile.twitterId!));
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(30, 30),
              ),
              child: SvgPicture.asset(
                'assets/icons/ic_profile_twitter.svg',
                width: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
