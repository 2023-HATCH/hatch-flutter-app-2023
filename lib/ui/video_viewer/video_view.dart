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

  late VideoPlayProvider videoPlayProvider;

  int _currentPage = -1;
  final int _pageSize = 2;

  @override
  void initState() {
    super.initState();
    videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.screenName == 'home') {
        _loadMoreVideos(); // 최초에도 비디오 로드
      } else if (widget.screenName == 'my') {
      } else {}
      videoPlayProvider.setVideo();
    });
  }

  Future<void> _loadMoreVideos() async {
    try {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      final nextPage = _currentPage + 1;
      homeProvider
          .getVideos(HomeVideosRequest(page: nextPage, size: _pageSize))
          .then((value) {
        final newVideos = homeProvider.response?.videoList;
        debugPrint('새 비디오들: ${newVideos!.length.toString()}');

        if (newVideos.isNotEmpty) {
          setState(() {
            videoPlayProvider.addVideos(newVideos);
            _currentPage = nextPage;
          });
        }
      });
    } catch (e) {
      // Handle error if needed
    } finally {}
  }

  void onPageChanged(int index) {
    setState(() {
      videoPlayProvider.pauseVideo();
      videoPlayProvider.currentIndex = index;
      if (videoPlayProvider.currentIndex >= _pageSize) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // if (widget.screenName == 'home') {
          //   _loadMoreVideos();
          //   debugPrint('비디오 링크 길이: ${videoPlayProvider.videoLinks.length}');
          // } else if (widget.screenName == 'my') {
          // } else {}
          videoPlayProvider.setVideo();
        });
      }
      videoPlayProvider.setVideo();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        PageView.builder(
          controller: videoPlayProvider.pageController,
          scrollDirection: Axis.vertical,
          allowImplicitScrolling: true,
          itemCount: 200, // itemCount를 변경하도록 수정
          itemBuilder: (context, index) {
            if (index < videoPlayProvider.videoLinks.length) {
              // 현재 비디오 인덱스 안에 있는 경우
              return FutureBuilder(
                future: videoPlayProvider.videoPlayerFutures[index],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done ||
                      (snapshot.connectionState == ConnectionState.waiting &&
                          videoPlayProvider.loading)) {
                    // 비디오가 준비된 경우
                    videoPlayProvider.loading = true;
                    return buildVideoPlayer(index); // 비디오 플레이어 생성
                  } else {
                    return const MusicSpinner(); // 비디오 로딩 중
                  }
                },
              );
            } else {
              // 더미 공간으로, 무한 스크롤을 위한 추가 공간
              return Container();
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
            if (videoPlayProvider.controllers[index].value.isPlaying) {
              videoPlayProvider.pauseVideo();
            } else {
              videoPlayProvider.playVideo();
            }
          },
          child: VideoPlayer(videoPlayProvider.controllers[index]),
        ),
        VideoRightFrame(index: index),
        VideoUserInfoFrame(index: index),
      ],
    );
  }
}
