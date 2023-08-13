import 'package:flutter/material.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:video_player/video_player.dart';

class MultiVideoPlayProvider with ChangeNotifier {
  late List<VideoPlayerController> controllers = [];
  late List<Future<void>> videoPlayerFutures = [];
  late PageController pageController;

  late bool loading = false;
  List<VideoData> videoList = [];

  int currentIndex = 0;
  int currentPage = 0;

  final int PAGESIZE = 3;

  bool isLast = false;

  List<String> tags = [
    '원어스',
    '최애의아이',
    'dancechallenge',
    'K-pop',
    '나이트댄서',
    '띵띵땅땅',
    '완소 퍼펙트 반장',
    '토카토카',
  ];

  void addVideos(List<VideoData> newVideoList) {
    videoList.addAll(newVideoList);

    // Add VideoPlayer Controller
    for (final video in newVideoList) {
      controllers.add(VideoPlayerController.network(video.videoUrl));
      videoPlayerFutures.add(controllers.last.initialize().then((value) {
        controllers[currentIndex].setLooping(true); // 영상 무한 반복
        controllers[currentIndex].setVolume(1.0); // 볼륨 설정

        playVideo();
        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
        debugPrint('페이지: 비디오 로딩 하나끝');
      }));
    }
  }

  void playVideo() {
    if (currentIndex >= 0 && currentIndex < controllers.length) {
      if (!controllers[currentIndex].value.isPlaying) {
        controllers[currentIndex].setLooping(true); // 영상 무한 반복
        controllers[currentIndex].setVolume(1.0); // 볼륨 설정

        controllers[currentIndex].play();

        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
      }
    }
  }

  void pauseVideo() {
    if (currentIndex >= 0 && currentIndex < controllers.length) {
      controllers[currentIndex].pause();

      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  void resetVideoPlayer() {
    pauseVideo();
    controllers = [];
    videoPlayerFutures = [];
    videoList = [];
    currentIndex = 0;
    currentPage = -1;
    isLast = false;

    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  @override
  void dispose() {
    super.dispose();

    for (final controller in controllers) {
      controller.dispose();
    }

    pageController.dispose();
  }
}
