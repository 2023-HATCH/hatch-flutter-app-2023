import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/ui/screen/home_screen.dart';
import 'package:pocket_pose/ui/screen/popo_screen.dart';
import 'package:pocket_pose/ui/screen/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _bottomNavIndex = 0;

  final List<Widget> _screens = <Widget>[
    const HomeScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  void _onFloatingButtonClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PoPoScreen()),
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
          'assets/icons/bottom_popo.svg',
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
