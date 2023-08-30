import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/ui/view/home/comment_button_view.dart';
import 'package:pocket_pose/ui/widget/video/like_button_widget.dart';
import 'package:pocket_pose/ui/widget/video/share_button_widget.dart';
import 'package:provider/provider.dart';

class VideoRightFrame extends StatefulWidget {
  const VideoRightFrame(
      {Key? key, required this.screenNum, required this.index})
      : super(key: key);

  final int screenNum;
  final int index;

  @override
  _VideoRightFrameState createState() => _VideoRightFrameState();
}

class _VideoRightFrameState extends State<VideoRightFrame> {
  late MultiVideoPlayProvider _multiVideoPlayProvider;

  @override
  Widget build(BuildContext context) {
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    final video =
        _multiVideoPlayProvider.videos[widget.screenNum][widget.index];

    return Positioned(
      right: 12, // 12
      bottom: 100,
      child: SizedBox(
        width: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 7),
              child: LikeButtonWidget(
                  screenNum: widget.screenNum, index: widget.index),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
              child: CommentButtonView(
                screenNum: widget.screenNum,
                index: widget.index,
                onRefresh: () {
                  setState(() {});
                },
                videoId: video.uuid,
                commentCount: video.commentCount,
                childWidget: Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/icons/ic_home_comment.svg',
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 2)),
                    Text(
                      '${video.commentCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(14, 7, 14, 7),
              child: ShareButtonWidget(),
            )
          ],
        ),
      ),
    );
  }
}
