import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/ui/screen/chat/chat_room_list_screen.dart';
import 'package:pocket_pose/ui/screen/home/home_search_screen.dart';
import 'package:pocket_pose/ui/view/video/multi_video_play_view.dart';
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

    if (_multiVideoPlayProvider.videoControllers[0].isNotEmpty) {
      setState(() {
        _multiVideoPlayProvider.playVideo(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_multiVideoPlayProvider.videoControllers[0].isNotEmpty) {
      _multiVideoPlayProvider.playVideo(0);
      setState(() {});
    }

    return Scaffold(
        appBar: _appbar(),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: const MultiVideoPlayerView(screenNum: 0));
  }

  AppBar _appbar() {
    return AppBar(
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
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [
        ChatScreen(
            loginProvider: _loginProvider,
            multiVideoPlayProvider: _multiVideoPlayProvider),
        UploadButtonWidget(
          context: context,
        ),
        SearchWidget(context: context),
      ],
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
      child: GestureDetector(
          child: SvgPicture.asset('assets/icons/ic_home_search.svg'),
          onTap: () {
            PageRouteWithSlideAnimation pageRouteWithAnimation =
                PageRouteWithSlideAnimation(const HomeSearchScreen());
            Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
          }),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required KaKaoLoginProvider loginProvider,
    required MultiVideoPlayProvider multiVideoPlayProvider,
  })  : _loginProvider = loginProvider,
        _multiVideoPlayProvider = multiVideoPlayProvider;

  final KaKaoLoginProvider _loginProvider;
  final MultiVideoPlayProvider _multiVideoPlayProvider;

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          if (await widget._loginProvider.checkAccessToken()) {
            widget._multiVideoPlayProvider.pauseVideo(0);
            _showChatScreen();
          } else {
            widget._loginProvider.showLoginBottomSheet();
          }
        },
        child: SvgPicture.asset('assets/icons/ic_home_chat.svg'));
  }

  void _showChatScreen() {
    {
      PageRouteWithSlideAnimation pageRouteWithAnimation =
          PageRouteWithSlideAnimation(const ChatRoomListScreen());
      Navigator.push(context, pageRouteWithAnimation.slideRitghtToLeft());
    }
  }
}
