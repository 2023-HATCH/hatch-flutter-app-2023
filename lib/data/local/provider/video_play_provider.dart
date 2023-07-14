import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayProvider with ChangeNotifier {
  late PageController pageController;
  late List<VideoPlayerController> controllers;
  late List<Future<void>> videoPlayerFutures;

  late bool loading = false;

  List<String> videoLinks = [
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-2.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-4.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-5.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-3.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-1.mp4',
  ];

  List<int> likes = [
    60,
    100,
    92,
    94,
    28,
  ];

  List<String> chats = [
    '110',
    '282',
    '1.2천',
    '230',
    '437',
  ];

  List<String> profiles = [
    'assets/images/home_profile_1.jpg',
    'assets/images/home_profile_2.jpg',
    'assets/images/home_profile_3.jpg',
    'assets/images/home_profile_4.jpg',
    'assets/images/home_profile_5.jpg',
  ];

  List<String> nicknames = [
    '@okoi2202',
    '@ONEUS',
    '@joyseoworld',
    '@yunamong_',
    '@hyezz',
  ];

  List<String> contents = [
    '나이트댄서 춤 댄스챌린지 🌸🤍 | 가사 발음 포함 버전',
    '늦었지만 토카토카 댄스!! (난 추고 본적 없음) #원어스 #ONEUS #서호',
    '띵띵땅땅 이 노래 가사가 이런 뜻이었어...',
    '요즘 난리난 챌린지 #아디아디챌린지 #아디아디아디 #dance #dancevideo #tiktok #reels #chellenge #fyp #dancechallenge #korea',
    '최애의 완소 퍼펙트 반장❤️ #최애의아이',
  ];

  int currentIndex = 0;

  void initializeVideoPlayerFutures() {
    loadVideo();
    pageController = PageController();

    videoPlayerFutures = List<Future<void>>.generate(
      videoLinks.length,
      (index) => controllers[index].initialize(),
    );
    setVideo();

    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void loadVideo() {
    // 모든 비디오 로드
    controllers = List<VideoPlayerController>.generate(
      videoLinks.length,
      (index) => VideoPlayerController.network(videoLinks[index]),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void setVideo() {
    // 비디오 기본 값 설정
    playVideo(); // 재생되는 상태
    controllers[currentIndex].setLooping(true); // 영상 무한 반복
    controllers[currentIndex].setVolume(1.0); // 볼륨 설정

    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void pauseVideo() {
    controllers[currentIndex].pause();

    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void playVideo() {
    controllers[currentIndex].play();

    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }
}
