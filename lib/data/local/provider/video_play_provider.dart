import 'package:flutter/material.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:video_player/video_player.dart';

class VideoPlayProvider with ChangeNotifier {
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
    int num = videoList.length;
    videoList.addAll(newVideoList);

    // Add VideoPlayer Controller
    controllers.addAll(List<VideoPlayerController>.generate(
      PAGESIZE,
      (index) => VideoPlayerController.network(videoList[num + index].videoUrl),
    ));

    // Initialize VideoPlayer Controller
    videoPlayerFutures.addAll(List<Future<void>>.generate(
        PAGESIZE, (index) => controllers[num + index].initialize()));

    playVideo();
    currentPage++;

    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void playVideo() {
    if (currentIndex >= 0 && currentIndex < controllers.length) {
      controllers[currentIndex].setLooping(true); // 영상 무한 반복
      controllers[currentIndex].setVolume(1.0); // 볼륨 설정

      controllers[currentIndex].play();

      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  void pauseVideo() {
    if (currentIndex >= 0 && currentIndex < controllers.length) {
      controllers[currentIndex].pause();

      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  void resetVideoPlayer() {
    dispose();

    controllers = [];
    videoPlayerFutures = [];
    videoList = [];
    currentIndex = 0;
    currentPage = 0;
    isLast = false;

    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    pageController.dispose();

    super.dispose();
  }
}
