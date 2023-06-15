import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  late List<VideoPlayerController> _videoControllers;
  late List<Future<void>> _initializeVideoPlayerFutures;

  List<String> videoLinks = [
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-2.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-4.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-5.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-3.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-1.mp4',
  ];

  int currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController();

    // 모든 비디오 로드
    _videoControllers = List<VideoPlayerController>.generate(
      videoLinks.length,
      (index) => VideoPlayerController.network(videoLinks[index]),
    );

    // 비디오 초기화 완료를 기다리는 Future 리스트
    _initializeVideoPlayerFutures = List<Future<void>>.generate(
      videoLinks.length,
      (index) => _videoControllers[index].initialize(),
    );

    // 비디오 기본 값 설정
    _videoControllers[currentIndex].play(); // 재생되는 상태
    _videoControllers[currentIndex].setLooping(true); // 영상 무한 반복
    _videoControllers[currentIndex].setVolume(1.0); // 볼륨 설정

    super.initState();
  }

  @override
  void dispose() {
    // 자원을 반환하기 위해 VideoPlayerController dispose.
    for (int i = 0; i < videoLinks.length; i++) {
      _videoControllers[i].dispose();
    }
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _videoControllers[currentIndex].pause().then((_) {
        // 다음 비디오로 변경
        currentIndex = index;

        // 다음 비디오 기본 값 설정
        _videoControllers[currentIndex].play();
        _videoControllers[currentIndex].setLooping(true);
        _videoControllers[currentIndex].setVolume(1.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      allowImplicitScrolling: true,
      itemCount: videoLinks.length,
      itemBuilder: (context, index) {
        return FutureBuilder(
            future: _initializeVideoPlayerFutures[currentIndex],
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // 데이터가 수신되었을 때
                return GestureDetector(
                  // 비디오 클릭 시 영상 정지/재생
                  onTap: () {
                    if (_videoControllers[index].value.isPlaying) {
                      _videoControllers[index].pause();
                    } else {
                      // 만약 영상 일시 중지 상태였다면, 재생.
                      _videoControllers[index].play();
                    }
                  },
                  child: VideoPlayer(_videoControllers[index]),
                );
              } else {
                // 만약 VideoPlayerController가 여전히 초기화 중이라면, 로딩 스피너를 보여줌.
                return const Center(child: CircularProgressIndicator());
              }
            });
      },
      onPageChanged: onPageChanged,
    ));
  }
}
