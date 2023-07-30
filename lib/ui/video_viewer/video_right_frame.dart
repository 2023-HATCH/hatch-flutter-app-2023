import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/ui/video_viewer/widget/chat_button_widget.dart';
import 'package:pocket_pose/ui/video_viewer/widget/like_button_widget.dart';
import 'package:pocket_pose/ui/video_viewer/widget/share_button_widget.dart';
import 'package:provider/provider.dart';

class VideoRightFrame extends StatefulWidget {
  const VideoRightFrame({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  _VideoRightFrameState createState() => _VideoRightFrameState();
}

class _VideoRightFrameState extends State<VideoRightFrame> {
  late VideoPlayProvider _videoPlayProvider;

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    return Positioned(
      right: 12,
      bottom: 100,
      child: SizedBox(
        width: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            LikeButtonWidget(index: widget.index),
            const Padding(padding: EdgeInsets.only(bottom: 14)),
            ChatButtonWidget(
              index: widget.index,
              childWidget: Column(
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/icons/ic_home_chat.svg',
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 2)),
                  Text(
                    '${_videoPlayProvider.videoList[widget.index].commentCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 14)),
            const ShareButtonWidget()
          ],
        ),
      ),
    );
  }
}
