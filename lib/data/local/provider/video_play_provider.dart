import 'package:flutter/material.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:video_player/video_player.dart';

class VideoPlayProvider with ChangeNotifier {
  final PageController pageController = PageController();
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

  List<int> chats = [
    110,
    282,
    1,
    23,
    437,
  ];

  List<String> profiles = [
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/8bd9357c-ff99-4db8-96c9-486d1aaf942f/66f4fd16-ceb4-4032-a67d-dd588394406e_V1-3-2.png',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/8bd9357c-ff99-4db8-96c9-486d1aaf942f/66f4fd16-ceb4-4032-a67d-dd588394406e_V1-3-2.png',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/8bd9357c-ff99-4db8-96c9-486d1aaf942f/66f4fd16-ceb4-4032-a67d-dd588394406e_V1-3-2.png',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/8bd9357c-ff99-4db8-96c9-486d1aaf942f/66f4fd16-ceb4-4032-a67d-dd588394406e_V1-3-2.png',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/8bd9357c-ff99-4db8-96c9-486d1aaf942f/66f4fd16-ceb4-4032-a67d-dd588394406e_V1-3-2.png',
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

  int currentIndex = 0;
  int pageSize = 10;

  void initializeVideoPlayerFutures() {
    loadVideo();

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

  void addVideos(List<VideoData> videoList) {
    // 새로운 비디오를 기존 비디오 목록에 추가
    debugPrint('비디오 추가');
    videoLinks.addAll(List<String>.generate(
        videoList.length, (index) => videoList[index].videoUrl));
    likes.addAll(List<int>.generate(
        videoList.length, (index) => videoList[index].likeCount));
    chats.addAll(List<int>.generate(
        videoList.length, (index) => videoList[index].commentCount));
    profiles.addAll(List<String>.generate(
        videoList.length, (index) => videoList[index].user.profileImg!));
    nicknames.addAll(List<String>.generate(
        videoList.length, (index) => videoList[index].user.nickname));
    contents.addAll(List<String>.generate(
        videoList.length, (index) => videoList[index].title));
    tags.addAll(List<String>.generate(
        videoList.length, (index) => videoList[index].tag));

    // 새로운 리스트를 생성하여 PageView.builder에서 사용하도록 합니다.
    List<String> updatedVideoLinks = List.from(videoLinks);

    // 비디오 설정을 갱신합니다.
    loadVideo();
    setVideo();

    // PageView.builder에서 사용하는 리스트를 갱신합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      videoPlayerFutures = List<Future<void>>.generate(
        updatedVideoLinks.length,
        (index) => controllers[index].initialize(),
      );
      videoLinks = updatedVideoLinks;
      notifyListeners();
    });
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
