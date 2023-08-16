import 'package:flutter/material.dart';
import 'package:pocket_pose/domain/entity/video_data.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../remote/provider/video_provider.dart';

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

  final double endVideoViewAmount = 0.2; //20퍼센트 이상 시청했을 경우 조회수 증가
  late BuildContext mainContext;
  List<bool> isVideoViewEnding = List.generate(200, (index) => false);
  Duration _videoPosition = Duration.zero;
  Duration _videoDuration = Duration.zero;
  List<bool> getAddView = List.generate(200, (index) => false);
  List<bool> videoEnd = List.generate(200, (index) => false);

  void addVideos(List<VideoData> newVideoList) {
    videoList.addAll(newVideoList);

    // Add VideoPlayer Controller
    for (final video in newVideoList) {
      debugPrint('페이지: 비디오 로딩중');
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
      controllers[currentIndex].addListener(() {
        _videoPosition = controllers[currentIndex].value.position;
        _videoDuration = controllers[currentIndex].value.duration;

        final isMoreThen20Per = _videoPosition >=
            _videoDuration * endVideoViewAmount; // 20퍼 이상 재생 됐을 때 True
        final isMoreThen95Per = _videoPosition >=
            _videoDuration -
                const Duration(milliseconds: 100); // 대략 끝까지 재생 됐을 때 True

        if (isMoreThen20Per) {
          if (!isMoreThen95Per) {
            if (!getAddView[currentIndex]) {
              getAddView[currentIndex] = true;

              debugPrint('❤️  $currentIndex번 영상 조회수 증가 요청');
              final videoProvider =
                  Provider.of<VideoProvider>(mainContext, listen: false);
              videoProvider.getView(videoList[currentIndex].uuid);
            }
          } else {
            if (getAddView[currentIndex]) {
              getAddView[currentIndex] = false;
            }
            videoEnd[currentIndex] = !videoEnd[currentIndex];
          }
        } else {
          getAddView[currentIndex] = false;
          videoEnd[currentIndex] = false;
        }
      });

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

    for (final controller in controllers) {
      controller.dispose();
    }
    controllers = [];
    videoPlayerFutures = [];
    loading = false;
    videoList = [];
    currentIndex = 0;
    currentPage = 0;
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
