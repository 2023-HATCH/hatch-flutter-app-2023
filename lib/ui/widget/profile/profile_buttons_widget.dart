import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          Visibility(
            visible: !profileResponse.profile.isMe,
            child: Row(
              children: [
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
                      minimumSize: const Size(100, 30),
                    ),
                    child: const Text(
                      "메시지",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                // 💥 사용자 프로필 조회 api 수정되면 팔로우 여부에 따라 다른 버튼 보이게 하기
                Visibility(
                  visible:
                      true, // profileResponse.profile.isFollow, // 팔로우 했는가?
                  // 팔로우 안되어 있는 경우
                  replacement: Container(
                    margin: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                    child: OutlinedButton(
                      onPressed: () {
                        // 팔로우 처리
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(30, 30),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.userPlus,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // 팔로우 한 경우
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                    child: OutlinedButton(
                      onPressed: () {
                        // 언팔로우 처리
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(30, 30),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.userCheck,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: profileResponse.profile.instagramId != null,
            child: Container(
              margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
              child: OutlinedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                      text: profileResponse.profile.instagramId!));
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
          ),
          Visibility(
            visible: profileResponse.profile.twitterId != null,
            child: Container(
              margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
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
            ),
          )
        ],
      ),
    );
  }
}
