import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:pocket_pose/config/audio_player/audio_player_util.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:provider/provider.dart';

class StagePlayCountdownWidget extends StatefulWidget {
  const StagePlayCountdownWidget({super.key});

  @override
  State<StagePlayCountdownWidget> createState() =>
      _StagePlayCountdownWidgetState();
}

class _StagePlayCountdownWidgetState extends State<StagePlayCountdownWidget> {
  late StageProviderImpl _stageProvider;
  late SocketStageProviderImpl _socketStageProvider;

  bool _countdownVisibility = false;
  final List<String> _countdownSVG = [
    'assets/icons/ic_countdown_1.png',
    'assets/icons/ic_countdown_2.png',
    'assets/icons/ic_countdown_3.png',
    'assets/icons/ic_countdown_4.png',
    'assets/icons/ic_countdown_5.png',
  ];
  int _seconds = 5;
  Timer? _timer;
  AssetsAudioPlayer? _assetsAudioPlayer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
            visible: _countdownVisibility,
            child: (6 > _seconds) && (_seconds > 0)
                ? Image.asset(_countdownSVG[_seconds - 1])
                : Container())
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _stageProvider = Provider.of<StageProviderImpl>(context, listen: false);
    _socketStageProvider =
        Provider.of<SocketStageProviderImpl>(context, listen: false);
    _assetsAudioPlayer = AssetsAudioPlayer();

    // 입장 처리
    _onEnter();
  }

  @override
  void dispose() {
    _stopTimer();
    _assetsAudioPlayer = null;
    _assetsAudioPlayer?.dispose();

    super.dispose();
  }

  void _onEnter() {
    (_socketStageProvider.catchMusicData != null)
        ? AudioPlayerUtil()
            .setMusicUrl(_socketStageProvider.catchMusicData!.musicUrl)
        : AudioPlayerUtil().setMusicUrl(_stageProvider.music!.musicUrl);

    // 중간임장인 경우
    if (_stageProvider.stageCurTime != null) {
      // 중간 입장한 초부터 시작
      _seconds = (_stageProvider.stageCurTime! / (1000000 * 1000)).round();
      _stageProvider.setStageCurSecondNULL();
    } else {
      // 중간입장 아닐 시 0초부터 시작
      _seconds = 0;
    }
    print("mmm play countdown1 $_seconds");
    // 카운트다운
    if (_seconds < 5) {
      // 카운트다운 시작 후 노래 재생
      setState(() {
        _seconds = 5 - _seconds;
        _countdownVisibility = true;
      });
      _startTimer();
    }
    // 노래 재생
    else {
      AudioPlayerUtil().playSeek(_seconds - 5);
    }

    print("mmm play countdown2 $_seconds");
  }

  void _startTimer() {
    _assetsAudioPlayer?.open(Audio("assets/audios/sound_play_wait.mp3"));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 1) {
        _stopTimer();

        if (mounted) {
          setState(() {
            _countdownVisibility = false;
          });
        }
        _seconds = 5;
        AudioPlayerUtil().play();
      } else {
        if (mounted) {
          _assetsAudioPlayer?.open(Audio("assets/audios/sound_play_wait.mp3"));
          setState(() {
            _seconds--;
          });
        }
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
