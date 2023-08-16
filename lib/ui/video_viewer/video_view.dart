import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/request/videos_request.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
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

  late MultiVideoPlayProvider _multiVideoPlayProvider;

  @override
  void initState() {
    super.initState();
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_multiVideoPlayProvider.videoList.isNotEmpty) {
        _multiVideoPlayProvider.playVideo();
      }
    });
  }

  Future<void> _loadMoreVideos() async {
    try {
      final videoProvider = Provider.of<VideoProvider>(context, listen: false);
      debugPrint(
          '현재 페이지: _multiVideoPlayProvider.currentPage ${_multiVideoPlayProvider.currentPage}');
      videoProvider
          .getVideos(VideosRequest(
              page: _multiVideoPlayProvider.currentPage,
              size: _multiVideoPlayProvider.PAGESIZE))
          .then((value) {
        final response = videoProvider.response;

        if (mounted) {
          if (response != null) {
            setState(() {
              if (response.videoList.isNotEmpty) {
                _multiVideoPlayProvider.addVideos(response.videoList);
              }
              if (response.isLast) {
                _multiVideoPlayProvider.isLast = true;
                return;
              }
            });
          }
        }
      });

      _multiVideoPlayProvider.currentPage++;
      debugPrint(
          '다음에 호출될 페이지: _multiVideoPlayProvider.currentPage ${_multiVideoPlayProvider.currentPage}');
    } catch (e) {
      // Handle error if needed
      debugPrint('moon video_view.dart error: $e');
    } finally {}
  }

  void onPageChanged(int index) {
    if (mounted) {
      setState(() {
        _multiVideoPlayProvider.pauseVideo();

        if (!_multiVideoPlayProvider.isLast) {
          _multiVideoPlayProvider.currentIndex = index;

          if (_multiVideoPlayProvider.videoList.length -
                  _multiVideoPlayProvider.currentIndex <=
              _multiVideoPlayProvider.PAGESIZE - 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadMoreVideos();
            });
          }
        } else {
          if (_multiVideoPlayProvider.videoList.length == index) {
            // 마지막 페이지에 도달했을 때 페이지를 0으로 바로 이동
            _multiVideoPlayProvider.pageController.jumpToPage(0);
            _multiVideoPlayProvider.currentIndex = 0;
          } else {
            _multiVideoPlayProvider.currentIndex = index;
          }
        }

        _multiVideoPlayProvider.playVideo();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _multiVideoPlayProvider.pauseVideo();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async {
        if (mounted) {
          setState(() {
            _multiVideoPlayProvider.resetVideoPlayer();
          });
        }
      },
      color: AppColor.purpleColor,
      child: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _multiVideoPlayProvider.pageController = PageController(
                initialPage: _multiVideoPlayProvider.currentIndex),
            scrollDirection: Axis.vertical,
            allowImplicitScrolling: true,
            itemCount: 200,
            itemBuilder: (context, index) {
              if (_multiVideoPlayProvider.currentPage == 0 &&
                  _multiVideoPlayProvider.videoList.isEmpty) {
                _multiVideoPlayProvider.resetVideoPlayer();
                _loadMoreVideos();
                _multiVideoPlayProvider.loading = false;
                return const MusicSpinner(); // 비디오 로딩 중
              } else {
                if (index < _multiVideoPlayProvider.videoList.length) {
                  // 현재 비디오 인덱스 안에 있는 경우
                  return FutureBuilder(
                    future: _multiVideoPlayProvider.videoPlayerFutures[
                        _multiVideoPlayProvider.currentIndex],
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // 비디오가 준비된 경우
                        _multiVideoPlayProvider.loading = true;
                        return VideoPlayerWidget(
                          index: index,
                        ); // 비디오 플레이어 생성
                      }
                      if ((snapshot.connectionState ==
                              ConnectionState.waiting &&
                          _multiVideoPlayProvider.loading)) {
                        // 비디오가 준비된 경우
                        _multiVideoPlayProvider.loading = true;
                        return Stack(children: [
                          VideoPlayerWidget(
                            index: index,
                          ),
                          const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(60, 234, 234, 234),
                              ),
                            ),
                          )
                        ]); // 비디오 플레이어 생성
                      } else {
                        _multiVideoPlayProvider.loading = false;
                        return const MusicSpinner(); // 비디오 로딩 중
                      }
                    },
                  );
                  //마지막 페이지에 진입할 경우
                } else if (index == _multiVideoPlayProvider.videoList.length) {
                  _multiVideoPlayProvider.loading = true;
                  return const MusicSpinner();
                } else {
                  _multiVideoPlayProvider.loading = false;
                  if (_multiVideoPlayProvider.currentIndex <= 0) {
                    //모든 비디오 로드 전 처음 화면에 진입했을 경우
                    return Container(color: Colors.yellow); // 비디오 로딩 중
                  } else {
                    //마지막 페이지에 진입했을 경우
                    return Container(color: Colors.pink);
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
  late MultiVideoPlayProvider _multiVideoPlayProvider;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _multiVideoPlayProvider =
        Provider.of<MultiVideoPlayProvider>(context, listen: false);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 0), // 아이콘이 나타날 때의 애니메이션 속도
      reverseDuration:
          const Duration(milliseconds: 800), // 아이콘이 사라질 때의 애니메이션 속도
      value: 0.0, // 시작 값 설정
    );
  }

  void _toggleIconVisibility(bool newValue) {
    if (mounted) {
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
            final controller =
                _multiVideoPlayProvider.controllers[widget.index];
            if (controller.value.isPlaying) {
              _multiVideoPlayProvider.pauseVideo();
              isPlaying = false;
              _toggleIconVisibility(true);
              Future.delayed(const Duration(milliseconds: 800), () {
                _toggleIconVisibility(false);
              });
            } else {
              _multiVideoPlayProvider.playVideo();
              isPlaying = true;
              _toggleIconVisibility(true);
              Future.delayed(const Duration(milliseconds: 800), () {
                _toggleIconVisibility(false);
              });
            }
          },
          child: VideoPlayer(_multiVideoPlayProvider.controllers[widget.index]),
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
