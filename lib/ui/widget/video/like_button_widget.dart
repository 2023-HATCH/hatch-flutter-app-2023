import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/data/remote/provider/like_provider.dart';
import 'package:provider/provider.dart';

class LikeButtonWidget extends StatefulWidget {
  const LikeButtonWidget(
      {super.key, required this.screenNum, required this.index});

  final int screenNum;
  final int index;

  @override
  State<LikeButtonWidget> createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final loginProvider =
        Provider.of<KaKaoLoginProvider>(context, listen: false);

    final multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    final likeProvider = Provider.of<LikeProvider>(context, listen: false);
    final video = multiVideoPlayProvider.videos[widget.screenNum][widget.index];

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
        onTap: (isLiked) async {
          if (await loginProvider.checkAccessToken()) {
            video.liked = !isLiked;
            if (!isLiked) {
              likeProvider.postLike(video.uuid);
              video.likeCount++;
            } else {
              likeProvider.deleteLike(video.uuid);
              video.likeCount--;
            }
            return !isLiked;
          } else {
            loginProvider.showLoginBottomSheet();

            return isLiked;
          }
        },
        likeBuilder: (isLiked) {
          if (isLiked) {
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
        });
  }
}
