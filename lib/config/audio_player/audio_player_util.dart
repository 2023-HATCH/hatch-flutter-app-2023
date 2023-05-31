import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerUtil {
  late AudioSession audioSession;
  AudioPlayer player = AudioPlayer();

  static final AudioPlayerUtil _instance = AudioPlayerUtil._internal();

  factory AudioPlayerUtil() => _instance;

  var _musicUrl = "https://ccrma.stanford.edu/~jos/mp3/harpsi-cs.mp3";

  AudioPlayerUtil._internal() {
    _audioSessionConfigure();
    player.onPlayerCompletion.listen((event) {
      print("mmm:노래 끝");
    });
  }

  setMusicUrl(String url) async {
    await player.setUrl(url);
    _musicUrl = url;
  }

  play() async {
    // 내부 음악 실행
    await player.play(_musicUrl);
    // 외부 음악 종료
    await audioSession.setActive(false);
  }

  stop() async {
    // 내부 음악 종료
    await player.stop();
    // 외부 음악 실행
    await audioSession.setActive(true);
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
