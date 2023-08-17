import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/data/remote/provider/profile_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/ui/video_viewer/widget/profile_tab_videos_widget.dart';
import 'package:pocket_pose/ui/video_viewer/widget/profile_tapbar_widget.dart';

import 'package:pocket_pose/ui/widget/profile/profile_user_info_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  ProfileScreen({
    this.userId,
    Key? key,
  }) : super(key: key);

  String? userId;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late KaKaoLoginProvider _loginProvider;
  late ProfileProvider _profileProvider;
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late String? _userId;

  bool isNotBottomNavi = false;

  final List<String> _videoImagePath1 = [
    "profile_video_0",
    "profile_video_1",
    "profile_video_3",
    "profile_video_5",
    "profile_video_0",
    "profile_video_1",
    "profile_video_2",
    "profile_video_3",
    "profile_video_5",
    "profile_video_0",
    "profile_video_1",
    "profile_video_2",
    "profile_video_3",
    "profile_video_5",
    "profile_video_0",
    "profile_video_1",
    "profile_video_2",
    "profile_video_3",
    "profile_video_5",
  ];

  final List<String> _videoImagePath2 = [
    "profile_video_8",
    "profile_video_10",
    "profile_video_11",
    "profile_video_6",
    "profile_video_8",
    "profile_video_10",
    "profile_video_11",
    "profile_video_6",
    "profile_video_8",
    "profile_video_10",
    "profile_video_11",
    "profile_video_6",
  ];

  late TabController _tabController;
  int loading = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _userId = widget.userId;

    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    _multiVideoPlayProvider.pauseVideo();
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
              if (_userId == user.userId) {
                isNotBottomNavi = true;
              }
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
    _tabController.dispose();
    _multiVideoPlayProvider.playVideo();
    _profileProvider.isGetProfilDone = false;
  }

  @override
  Widget build(BuildContext context) {
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: true);
    _profileProvider = Provider.of<ProfileProvider>(context, listen: true);

    return FutureBuilder(
        future: _initUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            loading++;
            if (loading >= 2) {
              return _profileProvider.response != null
                  ? Scaffold(
                      body: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                ProfileTapbarWidget(
                                  profileResponse: _profileProvider.response!,
                                  isNotBottomNavi: isNotBottomNavi,
                                ),
                                ProfileUserInfoWidget(
                                    profileResponse:
                                        _profileProvider.response!),
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
                              videoImagePath1: _videoImagePath1,
                              videoImagePath2: _videoImagePath2),
                        ],
                      ),
                    )
                  : Container(
                      color: Colors.white,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.purpleColor,
                        ),
                      ),
                    );
            } else {
              return Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColor.purpleColor,
                  ),
                ),
              );
            }
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColor.purpleColor,
                ),
              ),
            );
          }
        });
  }
}
