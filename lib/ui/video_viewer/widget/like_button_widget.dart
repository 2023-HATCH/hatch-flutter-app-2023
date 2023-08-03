import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LikeButtonWidget extends StatefulWidget {
  LikeButtonWidget({super.key, required this.index});

  int index;

  @override
  State<LikeButtonWidget> createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  late VideoPlayProvider _videoPlayProvider;

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
    final video = _videoPlayProvider.videoList[widget.index];

    return LikeButton(
      size: 25,
      likeCount: video.likeCount,
      isLiked: video.liked,
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
    );
  }
}
