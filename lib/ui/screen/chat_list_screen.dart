import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late VideoPlayProvider _videoPlayProvider;
  @override
  void initState() {
    _videoPlayProvider = Provider.of(context, listen: false);
    _videoPlayProvider.pauseVideo();

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayProvider.playVideo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(children: [
        Container(
          color: AppColor.purpleColor,
          height: 3,
        ),
      ]),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "메시지",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: SvgPicture.asset(
          'assets/icons/ic_left_purple.svg',
          width: 11,
          height: 19,
        ),
      ),
    );
  }
}
