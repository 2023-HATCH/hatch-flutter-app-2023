import 'package:assets_audio_player/assets_audio_player.dart';

class AudioPlayerUtil {
  AssetsAudioPlayer? player = AssetsAudioPlayer.newPlayer();

  static final AudioPlayerUtil _instance = AudioPlayerUtil._internal();

  factory AudioPlayerUtil() => _instance;

  AudioPlayerUtil._internal() {
    // _audioSessionConfigure();
  }

  setVolume(double value) {
    player?.setVolume(value);
  }

  play(String url) async {
    // 내부 음악 실행
    await player?.open(Audio.network(url));
    // 외부 음악 종료
    // await audioSession?.setActive(false);
  }

  playSeek(int sec, String url) async {
    // 내부 음악 실행
    await player?.open(Audio.network(url));
    await player?.seek(Duration(seconds: sec));

    // 외부 음악 종료
    // await audioSession?.setActive(false);
  }

  stop() async {
    // 내부 음악 종료
    await player?.stop();
    // 외부 음악 실행
    // await audioSession?.setActive(true);
  }

  dispose() async {
    // 내부 음악 종료
    await player?.dispose();
    // 외부 음악 실행
    // await audioSession?.setActive(true);
  }

  // 외부 음악 들릴 때 반응 설정
  // _audioSessionConfigure() =>
  //     AudioSession.instance.then((audioSession) async => await audioSession
  //         .configure(const AudioSessionConfiguration(
  //             avAudioSessionCategory: AVAudioSessionCategory.playback,
  //             avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.none,
  //             avAudioSessionMode: AVAudioSessionMode.defaultMode,
  //             avAudioSessionRouteSharingPolicy:
  //                 AVAudioSessionRouteSharingPolicy.defaultPolicy,
  //             avAudioSessionSetActiveOptions:
  //                 AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation,
  //             androidAudioAttributes: AndroidAudioAttributes(
  //               contentType: AndroidAudioContentType.music,
  //               flags: AndroidAudioFlags.none,
  //               usage: AndroidAudioUsage.media,
  //             ),
  //             androidAudioFocusGainType:
  //                 AndroidAudioFocusGainType.gainTransient,
  //             androidWillPauseWhenDucked: true))
  //         .then((_) => audioSession = audioSession));
}
