import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/ui/view/popo_play_view.dart';
import 'package:pocket_pose/ui/view/popo_catch_view.dart';
import 'package:pocket_pose/ui/view/popo_result_view.dart';
import 'package:pocket_pose/ui/view/popo_wait_view.dart';
import 'package:provider/provider.dart';

enum StageStage { waitState, catchState, playState, resultState }

class PoPoStageScreen extends StatefulWidget {
  const PoPoStageScreen({super.key, required this.getIndex()});
  final Function getIndex;

  @override
  State<PoPoStageScreen> createState() => _PoPoStageScreenState();
}

class _PoPoStageScreenState extends State<PoPoStageScreen> {
  int _userCount = 1;
  int _count = 1;
  late Timer _timer;
  late VideoPlayProvider _videoPlayProvider;

  StageStage _stageStage = StageStage.waitState;
  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  @override
  void dispose() {
    AudioPlayerUtil().stop();
    if (widget.getIndex() == 0) {
      _videoPlayProvider.playVideo();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_userCount == 3) {
        _stopTimer();

        if (mounted) {
          setState(() {
            _stageStage = StageStage.catchState;
          });
        }
      } else {
        setState(() {
          _count++;
          _userCount = _count + 1;
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
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
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
                    AudioPlayerUtil().stop();
                    AudioPlayerUtil().stop();
                    if (widget.getIndex() == 0) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/ic_stage_back_white.svg',
                  ),
                ),
                actions: [
                  userCountWidget(),
                ],
              ),
              body: getStageView(_stageStage),
            )),
      ),
    );
  }

  Container userCountWidget() {
    return Container(
      margin: const EdgeInsets.only(right: 16.0, top: 10.0, bottom: 10.0),
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            barrierColor: Colors.transparent,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                backgroundColor: Colors.white.withOpacity(0.4),
                title: Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          '참여자 목록',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                content: const Text('내용'),
              );
            },
          );
        },
        style: OutlinedButton.styleFrom(
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
    );
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
