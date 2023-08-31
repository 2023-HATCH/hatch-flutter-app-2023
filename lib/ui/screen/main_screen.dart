import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/ui/screen/home/home_screen.dart';
import 'package:pocket_pose/ui/screen/popo_stage_screen.dart';
import 'package:pocket_pose/ui/screen/profile/profile_screen.dart';
import 'package:pocket_pose/ui/widget/not_login_widget.dart';
import 'package:pocket_pose/ui/widget/page_route_with_animation.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late KaKaoLoginProvider _loginProvider;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int _bottomNavIndex = 0;
  bool isLogin = false;

  int getIndex() {
    return _bottomNavIndex;
  }

  List<Widget> _screens = [const HomeScreen(), ProfileScreen()];

  @override
  void initState() {
    super.initState();

    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: false);

    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    _multiVideoPlayProvider.mainContext = context;

    _initIsLoginAndScreens();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initIsLoginAndScreens() async {
    isLogin = await _loginProvider.checkAccessToken();

    if (mounted) {
      setState(() {
        _screens = [
          const HomeScreen(),
          isLogin ? ProfileScreen() : const NotLoginWidget(),
        ];
      });
    }
  }

  void _onItemTapped(int index) async {
    if (index == 1) {
      _loginProvider.mainContext = context;
      // 프로필 페이지 클릭
      _multiVideoPlayProvider.pauseVideo(0);

      if (await _loginProvider.checkAccessToken() == false) {
        // 사용자 토큰이 없는 경우
        _loginProvider.showLoginBottomSheet();
        isLogin = false;
        _screens = [
          const HomeScreen(),
          isLogin ? ProfileScreen() : const NotLoginWidget(),
        ];
      } else {
        isLogin = true;
      }

      _screens = [
        const HomeScreen(),
        isLogin ? ProfileScreen() : const NotLoginWidget(),
      ];
    } else {
      // 홈 페이지 클릭
      _multiVideoPlayProvider.playVideo(0);
    }

    setState(() {
      _bottomNavIndex = index;
    });
  }

  void _onFloatingButtonClicked() async {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    if (await _loginProvider.checkAccessToken()) {
      _multiVideoPlayProvider.pauseVideo(0);
      _showPoPoStageScreen();
    } else {
      _loginProvider.showLoginBottomSheet();
      if (await _loginProvider.checkAccessToken()) {
        _multiVideoPlayProvider.resetVideoPlayer(0);
      }
    }
  }

  void _playClickSound() {
    AssetsAudioPlayer.newPlayer()
        .open(Audio("assets/audios/sound_catch_click.mp3"));
  }

  void _showPoPoStageScreen() {
    _playClickSound();
    PageRouteWithSlideAnimation pageRouteWithAnimation =
        PageRouteWithSlideAnimation(PoPoStageScreen(getIndex: getIndex));
    Navigator.push(context, pageRouteWithAnimation.fadeInFadeOutRoute());
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
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: SvgPicture.asset('assets/icons/ic_bottom_popo.svg'),
            );
          },
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
