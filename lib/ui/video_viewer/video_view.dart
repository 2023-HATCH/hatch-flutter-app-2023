import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/request/home_videos_request.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/home_provider.dart';
import 'package:pocket_pose/ui/video_viewer/video_user_info_frame.dart';
import 'package:pocket_pose/ui/video_viewer/video_right_frame.dart';
import 'package:pocket_pose/ui/widget/music_spinner_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key, required String screenName})
      : screenName = screenName;

  final String screenName;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late VideoPlayProvider _videoPlayProvider;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    if (_videoPlayProvider.videoList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadVideos();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _videoPlayProvider.setVideo();
      });
    }
  }

  Future<void> _loadVideos() async {
    try {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider
          .getVideos(HomeVideosRequest(
              page: _videoPlayProvider.currentPage,
              size: _videoPlayProvider.PAGESIZE))
          .then((value) {
        final newVideos = homeProvider.response?.videoList;

        if (newVideos != null && newVideos.isNotEmpty) {
          setState(() {
            _videoPlayProvider.initializeVideos(newVideos);
            _videoPlayProvider.currentPage++;
          });
        }
      });
    } catch (e) {
      debugPrint('홈 영상 list 조회 api 호출 실패');
    } finally {}
  }

  Future<void> _loadMoreVideos() async {
    try {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);

      homeProvider
          .getVideos(HomeVideosRequest(
              page: _videoPlayProvider.currentPage,
              size: _videoPlayProvider.PAGESIZE))
          .then((value) {
        final response = homeProvider.response;

        if (response != null && response.videoList.isNotEmpty) {
          setState(() {
            debugPrint('response.isLast: ${response.isLast}');
            if (response.isLast) {
              _videoPlayProvider.isLast = true;

              return;
            }

            _videoPlayProvider.addVideos(response.videoList);
            _videoPlayProvider.currentPage++;
          });
        }
      });
    } catch (e) {
      // Handle error if needed
    } finally {}
  }

  void onPageChanged(int index) {
    setState(() {
      _videoPlayProvider.pauseVideo();

      if (_videoPlayProvider.isLast) {
        if (_videoPlayProvider.videoList.length == index) {
          // 마지막 페이지에 도달했을 때 페이지를 0으로 바로 이동
          pageController.jumpToPage(0);
          _videoPlayProvider.currentIndex = 0;
        } else {
          _videoPlayProvider.currentIndex = index;
        }
      } else {
        _videoPlayProvider.currentIndex = index;
        if (_videoPlayProvider.videoList.length -
                _videoPlayProvider.currentIndex <=
            _videoPlayProvider.PAGESIZE) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadMoreVideos();
          });
        }
      }

      _videoPlayProvider.setVideo();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayProvider.pauseVideo();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: <Widget>[
        PageView.builder(
          controller: pageController = PageController(
            initialPage: _videoPlayProvider.currentIndex,
          ),
          scrollDirection: Axis.vertical,
          allowImplicitScrolling: true,
          itemCount: 200, // itemCount를 변경하도록 수정
          itemBuilder: (context, index) {
            if (index < _videoPlayProvider.videoList.length) {
              // 현재 비디오 인덱스 안에 있는 경우
              return FutureBuilder(
                future: _videoPlayProvider
                    .videoPlayerFutures[_videoPlayProvider.currentIndex],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done ||
                      (snapshot.connectionState == ConnectionState.waiting &&
                          _videoPlayProvider.loading)) {
                    // 비디오가 준비된 경우
                    _videoPlayProvider.loading = true;
                    return buildVideoPlayer(index); // 비디오 플레이어 생성
                  } else {
                    return const MusicSpinner(); // 비디오 로딩 중
                  }
                },
              );
            } else {
              // 더미 공간으로, 무한 스크롤을 위한 추가 공간
              return const MusicSpinner(); // 비디오 로딩 중
            }
          },
          onPageChanged: onPageChanged,
        ),
      ],
    );
  }

  Widget buildVideoPlayer(int index) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            // 비디오 클릭 시 영상 정지/재생
            if (_videoPlayProvider.controllers[index].value.isPlaying) {
              _videoPlayProvider.pauseVideo();
            } else {
              _videoPlayProvider.playVideo();
            }
          },
          child: VideoPlayer(_videoPlayProvider.controllers[index]),
        ),
        VideoRightFrame(index: index),
        VideoUserInfoFrame(index: index),
      ],
    );
  }
}
