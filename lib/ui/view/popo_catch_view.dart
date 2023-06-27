import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/ui/screen/popo_stage_screen.dart';

class PoPoCatchView extends StatefulWidget {
  const PoPoCatchView({Key? key, required this.setStageState})
      : super(key: key);
  final Function setStageState;

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
      if (_seconds == 0) {
        _stopTimer();
        Fluttertoast.showToast(msg: '캐치 성공!');
        widget.setStageState(StageStage.playState);
      } else {
        if (mounted) {
          setState(() {
            _seconds--;
          });
        }
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40.0,
            width: double.infinity,
          ),
          const Text(
            "이번 곡은...",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 37.0),
          musicTitleContainer('I AM-IVE'),
          const SizedBox(height: 37.0),
          SvgPicture.asset(
            'assets/images/charactor_popo_catch.svg',
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                side: const BorderSide(
                  width: 1.0,
                  color: Colors.white,
                )),
            child: const Text(
              '캐치!',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            onPressed: () {},
          ),
          const SizedBox(height: 10.0),
          Text('$_seconds',
              style: const TextStyle(fontSize: 14, color: Colors.white))
        ],
      ),
    );
  }

  Widget musicTitleContainer(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(70, 11, 70, 11),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white, width: 3.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(30),
        ),
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
                title,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
