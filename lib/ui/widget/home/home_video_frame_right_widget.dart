// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:provider/provider.dart';

class VideoFrameRightWidget extends StatelessWidget {
  VideoFrameRightWidget({super.key, required this.index});

  late VideoPlayProvider _videoPlayProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    return Positioned(
      right: 12,
      bottom: 100,
      child: SizedBox(
        //color: Colors.orange,
        width: 60,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(msg: 'like 클릭');
                },
                child: Column(children: <Widget>[
                  SvgPicture.asset(
                    'assets/icons/home_like.svg',
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 2)),
                  Text(
                    _videoPlayProvider.likes[index],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ]),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 14)),
              GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(msg: 'chat 클릭');
                },
                child: Column(children: <Widget>[
                  SvgPicture.asset(
                    'assets/icons/home_chat.svg',
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 2)),
                  Text(
                    _videoPlayProvider.chats[index],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ]),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 14)),
              Column(children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(msg: 'share 클릭');
                  },
                  child: SvgPicture.asset(
                    'assets/icons/home_share.svg',
                  ),
                )
              ]),
              const Padding(padding: EdgeInsets.only(bottom: 14)),
              Column(children: <Widget>[
                SvgPicture.asset(
                  'assets/icons/home_progress.svg',
                ),
              ]),
            ]),
      ),
    );
  }
}
