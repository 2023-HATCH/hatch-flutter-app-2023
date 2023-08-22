import 'package:flutter/material.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/entity/request/videos_request.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/video_provider.dart';
import 'package:pocket_pose/ui/video_viewer/widget/video_player_widget.dart';
import 'package:pocket_pose/ui/widget/music_spinner_widget.dart';
import 'package:provider/provider.dart';

class MultiVideoPlayerView extends StatefulWidget {
  const MultiVideoPlayerView(
      {super.key,
      required int screenNum,
      int? initialIndex,
      ValueSetter<int>? setCurrentIndex})
      : screenNum = screenNum,
        initialIndex = initialIndex,
        setCurrentIndex = setCurrentIndex;

  final int screenNum;
  final int? initialIndex;
  final ValueSetter<int>? setCurrentIndex;

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
      if (_multiVideoPlayProvider.videos[widget.screenNum].isNotEmpty) {
        if (widget.initialIndex != null) {
          _multiVideoPlayProvider.currentIndexs[widget.screenNum] =
              widget.initialIndex!;
        }
        _multiVideoPlayProvider.playVideo(widget.screenNum);
      }
    });
  }

  Future<void> _loadMoreVideos() async {
    try {
      if (widget.screenNum == 0) {
        final videoProvider =
            Provider.of<VideoProvider>(context, listen: false);
        debugPrint(
            '현재 페이지: _multiVideoPlayProvider.currentPage ${_multiVideoPlayProvider.currentPages[widget.screenNum]}');
        videoProvider
            .getVideos(VideosRequest(
                page: _multiVideoPlayProvider.currentPages[widget.screenNum],
                size: _multiVideoPlayProvider.pageSize))
            .then((value) {
          final response = videoProvider.response;

          if (mounted) {
            if (response != null) {
              setState(() {
                if (response.videoList.isNotEmpty) {
                  _multiVideoPlayProvider.addVideos(
                      widget.screenNum, response.videoList);
                }
                if (response.isLast) {
                  _multiVideoPlayProvider.isLasts[widget.screenNum] = true;
                  return;
                }
              });
            }
          }
        });

        _multiVideoPlayProvider.currentPages[widget.screenNum]++;
        debugPrint(
            '다음에 호출될 페이지: _multiVideoPlayProvider.currentPage ${_multiVideoPlayProvider.currentPages[widget.screenNum]}');
      }
    } catch (e) {
      // Handle error if needed
      debugPrint('moon video_view.dart error: $e');
    } finally {}
  }

  void onPageChanged(int index) {
    if (mounted) {
      debugPrint(
          '비디오: _multiVideoPlayProvider.currentIndexs[widget.screenNum] // ${_multiVideoPlayProvider.currentIndexs[widget.screenNum]}');
      debugPrint('비디오: index // $index');
      debugPrint(
          '비디오: _multiVideoPlayProvider.videos[widget.screenNum].length // ${_multiVideoPlayProvider.videos[widget.screenNum].length}');
      setState(() {
        _multiVideoPlayProvider.pauseVideo(widget.screenNum);

        if (index != _multiVideoPlayProvider.videos[widget.screenNum].length) {
          //if (!_multiVideoPlayProvider.isLasts[widget.screenNum]) {
          _multiVideoPlayProvider.currentIndexs[widget.screenNum] = index;
          if (widget.setCurrentIndex != null) widget.setCurrentIndex!(index);

          if (widget.screenNum == 0) {
            if (_multiVideoPlayProvider.videos[widget.screenNum].length -
                    _multiVideoPlayProvider.currentIndexs[widget.screenNum] <=
                _multiVideoPlayProvider.pageSize - 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _loadMoreVideos();
              });
            }
          }
        } else {
          if (_multiVideoPlayProvider.videos[widget.screenNum].length ==
              index) {
            // 마지막 페이지에 도달했을 때 페이지를 0으로 바로 이동
            _multiVideoPlayProvider.pageControllers[widget.screenNum]
                .jumpToPage(0);
            _multiVideoPlayProvider.currentIndexs[widget.screenNum] = 0;
          } else {
            _multiVideoPlayProvider.currentIndexs[widget.screenNum] = index;
          }
        }

        _multiVideoPlayProvider.playVideo(widget.screenNum);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _multiVideoPlayProvider.pauseVideo(widget.screenNum);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.screenNum == 0) {
      return RefreshIndicator(
        onRefresh: () async {
          if (mounted) {
            setState(() {
              _multiVideoPlayProvider.resetVideoPlayer(widget.screenNum);
            });
          }
        },
        color: AppColor.purpleColor,
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller:
                  _multiVideoPlayProvider.pageControllers[widget.screenNum] =
                      PageController(
                          initialPage: widget.initialIndex ??
                              _multiVideoPlayProvider
                                  .currentIndexs[widget.screenNum]),
              scrollDirection: Axis.vertical,
              allowImplicitScrolling: true,
              itemCount: 200,
              itemBuilder: (context, index) {
                if (_multiVideoPlayProvider.currentPages[widget.screenNum] ==
                        0 &&
                    _multiVideoPlayProvider.videos[widget.screenNum].isEmpty) {
                  _multiVideoPlayProvider.resetVideoPlayer(widget.screenNum);
                  _loadMoreVideos();
                  _multiVideoPlayProvider.loadings[widget.screenNum] = false;
                  return const MusicSpinner(); // 비디오 로딩 중
                } else {
                  if (index <
                          _multiVideoPlayProvider
                              .videoControllers[widget.screenNum].length &&
                      index <
                          _multiVideoPlayProvider
                              .videos[widget.screenNum].length &&
                      index <
                          _multiVideoPlayProvider
                              .videoFutures[widget.screenNum].length) {
                    // 현재 비디오 인덱스 안에 있는 경우
                    return FutureBuilder(
                      future:
                          _multiVideoPlayProvider.videoFutures[widget.screenNum]
                              [_multiVideoPlayProvider
                                  .currentIndexs[widget.screenNum]],
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // 비디오가 준비된 경우
                          _multiVideoPlayProvider.loadings[widget.screenNum] =
                              true;
                          return VideoPlayerWidget(
                            screenNum: widget.screenNum,
                            index: index,
                          ); // 비디오 플레이어 생성
                        }
                        if ((snapshot.connectionState ==
                                ConnectionState.waiting &&
                            _multiVideoPlayProvider
                                .loadings[widget.screenNum])) {
                          // 비디오가 준비된 경우
                          _multiVideoPlayProvider.loadings[widget.screenNum] =
                              true;
                          return Stack(children: [
                            VideoPlayerWidget(
                              screenNum: widget.screenNum,
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
                          _multiVideoPlayProvider.loadings[widget.screenNum] =
                              false;
                          return const MusicSpinner(); // 비디오 로딩 중
                        }
                      },
                    );
                    //마지막 페이지에 진입할 경우
                  } else if (index ==
                      _multiVideoPlayProvider.videos[widget.screenNum].length) {
                    _multiVideoPlayProvider.loadings[widget.screenNum] = true;
                    return const MusicSpinner();
                  } else {
                    _multiVideoPlayProvider.loadings[widget.screenNum] = false;
                    if (_multiVideoPlayProvider
                            .currentIndexs[widget.screenNum] <=
                        0) {
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
    } else {
      return Stack(
        children: <Widget>[
          PageView.builder(
            controller:
                _multiVideoPlayProvider.pageControllers[widget.screenNum] =
                    PageController(
                        initialPage: widget.initialIndex ??
                            _multiVideoPlayProvider
                                .currentIndexs[widget.screenNum]),
            scrollDirection: Axis.vertical,
            allowImplicitScrolling: true,
            itemCount: 200,
            itemBuilder: (context, index) {
              if (_multiVideoPlayProvider.currentPages[widget.screenNum] == 0 &&
                  _multiVideoPlayProvider.videos[widget.screenNum].isEmpty) {
                _multiVideoPlayProvider.resetVideoPlayer(widget.screenNum);
                _loadMoreVideos();
                _multiVideoPlayProvider.loadings[widget.screenNum] = false;
                return const MusicSpinner(); // 비디오 로딩 중
              } else {
                if (index <
                        _multiVideoPlayProvider
                            .videoControllers[widget.screenNum].length &&
                    index <
                        _multiVideoPlayProvider
                            .videos[widget.screenNum].length &&
                    index <
                        _multiVideoPlayProvider
                            .videoFutures[widget.screenNum].length) {
                  // 현재 비디오 인덱스 안에 있는 경우
                  return FutureBuilder(
                    future:
                        _multiVideoPlayProvider.videoFutures[widget.screenNum][
                            _multiVideoPlayProvider
                                .currentIndexs[widget.screenNum]],
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // 비디오가 준비된 경우
                        _multiVideoPlayProvider.loadings[widget.screenNum] =
                            true;
                        return VideoPlayerWidget(
                          screenNum: widget.screenNum,
                          index: index,
                        ); // 비디오 플레이어 생성
                      }
                      if ((snapshot.connectionState ==
                              ConnectionState.waiting &&
                          _multiVideoPlayProvider.loadings[widget.screenNum])) {
                        // 비디오가 준비된 경우
                        _multiVideoPlayProvider.loadings[widget.screenNum] =
                            true;
                        return Stack(children: [
                          VideoPlayerWidget(
                            screenNum: widget.screenNum,
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
                        _multiVideoPlayProvider.loadings[widget.screenNum] =
                            false;
                        return const MusicSpinner(); // 비디오 로딩 중
                      }
                    },
                  );
                  //마지막 페이지에 진입할 경우
                } else if (index ==
                    _multiVideoPlayProvider.videos[widget.screenNum].length) {
                  _multiVideoPlayProvider.loadings[widget.screenNum] = true;
                  return const MusicSpinner();
                } else {
                  _multiVideoPlayProvider.loadings[widget.screenNum] = false;
                  if (_multiVideoPlayProvider.currentIndexs[widget.screenNum] <=
                      0) {
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
      );
    }
  }
}
