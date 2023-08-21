import 'package:flutter/material.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/ui/video_viewer/video_right_frame.dart';
import 'package:pocket_pose/ui/video_viewer/video_user_info_frame.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget(
      {super.key, required int screenNum, required int index})
      : screenNum = screenNum,
        index = index;

  final int screenNum;
  final int index;

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool isIconVisible = false;
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late AnimationController _animationController;

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
            final controller = _multiVideoPlayProvider
                .videoControllers[widget.screenNum][widget.index];
            if (controller.value.isPlaying) {
              _multiVideoPlayProvider.pauseVideo();
              isPlaying = false;
              _toggleIconVisibility(true);
              Future.delayed(const Duration(milliseconds: 800), () {
                _toggleIconVisibility(false);
              });
            } else {
              _multiVideoPlayProvider.playVideo();
              isPlaying = true;
              _toggleIconVisibility(true);
              Future.delayed(const Duration(milliseconds: 800), () {
                _toggleIconVisibility(false);
              });
            }
          },
          child: VideoPlayer(_multiVideoPlayProvider
              .videoControllers[widget.screenNum][widget.index]),
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
                        ? Icons.play_circle_filled_sharp
                        : Icons.pause_circle_filled_sharp,
                    size: 60,
                    color: const Color.fromARGB(127, 147, 147, 147),
                  ),
                ),
              );
            },
          ),
        ),
        VideoRightFrame(screenNum: widget.screenNum, index: widget.index),
        VideoUserInfoFrame(
          screenNum: widget.screenNum,
          index: widget.index,
        ),
      ],
    );
  }
}
