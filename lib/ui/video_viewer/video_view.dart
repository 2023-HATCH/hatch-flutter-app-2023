import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/request/videos_request.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/video_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_videoPlayProvider.videoList.isEmpty) {
        _loadMoreVideos();
      } else {
        _videoPlayProvider.playVideo();
      }
    });
  }

  Future<void> _loadMoreVideos() async {
    try {
      final videoProvider = Provider.of<VideoProvider>(context, listen: false);

      videoProvider
          .getVideos(VideosRequest(
              page: _videoPlayProvider.currentPage++,
              size: _videoPlayProvider.PAGESIZE))
          .then((value) {
        final response = videoProvider.response;

        if (response != null) {
          setState(() {
            if (response.isLast) {
              _videoPlayProvider.isLast = true;
              return;
            }

            if (response.videoList.isNotEmpty) {
              _videoPlayProvider.addVideos(response.videoList);
            }
          });
        }
      });
    } catch (e) {
      // Handle error if needed
      debugPrint('moon video_view.dart error: $e');
    } finally {}
  }

  void onPageChanged(int index) {
    setState(() {
      _videoPlayProvider.pauseVideo();

      if (!_videoPlayProvider.isLast) {
        _videoPlayProvider.currentIndex = index;

        if (_videoPlayProvider.videoList.length -
                _videoPlayProvider.currentIndex <=
            _videoPlayProvider.PAGESIZE - 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadMoreVideos();
          });
        }
      } else {
        if (_videoPlayProvider.videoList.length == index) {
          // 마지막 페이지에 도달했을 때 페이지를 0으로 바로 이동
          _videoPlayProvider.pageController.jumpToPage(0);
          _videoPlayProvider.currentIndex = 0;
        } else {
          _videoPlayProvider.currentIndex = index;
        }
      }

      _videoPlayProvider.playVideo();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayProvider.pauseVideo();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _videoPlayProvider.resetVideoPlayer();
          _loadMoreVideos();
        });
      },
      color: AppColor.purpleColor,
      child: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _videoPlayProvider.pageController =
                PageController(initialPage: _videoPlayProvider.currentIndex),
            scrollDirection: Axis.vertical,
            allowImplicitScrolling: true,
            itemCount: 200,
            itemBuilder: (context, index) {
              if (_videoPlayProvider.videoList.isEmpty) {
                _loadMoreVideos();
                _videoPlayProvider.loading = false;
                return const MusicSpinner(); // 비디오 로딩 중
              } else {
                if (index < _videoPlayProvider.videoList.length) {
                  // 현재 비디오 인덱스 안에 있는 경우
                  return FutureBuilder(
                    future: _videoPlayProvider
                        .videoPlayerFutures[_videoPlayProvider.currentIndex],
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done ||
                          (snapshot.connectionState ==
                                  ConnectionState.waiting &&
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
                  _videoPlayProvider.loading = false;
                  if (_videoPlayProvider.currentIndex <= 0) {
                    return const MusicSpinner(); // 비디오 로딩 중
                  } else {
                    return Container(color: Colors.black);
                  }
                }
              }
            },
            onPageChanged: onPageChanged,
          ),
        ],
      ),
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
