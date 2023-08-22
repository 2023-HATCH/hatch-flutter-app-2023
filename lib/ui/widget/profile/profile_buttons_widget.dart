import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocket_pose/data/entity/response/profile_response.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:provider/provider.dart';

import '../../../data/remote/provider/kakao_login_provider.dart';

class ProfileButtonsWidget extends StatefulWidget {
  const ProfileButtonsWidget({
    Key? key,
    required this.profileResponse,
  }) : super(key: key);

  final ProfileResponse profileResponse;

  @override
  State<ProfileButtonsWidget> createState() => _ProfileButtonsWidgetState();
}

class _ProfileButtonsWidgetState extends State<ProfileButtonsWidget> {
  late KaKaoLoginProvider _loginProvider;
  UserData? _user;
  int loading = 0;
  bool isLogin = false;
  late bool isMe;

  Future<bool> _initUser() async {
    if (await _loginProvider.checkAccessToken()) {
      UserData user = await _loginProvider.getUser();

      _user = user;
    } else {
      _user = null;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _initUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.waiting) {
            loading++;
            if (loading >= 2) {
              if (_user != null) isLogin = true;
              isMe = widget.profileResponse.profile.isMe;

              return Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !isMe,
                      child: Row(
                        children: [
                          // 메시지 버튼
                          Container(
                            margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                            child: OutlinedButton(
                              onPressed: () {
                                if (!isLogin) {
                                  _loginProvider.showLoginBottomSheet();
                                } else {
                                  // 메시지 생성 처리
                                }
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

                          // 팔로잉 버튼
                          Visibility(
                            visible: widget.profileResponse.profile.isFollowing,
                            // 팔로우 안되어 있는 경우
                            replacement: Container(
                              margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                              child: OutlinedButton(
                                onPressed: () {
                                  if (!isLogin) {
                                    _loginProvider.showLoginBottomSheet();
                                  } else {
                                    // 팔로우 처리
                                  }
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
                            // 팔로우 되어 있는 경우
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                              child: OutlinedButton(
                                onPressed: () {
                                  if (!isLogin) {
                                    _loginProvider.showLoginBottomSheet();
                                  } else {
                                    // 언팔로우 처리
                                  }
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
                      visible:
                          widget.profileResponse.profile.instagramId != null &&
                              widget.profileResponse.profile.instagramId != '',
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                        child: OutlinedButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text: widget
                                    .profileResponse.profile.instagramId!));
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
                      visible:
                          widget.profileResponse.profile.twitterId != null &&
                              widget.profileResponse.profile.twitterId != '',
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                        child: OutlinedButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text:
                                    widget.profileResponse.profile.twitterId!));
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
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        });
  }
}
