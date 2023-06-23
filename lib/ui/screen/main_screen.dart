import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/data/local/provider/auth_provider.dart';
import 'package:pocket_pose/ui/screen/home_screen.dart';
import 'package:pocket_pose/ui/screen/popo_stage_screen.dart';
import 'package:pocket_pose/ui/screen/profile_screen.dart';
import 'package:pocket_pose/ui/widget/login_modal_content_widget.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late VideoPlayProvider _videoPlayProvider;
  late AuthProvider authProvider;
  int _bottomNavIndex = 0;

  @override
  void initState() {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
    _videoPlayProvider.initializeVideoPlayerFutures();

    super.initState();
  }

  final List<Widget> _screens = <Widget>[
    const HomeScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;

      if (index == 1) {
        _videoPlayProvider.pauseVideo();

        if (authProvider.accessToken == null) {
          _showModalBottomSheet(); //토큰이 존재하지 않는 경우
        }
      } else {
        _videoPlayProvider.playVideo();
      }
    });
  }

  void _onFloatingButtonClicked() {
    _videoPlayProvider.pauseVideo();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PoPoStageScreen()),
    );
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      builder: (BuildContext context) {
        return const LoginModalContent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);

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
