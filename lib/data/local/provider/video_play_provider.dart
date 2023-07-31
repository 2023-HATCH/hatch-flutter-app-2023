import 'package:flutter/material.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:video_player/video_player.dart';

class VideoPlayProvider with ChangeNotifier {
  late List<VideoPlayerController> controllers;
  late List<Future<void>> videoPlayerFutures;

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

  void initializeVideos(List<VideoData> newVideoList) {
    videoList.addAll(newVideoList);

    // VideoPlayerController 생성
    controllers = List<VideoPlayerController>.generate(
      PAGESIZE,
      (index) => VideoPlayerController.network(videoList[index].videoUrl),
    );

    // VideoPlayerController 생성
    videoPlayerFutures = List<Future<void>>.generate(
      PAGESIZE,
      (index) => controllers[index].initialize(),
    );

    // setVideo를 controllers가 초기화된 후에 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setVideo();
      notifyListeners();
    });
  }

  void addVideos(List<VideoData> newVideoList) {
    videoList.addAll(newVideoList);

    loadVideo();
    notifyListeners();
  }

  void loadVideo() {
    // VideoPlayerController 추가
    int num = videoList.length - PAGESIZE;
    controllers.addAll(List<VideoPlayerController>.generate(
      PAGESIZE,
      (index) => VideoPlayerController.network(videoList[num + index].videoUrl),
    ));

    // VideoPlayerController 추가
    videoPlayerFutures.addAll(List<Future<void>>.generate(
      PAGESIZE,
      (index) => controllers[num + index].initialize(),
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void setVideo() {
    // Check if currentIndex is within bounds of controllers list
    if (currentIndex >= 0 && currentIndex < controllers.length) {
      // 비디오 기본 값 설정
      playVideo(); // 재생되는 상태
      controllers[currentIndex].setLooping(true); // 영상 무한 반복
      controllers[currentIndex].setVolume(1.0); // 볼륨 설정

      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  void pauseVideo() {
    if (currentIndex >= 0 && currentIndex < controllers.length) {
      controllers[currentIndex].pause();

      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  void playVideo() {
    if (currentIndex >= 0 && currentIndex < controllers.length) {
      controllers[currentIndex].play();

      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  // dispose 메서드 추가 (비디오 컨트롤러 정리)
  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
