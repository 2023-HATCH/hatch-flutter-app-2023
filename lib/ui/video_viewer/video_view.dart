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
      backgroundColor: const Color.fromARGB(60, 234, 234, 234),
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
                        return VideoPlayerWidget(index: index); // 비디오 플레이어 생성
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
}

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key, required int index}) : index = index;

  final int index;

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool isIconVisible = false;
  late VideoPlayProvider _videoPlayProvider;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 0), // 아이콘이 나타날 때의 애니메이션 속도
      reverseDuration:
          const Duration(milliseconds: 800), // 아이콘이 사라질 때의 애니메이션 속도
      value: 0.0, // 시작 값 설정
    );
  }

  void _toggleIconVisibility(bool newValue) {
    setState(() {
      isIconVisible = newValue;
      if (isIconVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse().then((_) {
          setState(() {
            isIconVisible = false;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            final controller = _videoPlayProvider.controllers[widget.index];
            if (controller.value.isPlaying) {
              _videoPlayProvider.pauseVideo();
              isPlaying = false;
              _toggleIconVisibility(true);
              Future.delayed(const Duration(milliseconds: 800), () {
                _toggleIconVisibility(false);
              });
            } else {
              _videoPlayProvider.playVideo();
              isPlaying = true;
              _toggleIconVisibility(true);
              Future.delayed(const Duration(milliseconds: 800), () {
                _toggleIconVisibility(false);
              });
            }
          },
          child: VideoPlayer(_videoPlayProvider.controllers[widget.index]),
        ),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _animationController.value,
                child: Center(
                  child: Icon(
                    isPlaying
                        ? Icons.play_circle_filled_rounded
                        : Icons.pause_circle_filled_rounded,
                    size: 60,
                    color: const Color.fromARGB(60, 234, 234, 234),
                  ),
                ),
              );
            },
          ),
        ),
        VideoRightFrame(index: widget.index),
        VideoUserInfoFrame(index: widget.index),
      ],
    );
  }
}
