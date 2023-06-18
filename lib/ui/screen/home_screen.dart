import 'package:flutter/material.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/ui/widget/home_video_frame_header_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../widget/home_video_frame_content_widget.dart';
import '../widget/home_video_frame_right_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  // 새로고침 방지 (1) 추가
  // 새로고침 방지 (2) 추가
  @override
  bool get wantKeepAlive => true;

  late VideoPlayProvider _videoPlayProvider;

  @override
  void initState() {
    // listen: false 상태 변화에 대해 위젯을 새로고치지 않겠다.
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      _videoPlayProvider.controllers[_videoPlayProvider.currentIndex]
          .pause()
          .then((_) {
        // 다음 비디오로 변경
        _videoPlayProvider.currentIndex = index;

        _videoPlayProvider.setVideo();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(children: <Widget>[
        PageView.builder(
          controller: PageController(
            initialPage: _videoPlayProvider.currentIndex, //시작 페이지
          ),
          scrollDirection: Axis.vertical,
          allowImplicitScrolling: true,
          itemCount: _videoPlayProvider.videoLinks.length,
          itemBuilder: (context, index) {
            return FutureBuilder(
                future: _videoPlayProvider
                    .videoPlayerFutures[_videoPlayProvider.currentIndex],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // 데이터가 수신되었을 때
                    return Stack(children: <Widget>[
                      GestureDetector(
                        // 비디오 클릭 시 영상 정지/재생
                        onTap: () {
                          if (_videoPlayProvider
                              .controllers[index].value.isPlaying) {
                            _videoPlayProvider.controllers[index].pause();
                          } else {
                            // 만약 영상 일시 중지 상태였다면, 재생.
                            _videoPlayProvider.controllers[index].play();
                          }
                        },
                        child:
                            VideoPlayer(_videoPlayProvider.controllers[index]),
                      ),
                      // like, chat, share, progress
                      VideoFrameRightWidget(index: index),
                      // profile, nicname, content
                      VideoFrameContentWidget(index: index),
                    ]);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    // 데이터가 로딩중일 때
                    return Stack(children: <Widget>[
                      GestureDetector(
                        // 비디오 클릭 시 영상 정지/재생
                        onTap: () {
                          if (_videoPlayProvider
                              .controllers[index].value.isPlaying) {
                            _videoPlayProvider.controllers[index].pause();
                          } else {
                            // 만약 영상 일시 중지 상태였다면, 재생.
                            _videoPlayProvider.controllers[index].play();
                          }
                        },
                        child:
                            VideoPlayer(_videoPlayProvider.controllers[index]),
                      ),
                      // like, chat, share, progress
                      VideoFrameRightWidget(index: index),
                      // profile, nicname, content
                      VideoFrameContentWidget(index: index),
                    ]);
                  } else {
                    // 만약 VideoPlayerController가 여전히 초기화 중이라면, 로딩 스피너를 보여줌.
                    return const Center(child: CircularProgressIndicator());
                  }
                });
          },
          onPageChanged: onPageChanged,
        ),
        // PoPo, upload, search
        const VideoFrameHeaderWidget(),
      ]),
    );
  }
}
