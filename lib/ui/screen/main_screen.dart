import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/ui/screen/home/home_screen.dart';
import 'package:pocket_pose/ui/screen/popo_stage_screen.dart';
import 'package:pocket_pose/ui/screen/profile/profile_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late VideoPlayProvider _videoPlayProvider;
  late KaKaoLoginProvider _loginProvider;

  int _bottomNavIndex = 0;

  int getIndex() {
    return _bottomNavIndex;
  }

  @override
  void initState() {
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: false);
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
    _loginProvider.mainContext = context;

    super.initState();
  }

  final List<Widget> _screens = <Widget>[
    const HomeScreen(),
    const ProfileScreen(),
  ];

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _bottomNavIndex = index;
    });
    if (index == 1) {
      _videoPlayProvider.pauseVideo();

      if (await _loginProvider.checkAccessToken() == false) {
        // 사용자 토큰이 없는 경우
        _loginProvider.showLoginBottomSheet();
      }
    } else {
      _videoPlayProvider.playVideo();
    }
  }

  void _onFloatingButtonClicked() async {
    if (await _loginProvider.checkAccessToken()) {
      _videoPlayProvider.pauseVideo();
      _showPoPoStageScreen();
    } else {
      _loginProvider.showLoginBottomSheet();
    }
  }

  void _showPoPoStageScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PoPoStageScreen(getIndex: getIndex)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_bottomNavIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: Colors.black,
        splashColor: AppColor.mainPurpleColor,
        onPressed: _onFloatingButtonClicked,
        child: SvgPicture.asset(
          'assets/icons/ic_bottom_popo.svg',
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 15,
        rightCornerRadius: 15,
        backgroundColor: Colors.black,
        inactiveColor: Colors.white,
        splashColor: AppColor.mainPurpleColor,
        activeColor: AppColor.mainPurpleColor,
        onTap: ((index) => _onItemTapped(index)),
        icons: const [
          CupertinoIcons.music_house_fill,
          CupertinoIcons.person_fill,
        ],
      ),
    );
  }
}
