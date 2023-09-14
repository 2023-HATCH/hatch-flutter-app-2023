import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';

class StageCatchMusicInfoWidget extends StatefulWidget {
  const StageCatchMusicInfoWidget(
      {super.key, required this.milliseconds, required this.musicInfo});
  final int milliseconds;
  final String musicInfo;

  @override
  State<StageCatchMusicInfoWidget> createState() =>
      _StageCatchMusicInfoWidgetState();
}

class _StageCatchMusicInfoWidgetState extends State<StageCatchMusicInfoWidget>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(60, 11, 60, 11),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white, width: 3.0, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              for (double i = 1; i < 5; i++)
                BoxShadow(
                    color: AppColor.yellowColor,
                    blurStyle: BlurStyle.outer,
                    blurRadius: 3 * i)
            ]),
        child: AnimatedOpacity(
          opacity: _opacityAnimation.value,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.all(11.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_music_note_big.svg',
                ),
                const SizedBox(width: 8.0),
                Text(
                  widget.musicInfo,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
    _startTimer(widget.milliseconds);
  }

  @override
  void dispose() {
    super.dispose();
    _stopTimer();
    _animationController.dispose();
  }

  void _startTimer(int ms) {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (ms >= 3000) {
        _stopTimer();
      } else {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }
}
