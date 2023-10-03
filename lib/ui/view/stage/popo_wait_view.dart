import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PoPoWaitView extends StatefulWidget {
  const PoPoWaitView({Key? key}) : super(key: key);

  @override
  State<PoPoWaitView> createState() => _PoPoWaitViewState();
}

class _PoPoWaitViewState extends State<PoPoWaitView> {
  AssetsAudioPlayer? _assetsAudioPlayer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 80.0),
              const Text(
                "대기중...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              const Text(
                "3명 이상 참여하면 시작됩니다!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 20.0),
              Flexible(
                child: SvgPicture.asset(
                  'assets/images/charactor_popo_wait.svg',
                ),
              ),
            ],
          ),
        ),
        const Flexible(
          flex: 1,
          child: SizedBox(
            height: 60.0 + 150.0,
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    _assetsAudioPlayer = AssetsAudioPlayer();
    _assetsAudioPlayer?.open(Audio("assets/audios/sound_stage_wait.mp3"));
    super.initState();
  }

  @override
  void dispose() {
    _assetsAudioPlayer?.stop();
    _assetsAudioPlayer?.dispose();
    _assetsAudioPlayer = null;
    super.dispose();
  }
}
