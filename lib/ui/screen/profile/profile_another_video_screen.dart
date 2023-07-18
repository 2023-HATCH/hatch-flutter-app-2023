import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:pocket_pose/ui/widget/home/chat_button_widget.dart';
import 'package:pocket_pose/ui/widget/music_spinner_widget.dart';
import 'package:pocket_pose/ui/widget/home/home_video_frame_content_widget.dart';
import 'package:pocket_pose/ui/widget/home/home_video_frame_right_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class AnotherVideoScreen extends StatefulWidget {
  AnotherVideoScreen({Key? key, required this.index}) : super(key: key);

  int index;

  @override
  State<AnotherVideoScreen> createState() => _AnotherVideoScreenState();
}

class _AnotherVideoScreenState extends State<AnotherVideoScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  // 새로고침 방지 (1) 추가
  // 새로고침 방지 (2) 추가
  @override
  bool get wantKeepAlive => true;

  late VideoPlayProvider _videoPlayProvider;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _videoPlayProvider = Provider.of<VideoPlayProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _videoPlayProvider.setVideo();
    });
  }

  void onPageChanged(int index) {
    setState(() {
      _videoPlayProvider.pauseVideo();

      _videoPlayProvider.currentIndex = index;

      _videoPlayProvider.setVideo();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
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
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/ic_stage_back_white.svg',
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        extendBodyBehindAppBar: true, //body 위에 appbar
        resizeToAvoidBottomInset: true,
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
                  if (_videoPlayProvider.controllers[index].value.isPlaying) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // 데이터가 수신되었을 때
                      _videoPlayProvider.loading = true;

                      return Stack(children: <Widget>[
                        GestureDetector(
                          // 비디오 클릭 시 영상 정지/재생
                          onTap: () {
                            if (_videoPlayProvider
                                .controllers[index].value.isPlaying) {
                              _videoPlayProvider.pauseVideo();
                            } else {
                              // 만약 영상 일시 중지 상태였다면, 재생.
                              _videoPlayProvider.playVideo();
                            }
                          },
                          child: VideoPlayer(
                              _videoPlayProvider.controllers[index]),
                        ),
                        // like, chat, share, progress
                        VideoFrameRightWidget(
                          index: index,
                        ),
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
                              _videoPlayProvider.pauseVideo();
                            } else {
                              // 만약 영상 일시 중지 상태였다면, 재생.
                              _videoPlayProvider.playVideo();
                            }
                          },
                          child: VideoPlayer(
                              _videoPlayProvider.controllers[index]),
                        ),
                        // like, chat, share, progress
                        VideoFrameRightWidget(
                          index: index,
                        ),
                        // profile, nicname, content
                        VideoFrameContentWidget(index: index),
                      ]);
                    } else {
                      // 만약 VideoPlayerController가 여전히 초기화 중이라면, 포포 로딩 스피너를 보여줌.
                      return const MusicSpinner();
                    }
                  } else {
                    // 만약 VideoPlayerController가 여전히 로딩 중이라면, 포포 로딩 스피너를 보여줌.
                    return const MusicSpinner();
                  }
                },
              );
            },
            onPageChanged: onPageChanged,
          ),
        ]),
        bottomSheet: Container(
          height: 65,
          color: Colors.white,
          child: Row(
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(left: 18)),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  _videoPlayProvider.profiles[widget.index],
                  width: 40,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 18)),
              Expanded(
                child: ChatButtonWidget(
                  index: widget.index,
                  childWidget: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColor.grayColor2),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 18)),
                        Expanded(
                          child: Text(
                            '따듯한 말 한마디 해주세요!',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 18)),
            ],
          ),
        ));
  }
}
