import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:provider/provider.dart';

class VideoFrameRightWidget extends StatefulWidget {
  const VideoFrameRightWidget({Key? key, required this.index})
      : super(key: key);

  final int index;

  @override
  _VideoFrameRightWidgetState createState() => _VideoFrameRightWidgetState();
}

class _VideoFrameRightWidgetState extends State<VideoFrameRightWidget>
    with SingleTickerProviderStateMixin {
  late VideoPlayProvider _videoPlayProvider;
  // bool _isLiked = false;
  // late AnimationController _animationController;
  // late Animation<double> _animation;

  // @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 200),
  //   );
  //   _animation = TweenSequence(
  //     [
  //       TweenSequenceItem(
  //         tween: Tween<double>(begin: 1.0, end: 0.8),
  //         weight: 0.1, // 중간 값의 비중
  //       ),
  //       TweenSequenceItem(
  //         tween: Tween<double>(begin: 0.8, end: 1.2),
  //         weight: 0.6, // 종료 값의 비중
  //       ),
  //       TweenSequenceItem(
  //         tween: Tween<double>(begin: 1.2, end: 1.0),
  //         weight: 0.3, // 시작 값의 비중
  //       ),
  //     ],
  //   ).animate(
  //     CurvedAnimation(
  //       parent: _animationController,
  //       curve: Curves.bounceInOut,
  //     ),
  //   );
  // }

  // void _toggleLike() {
  //   setState(() {
  //     _isLiked = !_isLiked;
  //     if (_isLiked) {
  //       _animationController.reverse();
  //     } else {
  //       _animationController.forward();
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   super.dispose();
  // }

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
            // AnimatedBuilder(
            //   animation: _animationController,
            //   builder: (context, child) {
            //     return Transform.scale(
            //       scale: _animation.value,
            //       child: GestureDetector(
            //         onTap: () {
            //           _toggleLike();
            //           Fluttertoast.showToast(msg: 'like 클릭');
            //         },
            //         child: SvgPicture.asset(
            //           _isLiked
            //               ? 'assets/icons/ic_heart_select.svg'
            //               : 'assets/icons/ic_home_heart_unselect.svg',
            //         ),
            //       ),
            //     );
            //   },
            // ),
            // const Padding(padding: EdgeInsets.only(bottom: 2)),
            // Text(
            //   _videoPlayProvider.likes[widget.index],
            //   style: const TextStyle(color: Colors.white, fontSize: 12),
            // ),
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
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(msg: 'share 클릭');
                  },
                  child: SvgPicture.asset(
                    'assets/icons/ic_home_share.svg',
                  ),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 14)),
            Column(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icons/ic_home_progress.svg',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
