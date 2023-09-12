import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/data/remote/provider/profile_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/ui/view/profile/profile_tab_videos_view.dart';
import 'package:pocket_pose/ui/widget/profile/profile_tapbar_widget.dart';

import 'package:pocket_pose/ui/view/profile/profile_user_info_view.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    this.isNavigation,
    this.userId,
    Key? key,
  }) : super(key: key);

  final bool? isNavigation;
  final String? userId;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late KaKaoLoginProvider _loginProvider;
  late ProfileProvider _profileProvider;
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late String? _userId;

  int loading = 0;

  @override
  void initState() {
    super.initState();

    _userId = widget.userId;

    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    _multiVideoPlayProvider.pauseVideo(0);

    _multiVideoPlayProvider.isOpenProfile = true;
  }

  Future<bool> _initUser() async {
    if (!_profileProvider.isGetProfilDone) {
      // 로그인 했는지 확인
      if (await _loginProvider.checkAccessToken()) {
        // 로그인 한 경우
        UserData user = await _loginProvider.getUser(); // 로그인 된 사용자 정보

        if (mounted) {
          setState(() {
            if (_userId != null) {
              // navigation이 아닌 곳에서 자신의 프로필을 조회한 경우
              // if (_userId == user.userId) {
              //   isNotBottomNavi = true;
              // }
            }
            _userId ??= user.userId;
          });
        }
      }
      _profileProvider.isGetProfilDone = true;
      if (_userId == null) {
        return true;
      } else {
        _profileProvider.getUserProfile(_userId!);
      }
    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();

    // 프로필 정보 삭제
    _profileProvider.profileResponse = null;
    _profileProvider.isGetProfilDone = false;

    _multiVideoPlayProvider.isOpenProfile = false;
  }

  @override
  Widget build(BuildContext context) {
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: true);
    _profileProvider = Provider.of<ProfileProvider>(context, listen: true);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (_profileProvider.profileResponse != null &&
            (!_profileProvider.profileResponse!.profile.isMe ||
                _profileProvider.profileResponse!.profile.isMe &&
                    (widget.isNavigation == null || !widget.isNavigation!)) &&
            details.primaryDelta! > 10) {
          // 왼쪽에서 오른쪽으로 드래그했을 때 pop
          Navigator.of(context).pop();
        }
      },
      child: FutureBuilder(
          future: _initUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.waiting) {
              return _profileProvider.profileResponse != null
                  ? Scaffold(
                      body: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                ProfileTapbarWidget(
                                  profileResponse:
                                      _profileProvider.profileResponse!,
                                  isBottomNavi: widget.isNavigation ?? false,
                                ),
                                ProfileUserInfoWidget(
                                    profileResponse:
                                        _profileProvider.profileResponse!),
                                const SizedBox(
                                  height: 14,
                                )
                              ],
                            ),
                          ),
                          ProfileTabVideosWidget(
                            profileResponse: _profileProvider.profileResponse!,
                          ),
                        ],
                      ),
                    )
                  : Container(
                      color: Colors.white,
                      child: Center(
                          child: SpinKitPumpingHeart(
                        color: Colors.pink[100],
                        size: 50.0,
                      )),
                    );
            } else {
              return Container(
                color: Colors.white,
                child: Center(
                    child: SpinKitPumpingHeart(
                  color: Colors.pink[100],
                  size: 50.0,
                )),
              );
            }
          }),
    );
  }
}
