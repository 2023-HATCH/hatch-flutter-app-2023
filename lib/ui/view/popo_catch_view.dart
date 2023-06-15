import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocket_pose/ui/screen/popo_play_screen.dart';

class PoPoCatchView extends StatefulWidget {
  const PoPoCatchView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PoPoCatchViewState();
}

class _PoPoCatchViewState extends State<PoPoCatchView> {
  int _seconds = 3;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 1) {
        _stopTimer();

        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const PoPoPlayScreen()));
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$_seconds',
                style: const TextStyle(fontSize: 72, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
