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
  late Future<void> _initializeVideoPlayerFuture;

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

    // // 모든 비디오 로드
    // for (int i = 0; i < videoLinks.length; i++) {
    //   _videoControllers[i] = VideoPlayerController.network(videoLinks[i]);
    // }

    // // 첫번째 비디오로 초기화
    // _initializeVideoPlayerFuture = _videoControllers[currentIndex].initialize();

    // 모든 비디오 로드
    _videoControllers = List<VideoPlayerController>.generate(
      videoLinks.length,
      (index) => VideoPlayerController.network(videoLinks[index]),
    );

    // 비디오 초기화 완료를 기다리는 Future 리스트
    _initializeVideoPlayerFuture = _videoControllers[currentIndex].initialize();

    _videoControllers[currentIndex].play();
    _videoControllers[currentIndex].setLooping(true);
    _videoControllers[currentIndex].setVolume(1.0);

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
        currentIndex = index;

        // 다음 비디오로 초기화
        _initializeVideoPlayerFuture =
            _videoControllers[currentIndex].initialize();

        _videoControllers[currentIndex].play();
        _videoControllers[currentIndex].setLooping(true);
        _videoControllers[currentIndex].setVolume(1.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          // ConnectionState : 비동기 계산에 대한 연결 상태
          if (snapshot.connectionState == ConnectionState.done) {
            // VideoPlayerController 초기화 끝나면, 제공된 데이터 사용하여 VideoPlayer 종횡비 제한.
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              allowImplicitScrolling: true,
              itemCount: videoLinks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
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
              },
              onPageChanged: onPageChanged,
            );
          } else {
            // 만약 VideoPlayerController가 여전히 초기화 중이라면, 로딩 스피너를 보여줌.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
