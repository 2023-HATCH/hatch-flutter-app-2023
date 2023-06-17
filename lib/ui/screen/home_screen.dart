import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  // (1) 추가
  late VideoPlayProvider _videoPlayProvider;

  // (2) 추가
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // _pageController = PageController();
    // listen: false 상태 변화에 대해 위젯을 새로고치지 않겠다.
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    // // 모든 비디오 로드
    // _videoControllers = List<VideoPlayerController>.generate(
    //   videoLinks.length,
    //   (index) => VideoPlayerController.network(videoLinks[index]),
    // );
    //_videoPlayProvider.loadVideo();

    // 비디오 초기화 완료를 기다리는 Future 리스트
    // _initializeVideoPlayerFutures = List<Future<void>>.generate(
    //   _videoPlayProvider.videoLinks.length,
    //   (index) => _videoPlayProvider.controllers[index].initialize(),
    // );

    // // 비디오 기본 값 설정
    // _videoControllers[currentIndex].play(); // 재생되는 상태
    // _videoControllers[currentIndex].setLooping(true); // 영상 무한 반복
    // _videoControllers[currentIndex].setVolume(1.0); // 볼륨 설정
    // _videoPlayProvider.setVideo();

    //_videoPlayProvider.playVideo();
    super.initState();
  }

  // @override
  // void dispose() {
  //   // // 자원을 반환하기 위해 VideoPlayerController dispose.
  //   // for (int i = 0; i < videoLinks.length; i++) {
  //   //   _videoControllers[i].dispose();
  //   // }
  //   //_videoPlayProvider.disposeVideoController();
  //   // _videoPlayProvider.pauseVideo();
  //   //super.dispose();
  // }

  void onPageChanged(int index) {
    setState(() {
      _videoPlayProvider.controllers[_videoPlayProvider.currentIndex]
          .pause()
          .then((_) {
        // 다음 비디오로 변경
        _videoPlayProvider.currentIndex = index;

        // 다음 비디오 기본 값 설정
        // _videoControllers[currentIndex].play();
        // _videoControllers[currentIndex].setLooping(true);
        // _videoControllers[currentIndex].setVolume(1.0);
        _videoPlayProvider.setVideo();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        PageView.builder(
          //controller: _videoPlayProvider.pageController,
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

class VideoFrameHeaderWidget extends StatelessWidget {
  const VideoFrameHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      margin: const EdgeInsets.fromLTRB(20, 40, 20, 30),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/home_popo.svg',
            ),
            Row(children: <Widget>[
              GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(msg: 'upload 클릭');
                },
                child: SvgPicture.asset(
                  'assets/icons/home_upload.svg',
                  width: 18,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 18)),
              GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(msg: 'search 클릭');
                },
                child: SvgPicture.asset(
                  'assets/icons/home_search.svg',
                  width: 18,
                ),
              ),
            ]),
          ]),
    );
  }
}

class VideoFrameRightWidget extends StatelessWidget {
  VideoFrameRightWidget({super.key, required this.index});

  late VideoPlayProvider _videoPlayProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    return Container(
      //color: Colors.orange,
      width: 60,
      margin: const EdgeInsets.fromLTRB(330, 520, 10, 60),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Fluttertoast.showToast(msg: 'like 클릭');
              },
              child: Column(children: <Widget>[
                SvgPicture.asset(
                  'assets/icons/home_like.svg',
                ),
                const Padding(padding: EdgeInsets.only(bottom: 2)),
                Text(
                  _videoPlayProvider.likes[index],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ]),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 14)),
            GestureDetector(
              onTap: () {
                Fluttertoast.showToast(msg: 'chat 클릭');
              },
              child: Column(children: <Widget>[
                SvgPicture.asset(
                  'assets/icons/home_chat.svg',
                ),
                const Padding(padding: EdgeInsets.only(bottom: 2)),
                Text(
                  _videoPlayProvider.chats[index],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ]),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 14)),
            Column(children: <Widget>[
              GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(msg: 'share 클릭');
                },
                child: SvgPicture.asset(
                  'assets/icons/home_share.svg',
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2)),
            ]),
            const Padding(padding: EdgeInsets.only(bottom: 14)),
            Column(children: <Widget>[
              SvgPicture.asset(
                'assets/icons/home_progress.svg',
              ),
            ]),
          ]),
    );
  }
}

class VideoFrameContentWidget extends StatelessWidget {
  VideoFrameContentWidget({super.key, required this.index});

  late VideoPlayProvider _videoPlayProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);

    return Container(
      //color: Colors.green,
      margin: const EdgeInsets.fromLTRB(20, 620, 100, 80),
      child: Column(children: <Widget>[
        GestureDetector(
          onTap: () {
            Fluttertoast.showToast(msg: 'user 클릭');
          },
          child: Row(children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child:
                    Image.asset(_videoPlayProvider.profiles[index], width: 35)),
            const Padding(padding: EdgeInsets.only(left: 8)),
            Text(
              _videoPlayProvider.nicknames[index],
              style: const TextStyle(color: Colors.white),
            ),
          ]),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 8)),
        Text(
          _videoPlayProvider.contents[index],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ]),
    );
  }
}
