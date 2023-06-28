import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:pocket_pose/config/app_color.dart';
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
    with TickerProviderStateMixin {
  late VideoPlayProvider _videoPlayProvider;
  bool _isLiked = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  late AnimationController _progressAnimationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = TweenSequence(
      [
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.8),
          weight: 0.1, // 중간 값의 비중
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.8, end: 1.2),
          weight: 0.6, // 종료 값의 비중
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.2, end: 1.0),
          weight: 0.3, // 시작 값의 비중
        ),
      ],
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceInOut,
      ),
    );

    // liquid-progress
    _progressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
      lowerBound: 0, // 추가: 최소값 설정
      upperBound: 1, // 추가: 최대값 설정
    )..repeat(reverse: false); // 반복 설정
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressAnimationController.dispose(); // 애니메이션 컨트롤러 해제
    super.dispose();
  }

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
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: GestureDetector(
                    onTap: () {
                      _toggleLike();
                      Fluttertoast.showToast(msg: 'like 클릭');
                    },
                    child: SvgPicture.asset(
                      _isLiked
                          ? 'assets/icons/ic_heart_select.svg'
                          : 'assets/icons/ic_home_heart_unselect.svg',
                    ),
                  ),
                );
              },
            ),
            const Padding(padding: EdgeInsets.only(bottom: 2)),
            Text(
              _videoPlayProvider.likes[widget.index],
              style: const TextStyle(color: Colors.white, fontSize: 12),
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
                AnimatedBuilder(
                  animation: _progressAnimationController,
                  builder: (context, child) {
                    return SizedBox(
                      height: 35,
                      width: 35,
                      child: LiquidCircularProgressIndicator(
                        value: _progressAnimationController.value,
                        valueColor:
                            AlwaysStoppedAnimation(AppColor.purpleColor),
                        backgroundColor: Colors.white,
                        direction: Axis.vertical,
                        center: Container(),
                        //임시
                        //     Text(
                        //   (_progressAnimationController.value * 100)
                        //       .toStringAsFixed(0),
                        //   style: const TextStyle(fontSize: 20),
                        // ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
