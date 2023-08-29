import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';

import 'package:pocket_pose/ui/screen/chat/chat_room_list_screen.dart';

import 'package:pocket_pose/ui/screen/home/home_search_screen.dart';
import 'package:pocket_pose/ui/view/video/multi_video_player_view.dart';
import 'package:pocket_pose/ui/widget/home/upload_button_widget.dart';
import 'package:pocket_pose/ui/widget/page_route_with_animation.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late KaKaoLoginProvider _loginProvider;

  @override
  void initState() {
    super.initState();
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    _loginProvider = Provider.of<KaKaoLoginProvider>(context, listen: false);
    _loginProvider.mainContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            child: const Text(
              "PoPo",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              _multiVideoPlayProvider.pageControllers[0].animateToPage(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
          backgroundColor: Colors.transparent, //appBar 투명색
          elevation: 0.0, //appBar 그림자 농도 설정 (값 0으로 제거)
          actions: [
            GestureDetector(
                onTap: () async {
                  if (await _loginProvider.checkAccessToken()) {
                    _multiVideoPlayProvider.pauseVideo(0);
                    _showChatScreen();
                  } else {
                    _loginProvider.showLoginBottomSheet();
                  }
                },
                child: SvgPicture.asset('assets/icons/ic_home_chat.svg')),
            UploadButtonWidget(
              context: context,
            ),
            GestureDetector(
                child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                    child: SvgPicture.asset('assets/icons/ic_home_search.svg')),
                onTap: () {
                  PageRouteWithSlideAnimation pageRouteWithAnimation =
                      PageRouteWithSlideAnimation(const HomeSearchScreen());
                  Navigator.push(
                      context, pageRouteWithAnimation.slideRitghtToLeft());
                }),
          ],
        ),
        extendBodyBehindAppBar: true, //body 위에 appbar
        resizeToAvoidBottomInset: false,
        body: const MultiVideoPlayerView(screenNum: 0));
  }

  void _showChatScreen() {
    {
      PageRouteWithSlideAnimation pageRouteWithAnimation =
          PageRouteWithSlideAnimation(const ChatRoomListScreen());
      Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
    }
  }
}
