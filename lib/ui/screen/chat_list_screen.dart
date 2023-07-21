import 'package:flutter/material.dart';
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
    return const Scaffold(
      backgroundColor: Colors.red,
    );
  }
}
