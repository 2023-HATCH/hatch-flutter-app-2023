import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/request/videos_request.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/video_provider.dart';
import 'package:pocket_pose/ui/video_viewer/widget/video_player_widget.dart';
import 'package:pocket_pose/ui/widget/music_spinner_widget.dart';
import 'package:provider/provider.dart';

class MultiVideoPlayerView extends StatefulWidget {
  const MultiVideoPlayerView({super.key, required String screenName})
      : screenName = screenName;

  final String screenName;

  @override
  State<MultiVideoPlayerView> createState() => _MultiVideoPlayerViewState();
}

class _MultiVideoPlayerViewState extends State<MultiVideoPlayerView>
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
