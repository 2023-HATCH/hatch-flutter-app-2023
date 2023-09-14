import 'dart:async';

import 'package:flutter/material.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

class StageCatchProgressbarWidget extends StatefulWidget {
  const StageCatchProgressbarWidget({super.key, required this.milliseconds});
  final int milliseconds;

  @override
  State<StageCatchProgressbarWidget> createState() =>
      _StageCatchProgressbarWidgetState();
}

class _StageCatchProgressbarWidgetState
    extends State<StageCatchProgressbarWidget> {
  double _catchCountDown = 0.0;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 45,
        child: SemicircularIndicator(
          progress: (_catchCountDown > 1) ? 1 : _catchCountDown,
          color: Colors.yellow,
          bottomPadding: 0,
          strokeWidth: 2,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _startTimer(widget.milliseconds);
  }

  @override
  void dispose() {
    super.dispose();
    _stopTimer();
  }

  void _startTimer(int ms) {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (ms >= 3000) {
        _stopTimer();
      } else {
        if (mounted) {
          setState(() {
            ms = ms + 10;
            _catchCountDown = ms / 3000;
          });
        }
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }
}
