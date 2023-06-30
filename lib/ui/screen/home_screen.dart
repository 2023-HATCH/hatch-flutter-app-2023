import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/ui/widget/music_spinner_widget.dart';
import 'package:pocket_pose/ui/widget/home/home_video_frame_content_widget.dart';
import 'package:pocket_pose/ui/widget/home/home_video_frame_right_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  // 새로고침 방지 (1) 추가
  // 새로고침 방지 (2) 추가
  @override
  bool get wantKeepAlive => true;
  List<double> _progressValues = [];

  late VideoPlayProvider _videoPlayProvider;
  late final List<AnimationController> _progresControllers;

  @override
  void initState() {
    super.initState();
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _videoPlayProvider.setVideo();
    });
    // 이전에 저장된 진행 상태 로드
    _progressValues =
        List<double>.filled(_videoPlayProvider.videoLinks.length, 0.0);
    createProgressController();
  }

  void onPageChanged(int index) {
    setState(() {
      _progresControllers[index].stop();
      _videoPlayProvider.pauseVideo();

      _videoPlayProvider.currentIndex = index;

      _progresControllers[index].repeat();
      _videoPlayProvider.setVideo();
    });
  }

  void createProgressController() {
    _progresControllers = List<AnimationController>.generate(
      _videoPlayProvider.videoLinks.length,
      (index) {
        double progressValue = _progressValues.length > index
            ? _progressValues[index]
            : 0.0; // 이전에 저장된 진행 상태가 있으면 사용하고, 없으면 0으로 초기화
        var controller = AnimationController(
          vsync: this,
          duration: Duration(
              milliseconds: _videoPlayProvider.videoMilliseconds[index]),
          lowerBound: 0, // 최소값 설정
          upperBound: 1, // 최대값 설정
          value: progressValue, // 이전에 저장된 진행 상태를 설정
        )..addListener(() {
            if (_videoPlayProvider.controllers[index].value.isPlaying) {
              _progresControllers[index].repeat();
            } else {
              _progresControllers[index].stop();
            }
            _progressValues[index] =
                _progresControllers[index].value; // 진행 상태 저장
          });
        return controller;
      },
    );
  }

  @override
  void dispose() {
    for (var controller in _progresControllers) {
      controller.dispose();
    }
    super.dispose();
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
          Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 14, 0),
              child: SvgPicture.asset('assets/icons/ic_home_upload.svg')),
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
              future: _videoPlayProvider.videoPlayerFutures[index],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // 데이터가 수신되었을 때
                  _progresControllers[index].repeat();
                  _videoPlayProvider.loading = true;

                  return Stack(children: <Widget>[
                    GestureDetector(
                      // 비디오 클릭 시 영상 정지/재생
                      onTap: () {
                        if (_videoPlayProvider
                            .controllers[index].value.isPlaying) {
                          _progresControllers[index].stop();
                          _videoPlayProvider.pauseVideo();
                        } else {
                          // 만약 영상 일시 중지 상태였다면, 재생.
                          _progresControllers[index].repeat();
                          _videoPlayProvider.playVideo();
                        }
                      },
                      child: VideoPlayer(_videoPlayProvider.controllers[index]),
                    ),
                    // like, chat, share, progress
                    VideoFrameRightWidget(
                      index: index,
                      progresController: _progresControllers[index],
                    ),
                    // profile, nicname, content
                    VideoFrameContentWidget(index: index),
                  ]);
                } else if (snapshot.connectionState ==
                        ConnectionState.waiting &&
                    _videoPlayProvider.loading) {
                  // 데이터가 로딩중일 때
                  _progresControllers[index].repeat();

                  return Stack(children: <Widget>[
                    GestureDetector(
                      // 비디오 클릭 시 영상 정지/재생
                      onTap: () {
                        if (_videoPlayProvider
                            .controllers[index].value.isPlaying) {
                          _progresControllers[index].stop();
                          _videoPlayProvider.pauseVideo();
                        } else {
                          // 만약 영상 일시 중지 상태였다면, 재생.
                          _progresControllers[index].repeat();
                          _videoPlayProvider.playVideo();
                        }
                      },
                      child: VideoPlayer(_videoPlayProvider.controllers[index]),
                    ),
                    // like, chat, share, progress
                    VideoFrameRightWidget(
                      index: index,
                      progresController: _progresControllers[index],
                    ),
                    // profile, nicname, content
                    VideoFrameContentWidget(index: index),
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
      ]),
    );
  }
}
