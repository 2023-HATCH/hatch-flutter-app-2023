import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart' as ja;

class AudioPlayerUtil {
  late AudioSession audioSession;
  ja.AudioPlayer player = ja.AudioPlayer(
      handleInterruptions: false,
      androidApplyAudioAttributes: false,
      handleAudioSessionActivation: false);

  static final AudioPlayerUtil _instance = AudioPlayerUtil._internal();

  factory AudioPlayerUtil() => _instance;

  AudioPlayerUtil._internal() {
    _audioSessionConfigure();
  }

  getPlaybackRn(String url) async {
    await player.setUrl(url);
    _handleInterruptions();
  }

  play() async {
    // 내부 음악 실행
    await player.play();
    // 외부 음악 종료
    await audioSession.setActive(true);
  }

  stop() async {
    // 내부 음악 종료
    await player.stop();
    // 외부 음악 실행
    await audioSession.setActive(false);
  }

  _handleInterruptions() async {
    player.playing ? await player.stop() : await player.play();
    await audioSession.setActive(player.playing);
  }

  // 외부 음악 들릴 때 반응 설정
  _audioSessionConfigure() =>
      AudioSession.instance.then((audioSession) async => await audioSession
          .configure(const AudioSessionConfiguration(
              avAudioSessionCategory: AVAudioSessionCategory.playback,
              avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.none,
              avAudioSessionMode: AVAudioSessionMode.defaultMode,
              avAudioSessionRouteSharingPolicy:
                  AVAudioSessionRouteSharingPolicy.defaultPolicy,
              avAudioSessionSetActiveOptions:
                  AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation,
              androidAudioAttributes: AndroidAudioAttributes(
                contentType: AndroidAudioContentType.music,
                flags: AndroidAudioFlags.none,
                usage: AndroidAudioUsage.media,
              ),
              androidAudioFocusGainType:
                  AndroidAudioFocusGainType.gainTransient,
              androidWillPauseWhenDucked: true))
          .then((_) => audioSession = audioSession));
}
