import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerUtil {
  AudioSession? audioSession;
  AudioPlayer player = AudioPlayer();

  static final AudioPlayerUtil _instance = AudioPlayerUtil._internal();

  factory AudioPlayerUtil() {
    return _instance;
  }

  AudioPlayerUtil._internal() {
    _audioSessionConfigure();
  }

  // 노래 종료 후 실행할 함수 설정
  setPlayerCompletion(Function setIsSkeletonDetectStart) {
    player.onPlayerCompletion.listen((event) {
      // 스켈레톤 추출 종료
      setIsSkeletonDetectStart(false);
    });
  }

  play(String musicUrl, Function setIsSkeletonDetectStart) async {
    // 내부 음악 실행
    await player.play(musicUrl);
    // 스켈레톤 추출 시작
    setIsSkeletonDetectStart(true);
    // 외부 음악 종료
    await audioSession?.setActive(false);
  }

  stop() async {
    // 내부 음악 종료
    await player.stop();
    // 외부 음악 실행
    await audioSession?.setActive(true);
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
