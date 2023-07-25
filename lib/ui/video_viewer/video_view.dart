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

  @override
  void initState() {
    super.initState();
    videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      videoPlayProvider.setVideo();
    });

    if (widget.screenName == 'home') {
      HomeProvider homeProvider;
      homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.getVideo(const HomeVideosRequest(page: 0, size: 10));
    } else if (widget.screenName == 'my') {
    } else {}
  }

  void onPageChanged(int index) {
    setState(() {
      videoPlayProvider.pauseVideo();
      videoPlayProvider.currentIndex = index;
      videoPlayProvider.setVideo();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(children: <Widget>[
      PageView.builder(
        controller: PageController(
          initialPage: videoPlayProvider.currentIndex, // 시작 페이지
        ),
        scrollDirection: Axis.vertical,
        allowImplicitScrolling: true,
        itemCount: videoPlayProvider.videoLinks.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: videoPlayProvider.videoPlayerFutures[index],
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done ||
                  (snapshot.connectionState == ConnectionState.waiting &&
                      videoPlayProvider.loading)) {
                // 데이터가 수신되었을 때
                videoPlayProvider.loading = true;

                return Stack(children: <Widget>[
                  GestureDetector(
                    // 비디오 클릭 시 영상 정지/재생
                    onTap: () {
                      if (videoPlayProvider
                          .controllers[index].value.isPlaying) {
                        videoPlayProvider.pauseVideo();
                      } else {
                        // 만약 영상 일시 중지 상태였다면, 재생.
                        videoPlayProvider.playVideo();
                      }
                    },
                    child: VideoPlayer(videoPlayProvider.controllers[index]),
                  ),
                  // like, chat, share, progress
                  VideoRightFrame(
                    index: index,
                  ),
                  // profile, nicname, content
                  VideoUserInfoFrame(index: index),
                ]);
              } else {
                // 만약 VideoPlayerController가 여전히 초기화 중이라면, 포포 로딩 스피너를 보여줌.
                return const MusicSpinner();
              }
            },
          );
        },
        onPageChanged: onPageChanged,
      ),
    ]);
  }
}
