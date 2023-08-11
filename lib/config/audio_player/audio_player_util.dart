import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';

class AudioPlayerUtil {
  CameraController? _controller;
  // late AudioSession audioSession;
  AudioPlayer player = AudioPlayer();

  static final AudioPlayerUtil _instance = AudioPlayerUtil._internal();

  factory AudioPlayerUtil() => _instance;

  AudioPlayerUtil._internal() {
    // _audioSessionConfigure();
  }

  setCameraController(CameraController? cameraController) {
    _controller = cameraController;
  }

  // 노래 종료 후 실행할 함수 설정
  setPlayerCompletion() {
    player.onPlayerCompletion.listen((event) {});
  }

  play(String musicUrl) async {
    // 내부 음악 실행
    await player.play(musicUrl);
    // 외부 음악 종료
    // await audioSession.setActive(false);
  }

  stop() async {
    // 카메라 종료(포포 스테이지 종료)
    if (_controller != null) {
      _controller = null;
      await _controller?.stopImageStream();
      await _controller?.dispose();
    }

    // 내부 음악 종료
    await player.stop();
    // 외부 음악 실행
    // await audioSession.setActive(true);
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
