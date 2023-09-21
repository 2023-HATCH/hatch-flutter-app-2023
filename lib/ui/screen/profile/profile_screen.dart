import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/data/remote/provider/profile_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/ui/loader/profile_screen_loader.dart';
import 'package:pocket_pose/ui/screen/main_screen.dart';
import 'package:pocket_pose/ui/view/profile/profile_tab_videos_view.dart';
import 'package:pocket_pose/ui/widget/profile/profile_tapbar_widget.dart';

import 'package:pocket_pose/ui/view/profile/profile_user_info_view.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    this.isNavigation,
    this.userId,
    this.isNotification,
    Key? key,
  }) : super(key: key);

  final bool? isNavigation;
  final String? userId;
  final bool? isNotification;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late KaKaoLoginProvider _loginProvider;
  late ProfileProvider _profileProvider;
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late String? _userId;
  late TabController _tabController;

  int loading = 0;

  @override
  void initState() {
    super.initState();

    _userId = widget.userId;

    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    _multiVideoPlayProvider.pauseVideo(0);

    _multiVideoPlayProvider.isOpenProfile = true;

    _tabController = TabController(length: 2, vsync: this);
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

    _tabController.dispose();
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
          if (widget.isNotification != null && widget.isNotification!) {
            _multiVideoPlayProvider.resetVideoPlayer(0);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false,
            );
          } else {
            Navigator.of(context).pop();
          }
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
                                  isNotification: widget.isNotification,
                                ),
                                ProfileUserInfoWidget(
                                    profileResponse:
                                        _profileProvider.profileResponse!),
                              ],
                            ),
                          ),
                          SliverAppBar(
                            pinned: true,
                            backgroundColor: AppColor.whiteColor,
                            toolbarHeight: 0.0,
                            bottom: TabBar(
                              controller: _tabController,
                              tabs: [
                                Tab(
                                  icon: _tabController.index == 0
                                      ? SvgPicture.asset(
                                          'assets/icons/ic_profile_list_select.svg')
                                      : SvgPicture.asset(
                                          'assets/icons/ic_profile_list_unselect.svg'),
                                ),
                                Tab(
                                  icon: _tabController.index == 1
                                      ? SvgPicture.asset(
                                          'assets/icons/ic_heart_select.svg')
                                      : SvgPicture.asset(
                                          'assets/icons/ic_heart_unselect.svg'),
                                ),
                              ],
                              indicator: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColor.purpleColor,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              onTap: (index) {
                                debugPrint("Selected Tab: $index");
                                setState(
                                    () {}); // index에 따라 업로드, 좋아요 영상 조회 api 호출
                              },
                            ),
                          ),
                          ProfileTabVideosWidget(
                            index: _tabController.index,
                            tabController: _tabController,
                            profileResponse: _profileProvider.profileResponse!,
                          ),
                        ],
                      ),
                    )
                  : const ProfileScreenLoader();
            } else {
              return const ProfileScreenLoader();
            }
          }),
    );
  }
}
