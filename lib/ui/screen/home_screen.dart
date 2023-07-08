import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/ui/widget/music_spinner_widget.dart';
import 'package:pocket_pose/ui/widget/home/home_video_frame_content_widget.dart';
import 'package:pocket_pose/ui/widget/home/home_video_frame_right_widget.dart';
import 'package:pocket_pose/ui/widget/home/upload_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

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
      appBar: AppBar(
        //centerTitle: true, //Title text 가운데 정렬
        title: const Text(
          "PoPo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent, //appBar 투명색
        elevation: 0.0, //appBar 그림자 농도 설정 (값 0으로 제거)
        actions: [
          UploadButtonWidget(context: context),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
              child: SvgPicture.asset('assets/icons/ic_home_search.svg')),
        ],
      ),
      extendBodyBehindAppBar: true, //body 위에 appbar

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
                    _videoPlayProvider.loading = true;

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
                          ConnectionState.waiting &&
                      _videoPlayProvider.loading) {
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
                    // 만약 VideoPlayerController가 여전히 초기화 중이라면, 포포 로딩 스피너를 보여줌.
                    return const MusicSpinner();
                  }
                });
          },
          onPageChanged: onPageChanged,
        ),
      ]),
    );
  }
}
