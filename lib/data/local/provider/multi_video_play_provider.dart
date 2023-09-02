import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:provider/provider.dart';

import '../../remote/provider/video_provider.dart';

class MultiVideoPlayProvider with ChangeNotifier {
  final int pageSize = 3;

  // 홈: 0, 업로드: 1, 좋아요: 2, 검색: 3, 태그 검색: 4
  late List<List<CachedVideoPlayerController>> videoControllers = [
    [],
    [],
    [],
    [],
    []
  ];
  late List<List<Future<void>>> videoFutures = [[], [], [], [], []];
  late List<PageController> pageControllers =
      List.generate(5, (_) => PageController());

  List<List<VideoData>> videos = [[], [], [], [], []];
  List<bool> loadings = [false, false, false, false, false];
  List<bool> isLasts = [false, false, false, false, false];
  List<int> currentIndexs = [0, 0, 0, 0, 0];
  List<int> currentPages = [0, 0, 0, 0, 0];

  bool isOpenProfile = false;

  // 조회수
  final double endVideoViewAmount = 0.2; //20퍼센트 이상 시청했을 경우 조회수 증가
  late BuildContext mainContext;
  List<bool> isVideoViewEnding = List.generate(200, (index) => false);
  Duration _videoPosition = Duration.zero;
  Duration _videoDuration = Duration.zero;
  List<bool> getAddView = List.generate(200, (index) => false);
  List<bool> videoEnd = List.generate(200, (index) => false);

  void addVideos(int screenNum, List<VideoData> newVideoList) {
    debugPrint('비디오 스크린 번호: $screenNum');
    videos[screenNum].addAll(newVideoList);

    // Add VideoPlayer Controller
    for (final video in newVideoList) {
      debugPrint('페이지: 비디오 로딩중');
      videoControllers[screenNum]
          .add(CachedVideoPlayerController.network(video.videoUrl));

      videoFutures[screenNum]
          .add(videoControllers[screenNum].last.initialize().then((value) {
        videoControllers[screenNum][currentIndexs[screenNum]]
            .setLooping(true); // 영상 무한 반복
        videoControllers[screenNum][currentIndexs[screenNum]]
            .setVolume(1.0); // 볼륨 설정

        if (screenNum == 0) {
          playVideo(screenNum);
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
        debugPrint('페이지: 비디오 로딩 하나끝');
      }));
    }
  }

  void playVideo(int screenNum) {
    if (currentIndexs[screenNum] >= 0 &&
        currentIndexs[screenNum] < videoControllers[screenNum].length) {
      videoControllers[screenNum][currentIndexs[screenNum]].addListener(() {
        _videoPosition = videoControllers[screenNum][currentIndexs[screenNum]]
            .value
            .position;
        _videoDuration = videoControllers[screenNum][currentIndexs[screenNum]]
            .value
            .duration;

        final isMoreThen20Per = _videoPosition >=
            _videoDuration * endVideoViewAmount; // 20퍼 이상 재생 됐을 때 True
        final isMoreThen95Per = _videoPosition >=
            _videoDuration -
                const Duration(milliseconds: 100); // 대략 끝까지 재생 됐을 때 True

        if (isMoreThen20Per) {
          if (!isMoreThen95Per) {
            if (!getAddView[currentIndexs[screenNum]]) {
              getAddView[currentIndexs[screenNum]] = true;

              debugPrint('❤️  ${currentIndexs[screenNum]}번 영상 조회수 증가 요청');
              final videoProvider =
                  Provider.of<VideoProvider>(mainContext, listen: false);
              videoProvider
                  .getView(videos[screenNum][currentIndexs[screenNum]].uuid);
            }
          } else {
            if (getAddView[currentIndexs[screenNum]]) {
              getAddView[currentIndexs[screenNum]] = false;
            }
            videoEnd[currentIndexs[screenNum]] =
                !videoEnd[currentIndexs[screenNum]];
          }
        } else {
          getAddView[currentIndexs[screenNum]] = false;
          videoEnd[currentIndexs[screenNum]] = false;
        }
      });

      if (!videoControllers[screenNum][currentIndexs[screenNum]]
          .value
          .isPlaying) {
        videoControllers[screenNum][currentIndexs[screenNum]]
            .setLooping(true); // 영상 무한 반복
        videoControllers[screenNum][currentIndexs[screenNum]]
            .setVolume(1.0); // 볼륨 설정

        videoControllers[screenNum][currentIndexs[screenNum]].play();

        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
      }
    }
  }

  void pauseVideo(int screenNum) {
    if (currentIndexs[screenNum] >= 0 &&
        currentIndexs[screenNum] < videoControllers[screenNum].length) {
      videoControllers[screenNum][currentIndexs[screenNum]].pause();

      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  void resetVideoPlayer(int screenNum) {
    pauseVideo(screenNum);

    for (final controller in videoControllers[screenNum]) {
      controller.dispose();
    }
    videoControllers[screenNum] = [];
    videoFutures[screenNum] = [];
    loadings[screenNum] = false;
    videos[screenNum] = [];
    currentIndexs[screenNum] = 0;
    currentPages[screenNum] = 0;
    isLasts[screenNum] = false;

    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  @override
  void dispose() {
    super.dispose();

    for (final controllers in videoControllers) {
      for (final controller in controllers) {
        controller.dispose();
      }
    }

    for (final pageController in pageControllers) {
      pageController.dispose();
    }
  }
}
