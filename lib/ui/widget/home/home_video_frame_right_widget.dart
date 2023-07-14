import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/ui/widget/home/share_button_widget.dart';
import 'package:provider/provider.dart';

class VideoFrameRightWidget extends StatefulWidget {
  const VideoFrameRightWidget({Key? key, required this.index})
      : super(key: key);

  final int index;

  @override
  _VideoFrameRightWidgetState createState() => _VideoFrameRightWidgetState();
}

class _VideoFrameRightWidgetState extends State<VideoFrameRightWidget> {
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
            LikeButton(
              size: 25,
              likeCount: _videoPlayProvider.likes[widget.index],
              countPostion: CountPostion.bottom,
              countDecoration: (count, likeCount) {
                return Text(
                  likeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                );
              },
              likeBuilder: (isTapped) {
                if (isTapped) {
                  return const Icon(
                    Icons.favorite,
                    size: 25,
                    color: Colors.red,
                  );
                } else {
                  return SvgPicture.asset(
                    'assets/icons/ic_home_heart_unselect.svg',
                  );
                }
              },
            ),
            const Padding(padding: EdgeInsets.only(bottom: 14)),
            GestureDetector(
              onTap: () {
                Fluttertoast.showToast(msg: 'chat 클릭');
              },
              child: Column(
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/icons/ic_home_chat.svg',
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 2)),
                  Text(
                    _videoPlayProvider.chats[widget.index],
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
