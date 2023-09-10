import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/ui/view/video/share_video_right_view.dart';
import 'package:pocket_pose/ui/view/video/share_video_user_info_view.dart';
import 'package:provider/provider.dart';

class ShareVideoPlayeView extends StatefulWidget {
  const ShareVideoPlayeView({super.key});

  @override
  State<ShareVideoPlayeView> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<ShareVideoPlayeView>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool isIconVisible = false;
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late AnimationController _animationController;

  final int screenNum = 5;
  final int index = 0;

  @override
  void initState() {
    super.initState();
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 0), // 아이콘이 나타날 때의 애니메이션 속도
      reverseDuration:
          const Duration(milliseconds: 800), // 아이콘이 사라질 때의 애니메이션 속도
      value: 0.0, // 시작 값 설정
    );
  }

  void _toggleIconVisibility(bool newValue) {
    if (mounted) {
      setState(() {
        isIconVisible = newValue;
        if (isIconVisible) {
          _animationController.forward();
        } else {
          _animationController.reverse().then((_) {
            setState(() {
              isIconVisible = false;
            });
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            final controller =
                _multiVideoPlayProvider.videoControllers[screenNum][index];
            if (controller.value.isPlaying) {
              _multiVideoPlayProvider.pauseVideo(screenNum);
              isPlaying = false;
              _toggleIconVisibility(true);
              Future.delayed(const Duration(milliseconds: 800), () {
                _toggleIconVisibility(false);
              });
            } else {
              _multiVideoPlayProvider.playVideo(screenNum);
              isPlaying = true;
              _toggleIconVisibility(true);
              Future.delayed(const Duration(milliseconds: 800), () {
                _toggleIconVisibility(false);
              });
            }
          },
          child: CachedVideoPlayer(
              _multiVideoPlayProvider.videoControllers[screenNum][index]),
        ),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _animationController.value,
                child: Center(
                  child: Icon(
                    isPlaying
                        ? Icons.play_circle_filled_rounded
                        : Icons.pause_circle_filled_rounded,
                    size: 60,
                    color: const Color.fromARGB(179, 133, 133, 133),
                  ),
                ),
              );
            },
          ),
        ),
        ShareVideoRightView(screenNum: screenNum, index: index),
        ShareVideoUserInfoView(
          screenNum: screenNum,
          index: index,
        ),
      ],
    );
  }
}
