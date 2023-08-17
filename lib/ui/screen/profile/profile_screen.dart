import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/data/remote/provider/profile_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/ui/video_viewer/widget/profile_tab_videos_widget.dart';
import 'package:pocket_pose/ui/video_viewer/widget/profile_tapbar_widget.dart';

import 'package:pocket_pose/ui/widget/not_login_widget.dart';
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
  late UserData _user;
  late String? _userId = widget.userId;
  bool isLogin = false;
  bool isGetProfilDone = false;

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

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  Future<bool> _initUser() async {
    if (isLogin == true) {
      return true;
    }
    if (await _loginProvider.checkAccessToken()) {
      isLogin = true;
      UserData user = await _loginProvider.getUser();
      if (mounted) {
        setState(() {
          _user = user;
          _userId = _user.userId;
        });
      }

      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: true);
    _profileProvider = Provider.of<ProfileProvider>(context, listen: true);

    if (!isGetProfilDone) {
      if (_userId == null) {
        debugPrint('프로필: 사용자입니다!!!!!!!!');
        _initUser().then((value) {
          if (value) {
            debugPrint('프로필: 로그인 했습니다. 로그인 $isLogin');
            _profileProvider.getUserProfile(_userId!);
          } else {
            debugPrint('프로필: 로그인 하지 않았습니다.로그인 $isLogin');
          }
        });
      } else {
        debugPrint('프로필: 다른 사용자입니다!!!!!!!!로그인 $isLogin');
        _profileProvider.getUserProfile(_userId!); // 다른 사용자일 경우
      }

      isGetProfilDone = true;

      debugPrint('프로필 FutureBuilder 전!!!!!!!!!: $_userId');
      if (_profileProvider.response != null) {
        debugPrint(
            '프로필 user 정보 !!!!!!!!!: ${_profileProvider.response!.profile.isMe}');
        debugPrint(
            '프로필 user 정보 !!!!!!!!!: ${_profileProvider.response!.user.nickname}');
      }
    }
    return _profileProvider.response != null
        ? Visibility(
            visible: _profileProvider.response!.profile.isMe && !isLogin,
            replacement: Scaffold(
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const ProfileTapbarWidget(), // isMe에 따라 보이기
                        ProfileUserInfoWidget(
                          user: _profileProvider.response!.user,
                          profile: _profileProvider.response!.profile,
                        ),
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
                        setState(() {}); // index에 따라 업로드, 좋아요 영상 조회 api 호출
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
            ),
            child: const NotLoginWidget(),
          )
        : Center(
            child: CircularProgressIndicator(
              color: AppColor.purpleColor,
            ),
          );
  }
}
