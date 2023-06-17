import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/ui/view/popo_play_view.dart';
import 'package:pocket_pose/ui/view/popo_catch_view.dart';
import 'package:pocket_pose/ui/view/popo_result_view.dart';
import 'package:pocket_pose/ui/view/popo_wait_view.dart';

enum StageStage { waitState, catchState, playState, resultState }

class PoPoStageScreen extends StatefulWidget {
  const PoPoStageScreen({super.key});

  @override
  State<PoPoStageScreen> createState() => _PoPoStageScreenState();
}

class _PoPoStageScreenState extends State<PoPoStageScreen> {
  int _userCount = 1;
  late Timer _timer;

  StageStage _stageStage = StageStage.waitState;

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // 임시로 3초 되면 캐치로 이동
      if (_userCount == 3) {
        _stopTimer();
        setState(() {
          _stageStage = StageStage.catchState;
        });
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

  void setStageState(StageStage newStageStage) {
    setState(() {
      _stageStage = newStageStage;
    });
  }

  bool getIsResultState() => _stageStage == StageStage.resultState;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage((getIsResultState())
                ? 'assets/images/bg_popo_result.png'
                : 'assets/images/bg_popo_comm.png'),
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
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                'assets/icons/ic_home.svg',
              ),
            ),
            actions: [
              Container(
                margin:
                    const EdgeInsets.only(right: 16.0, top: 16.0, bottom: 16.0),
                child: OutlinedButton.icon(
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
              ),
            ],
          ),
          body: getStageView(_stageStage),
        ));
  }

  Widget getStageView(StageStage state) {
    switch (state) {
      case StageStage.waitState:
        return (_userCount < 3)
            ? const PoPoWaitView()
            : PoPoCatchView(setStageState: setStageState);
      case StageStage.catchState:
        return PoPoCatchView(setStageState: setStageState);
      case StageStage.playState:
        return PoPoPlayView(
            setStageState: setStageState, isResultState: getIsResultState());
      case StageStage.resultState:
        return PoPoResultView(
            setStageState: setStageState, isResultState: getIsResultState());
      default:
        return const PoPoWaitView();
    }
  }
}
