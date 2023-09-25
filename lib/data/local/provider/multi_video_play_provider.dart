import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:provider/provider.dart';
import '../../remote/provider/video_provider.dart';

class MultiVideoPlayProvider with ChangeNotifier {
  final int pageSize = 3;

  // 홈: 0, 업로드: 1, 좋아요: 2, 검색: 3, 태그 검색: 4, 공유: 5
  late List<List<CachedVideoPlayerController>> videoControllers =
      List.generate(6, (_) => []);
  late List<List<Future<void>>> videoFutures = List.generate(6, (_) => []);
  late List<PageController> pageControllers =
      List.generate(6, (_) => PageController());

  List<List<VideoData>> videos = List.generate(6, (_) => []);
  List<bool> loadings = List.generate(6, (_) => false);
  List<bool> isLasts = List.generate(6, (_) => false);
  List<int> currentIndexs = List.generate(6, (_) => 0);
  List<int> currentPages = List.generate(6, (_) => 0);

  bool isOpenProfile = false;

  // 조회수
  final double endVideoViewAmount = 0.2; //20퍼센트 이상 시청했을 경우 조회수 증가
  late BuildContext mainContext;
  List<bool> isVideoViewEnding = List.generate(200, (index) => false);
  Duration _videoPosition = Duration.zero;
  Duration _videoDuration = Duration.zero;
  List<bool> getAddView = List.generate(200, (index) => false);
  List<bool> videoEnd = List.generate(200, (index) => false);

  void addVideo(int screenNum, VideoData newVideo) {
    // Add Video
    videos[screenNum].add(newVideo);

    // Add VideoPlayer Controller
    addVideoController(screenNum, newVideo);
  }

  void addVideos(int screenNum, List<VideoData> newVideoList) {
    // Add Video List
    videos[screenNum].addAll(newVideoList);

    // Add VideoPlayer Controllers
    for (final video in newVideoList) {
      addVideoController(screenNum, video);
    }
  }

  void addVideoController(int screenNum, VideoData newVideo) {
    final controller = videoControllers[screenNum];
    final future = videoFutures[screenNum];
    final index = currentIndexs[screenNum];

    controller.add(CachedVideoPlayerController.network(newVideo.videoUrl));

    future.add(controller.last.initialize().then((value) {
      controller[index].setLooping(true); // 영상 무한 반복
      controller[index].setVolume(1.0); // 볼륨 설정

      if (screenNum == 0) {
        playVideo(screenNum);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }));
  }

  void playVideo(int screenNum) {
    final controller = videoControllers[screenNum];
    final index = currentIndexs[screenNum];

    if (index >= 0 && index < controller.length) {
      addView(screenNum, controller, index);

      if (!controller[index].value.isPlaying) {
        controller[index].setLooping(true);
        controller[index].setVolume(1.0);

        controller[index].play();

        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
      }
    }
  }

  void addView(
      int screenNum, List<CachedVideoPlayerController> controller, int index) {
    controller[index].addListener(() {
      _videoPosition = controller[index].value.position;
      _videoDuration = controller[index].value.duration;

      // 20퍼 이상 재생 됐을 때 True
      final isMoreThen20Per =
          _videoPosition >= _videoDuration * endVideoViewAmount;
      // 대략 끝까지 재생 됐을 때 True
      final isMoreThen95Per =
          _videoPosition >= _videoDuration - const Duration(milliseconds: 100);

      if (isMoreThen20Per) {
        if (!isMoreThen95Per) {
          if (!getAddView[index]) {
            getAddView[index] = true;

            // 조회수 증가 요청
            final videoProvider =
                Provider.of<VideoProvider>(mainContext, listen: false);
            videoProvider.getView(videos[screenNum][index].uuid);
          }
        } else {
          if (getAddView[index]) {
            getAddView[index] = false;
          }
          videoEnd[index] = !videoEnd[index];
        }
      } else {
        getAddView[index] = false;
        videoEnd[index] = false;
      }
    });
  }

  void pauseVideo(int screenNum) {
    final controller = videoControllers[screenNum];
    final index = currentIndexs[screenNum];

    if (index >= 0 && index < controller.length) {
      controller[index].pause();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
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
