import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/domain/entity/user_data.dart';
import 'package:pocket_pose/ui/video_viewer/screen/video_someone_screen.dart';
import 'package:pocket_pose/ui/screen/profile/profile_edit_screen.dart';
import 'package:pocket_pose/ui/video_viewer/screen/video_my_screen.dart';
import 'package:pocket_pose/ui/screen/profile/profile_setting_screen.dart';

import 'package:pocket_pose/ui/widget/not_login_widget.dart';
import 'package:pocket_pose/ui/widget/profile/profile_user_info_widget.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late KaKaoLoginProvider _loginProvider;
  late UserData _user;

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
    if (await _loginProvider.checkAccessToken()) {
      UserData user = await _loginProvider.getUser();
      if (mounted) {
        setState(() {
          _user = user;
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

    return FutureBuilder<bool>(
      future: _initUser(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileEditScreen()),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 36, 14, 0),
                                child: SvgPicture.asset(
                                    'assets/icons/ic_profile_edit.svg'),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileSettingScreen()),
                                );
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
                      ProfileUserInfoWidget(
                        user: _user,
                      ),
                    ],
                  ),
                ),
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.white,
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
                      setState(() {});
                    },
                  ),
                ),
                if (_tabController.index == 0)
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return AnimatedBuilder(
                          animation: _tabController.animation!,
                          builder: (context, child) {
                            final animation = _tabController.animation!;
                            return ScaleTransition(
                              scale:
                                  Tween<double>(begin: 1.0, end: 0.0).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOutQuart,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VideoMyScreen(
                                              index:
                                                  0))); //사용자 index 값 넣기 (0은 임시 값)
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        "assets/images/${_videoImagePath1[index]}.png",
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/ic_profile_heart.svg',
                                              width: 16,
                                              height: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              '1.5k',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: _videoImagePath1.length,
                    ),
                  ),
                if (_tabController.index == 1)
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return AnimatedBuilder(
                          animation: _tabController.animation!,
                          builder: (context, child) {
                            final animation = _tabController.animation!;
                            return ScaleTransition(
                              scale:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOutQuart,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VideoSomeoneScreen(
                                              index:
                                                  0))); //사용자 index 값 넣기 (0은 임시 값)
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        "assets/images/${_videoImagePath1[index]}.png",
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/ic_profile_heart.svg',
                                              width: 16,
                                              height: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            const Text(
                                              '1.5k',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: _videoImagePath2.length,
                    ),
                  ),
              ],
            ),
          );
        } else {
          return const NotLoginWidget();
        }
      },
    );
  }
}
