import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';

import 'package:pocket_pose/ui/screen/chat/chat_list_screen.dart';

import 'package:pocket_pose/ui/screen/home/home_search_screen.dart';
import 'package:pocket_pose/ui/video_viewer/video_view.dart';
import 'package:pocket_pose/ui/widget/home/upload_button_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayProvider _videoPlayProvider;
  late KaKaoLoginProvider _loginProvider;

  @override
  void initState() {
    super.initState();
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
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
              _videoPlayProvider.pageController.animateToPage(
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
                    _videoPlayProvider.pauseVideo();
                    _showChatScreen();
                  } else {
                    _loginProvider.showLoginBottomSheet();
                  }
                },
                child: SvgPicture.asset('assets/icons/ic_home_chat_list.svg')),
            UploadButtonWidget(
              context: context,
            ),
            GestureDetector(
              child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                  child: SvgPicture.asset('assets/icons/ic_home_search.svg')),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeSearchScreen())),
            ),
          ],
        ),
        extendBodyBehindAppBar: true, //body 위에 appbar
        resizeToAvoidBottomInset: false,
        body: const VideoView(screenName: 'home'));
  }

  void _showChatScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatListScreen()),
    );
  }
}
