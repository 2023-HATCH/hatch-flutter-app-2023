import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/ui/view/popo_catch_view.dart';
import 'package:pocket_pose/ui/view/popo_wait_view.dart';

class PoPoStageScreen extends StatefulWidget {
  const PoPoStageScreen({super.key});

  @override
  State<PoPoStageScreen> createState() => _PoPoStageScreenState();
}

class _PoPoStageScreenState extends State<PoPoStageScreen> {
  int _userCount = 1;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_userCount == 3) {
        _stopTimer();
      } else {
        setState(() {
          _userCount++;
        });
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/bg_popo_comm.png'),
        ),
      ),
      child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "PoPo 스테이지",
              style: TextStyle(fontSize: 18),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/ic_home.svg',
              ),
            ),
            actions: [
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.zero,
                  // padding: const EdgeInsets.fromLTRB(11, 7, 11, 7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  side: const BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                icon: SvgPicture.asset(
                  'assets/icons/ic_users.svg',
                ),
                label: Text(
                  '$_userCount',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          body:
              (_userCount >= 3) ? const PoPoCatchView() : const PoPoWaitView()),
    );
  }
}
