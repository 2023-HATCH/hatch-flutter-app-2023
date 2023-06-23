import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/auth_provider.dart';
import 'package:pocket_pose/ui/widget/profile/profile_infomation_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AuthProvider authProvider;

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
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 14, 14, 0),
                        child: SvgPicture.asset(
                            'assets/icons/ic_profile_edit.svg'),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 14, 14, 0),
                        child: SvgPicture.asset(
                            'assets/icons/ic_profile_setting.svg'),
                      ),
                    ],
                  ),
                  ProfileInfomationWidget(),
                ],
              ),
            ),
          ),
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            //foregroundColor: Colors.black87,
            toolbarHeight: 0,
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
                          'assets/icons/ic_profile_heart_select.svg')
                      : SvgPicture.asset(
                          'assets/icons/ic_profile_heart_unselect.svg'),
                ),
              ],
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColor.purpleColor, // 선택된 탭의 줄 색상
                    width: 2.0, // 선택된 탭의 줄 두께
                  ),
                ),
              ),
              onTap: (index) {
                debugPrint("Selected Tab: $index");
                setState(() {}); // Rebuild the widget when tab is selected
              },
            ),
          ),
          if (_tabController.index == 0) // Check if Tab 2 is selected
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
                        scale: Tween<double>(begin: 1.0, end: 0.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOutQuart,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: Image.asset(
                            "assets/images/${_videoImagePath1[index]}.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: _videoImagePath1.length,
              ),
            ),
          if (_tabController.index == 1) // Check if Tab 2 is selected
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
                        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOutQuart,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: Image.asset(
                            "assets/images/${_videoImagePath2[index]}.png",
                            fit: BoxFit.cover,
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
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   authProvider = Provider.of<AuthProvider>(context);

  //   return authProvider.accessToken != null
  //       //토큰이 존재할 경우
  //       ? Scaffold(
  //           appBar: AppBar(
  //             backgroundColor: Colors.transparent, //appBar 투명색
  //             elevation: 0.0, //appBar 그림자 농도 설정 (값 0으로 제거)
  //             actions: [
  //               Container(
  //                   margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
  //                   child:
  //                       SvgPicture.asset('assets/icons/ic_profile_edit.svg')),
  //               Container(
  //                   margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
  //                   child: SvgPicture.asset(
  //                       'assets/icons/ic_profile_setting.svg')),
  //             ],
  //           ),
  //           extendBodyBehindAppBar: true, //body 위에 appbar
  //           body: Column(
  //             children: [
  //               //(1)
  //               ProfileInfomationWidget(),
  //               //(2)
  //               const GridTabBarWidget()
  //             ],
  //           ),
  //         )

  //       //토큰이 존재하지 않는 경우
  //       : const NotLoginWidget();
  // }

