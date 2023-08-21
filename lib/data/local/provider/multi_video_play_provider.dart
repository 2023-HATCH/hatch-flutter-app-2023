import 'package:flutter/material.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../remote/provider/video_provider.dart';

class MultiVideoPlayProvider with ChangeNotifier {
  final int pageSize = 3;

  // 홈: 0, 업로드: 1, 좋아요: 2, 검색 3
  late List<List<VideoPlayerController>> videoControllers = [[], [], [], []];
  late List<List<Future<void>>> videoFutures = [[], [], []];
  late List<PageController> pageControllers = [
    PageController(initialPage: currentIndexs[0]),
    PageController(initialPage: currentIndexs[1]),
    PageController(initialPage: currentIndexs[2]),
    PageController(initialPage: currentIndexs[3]),
  ];

  List<List<VideoData>> videos = [[], [], [], []];
  List<bool> loadings = [false, false, false, false];
  List<bool> isLasts = [false, false, false, false];
  List<int> currentIndexs = [0, 0, 0, 0];
  List<int> currentPages = [0, 0, 0, 0];

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

  // 조회수
  final double endVideoViewAmount = 0.2; //20퍼센트 이상 시청했을 경우 조회수 증가
  late BuildContext mainContext;
  List<bool> isVideoViewEnding = List.generate(200, (index) => false);
  Duration _videoPosition = Duration.zero;
  Duration _videoDuration = Duration.zero;
  List<bool> getAddView = List.generate(200, (index) => false);
  List<bool> videoEnd = List.generate(200, (index) => false);

  void addVideos(int screenNum, List<VideoData> newVideoList) {
    videos[screenNum].addAll(newVideoList);

    // Add VideoPlayer Controller
    for (final video in newVideoList) {
      debugPrint('페이지: 비디오 로딩중');
      videoControllers[screenNum]
          .add(VideoPlayerController.network(video.videoUrl));
      // videoFutures[screenNum] = videoFutures[screenNum]
      //     .then((_) => videoControllers[screenNum].last.initialize())
      //     .then((value) {
      //   videoControllers[screenNum][currentIndexs[screenNum]].setLooping(true);
      //   videoControllers[screenNum][currentIndexs[screenNum]].setVolume(1.0);

      //   playVideo();
      //   WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
      //   debugPrint('페이지: 비디오 로딩 하나끝');
      // });

      videoFutures[screenNum]
          .add(videoControllers[screenNum].last.initialize().then((value) {
        videoControllers[screenNum][currentIndexs[screenNum]]
            .setLooping(true); // 영상 무한 반복
        videoControllers[screenNum][currentIndexs[screenNum]]
            .setVolume(1.0); // 볼륨 설정

        playVideo();
        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
        debugPrint('페이지: 비디오 로딩 하나끝');
      }));
    }
  }

  // 0 대신screenNum으로 변경!!!!!!
  void playVideo() {
    if (currentIndexs[0] >= 0 &&
        currentIndexs[0] < videoControllers[0].length) {
      videoControllers[0][currentIndexs[0]].addListener(() {
        _videoPosition = videoControllers[0][currentIndexs[0]].value.position;
        _videoDuration = videoControllers[0][currentIndexs[0]].value.duration;

        final isMoreThen20Per = _videoPosition >=
            _videoDuration * endVideoViewAmount; // 20퍼 이상 재생 됐을 때 True
        final isMoreThen95Per = _videoPosition >=
            _videoDuration -
                const Duration(milliseconds: 100); // 대략 끝까지 재생 됐을 때 True

        if (isMoreThen20Per) {
          if (!isMoreThen95Per) {
            if (!getAddView[currentIndexs[0]]) {
              getAddView[currentIndexs[0]] = true;

              debugPrint('❤️  ${currentIndexs[0]}번 영상 조회수 증가 요청');
              final videoProvider =
                  Provider.of<VideoProvider>(mainContext, listen: false);
              videoProvider.getView(videos[0][currentIndexs[0]].uuid);
            }
          } else {
            if (getAddView[currentIndexs[0]]) {
              getAddView[currentIndexs[0]] = false;
            }
            videoEnd[currentIndexs[0]] = !videoEnd[currentIndexs[0]];
          }
        } else {
          getAddView[currentIndexs[0]] = false;
          videoEnd[currentIndexs[0]] = false;
        }
      });

      if (!videoControllers[0][currentIndexs[0]].value.isPlaying) {
        videoControllers[0][currentIndexs[0]].setLooping(true); // 영상 무한 반복
        videoControllers[0][currentIndexs[0]].setVolume(1.0); // 볼륨 설정

        videoControllers[0][currentIndexs[0]].play();

        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
      }
    }
  }

  void pauseVideo() {
    if (currentIndexs[0] >= 0 &&
        currentIndexs[0] < videoControllers[0].length) {
      videoControllers[0][currentIndexs[0]].pause();

      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  void resetVideoPlayer() {
    pauseVideo();

    for (final controller in videoControllers[0]) {
      controller.dispose();
    }
    videoControllers[0] = [];
    videoFutures[0] = [];
    loadings[0] = false;
    videos[0] = [];
    currentIndexs[0] = 0;
    currentPages[0] = 0;
    isLasts[0] = false;

    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  @override
  void dispose() {
    super.dispose();

    for (final controller in videoControllers[0]) {
      controller.dispose();
    }

    pageControllers[0].dispose();
  }
}
