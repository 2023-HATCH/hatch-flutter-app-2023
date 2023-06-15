import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  late List<VideoPlayerController> _videoControllers;
  late List<Future<void>> _initializeVideoPlayerFutures;

  List<String> videoLinks = [
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-2.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-4.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-5.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-3.mp4',
    'https://popo2023.s3.ap-northeast-2.amazonaws.com/video/test/V2-1.mp4',
  ];

  List<String> likes = [
    '6.6천',
    '1만',
    '9.2만',
    '9.4천',
    '2.8만',
  ];

  List<String> chats = [
    '110',
    '282',
    '1.2천',
    '230',
    '437',
  ];

  List<String> profiles = [
    'assets/images/home_profile_1.jpg',
    'assets/images/home_profile_2.jpg',
    'assets/images/home_profile_3.jpg',
    'assets/images/home_profile_4.jpg',
    'assets/images/home_profile_5.jpg',
  ];

  List<String> nicknames = [
    '@okoi2202',
    '@ONEUS',
    '@joyseoworld',
    '@yunamong_',
    '@hyezz',
  ];

  List<String> contents = [
    '나이트댄서 춤 댄스챌린지 🌸🤍 | 가사 발음 포함 버전',
    '늦었지만 토카토카 댄스!! (난 추고 본적 없음) #원어스 #ONEUS #서호',
    '띵띵땅땅 이 노래 가사가 이런 뜻이었어...',
    '요즘 난리난 챌린지 #아디아디챌린지 #아디아디아디 #dance #dancevideo #tiktok #reels #chellenge #fyp #dancechallenge #korea',
    '최애의 완소 퍼펙트 반장❤️ #최애의아이',
  ];

  int currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController();

    // 모든 비디오 로드
    _videoControllers = List<VideoPlayerController>.generate(
      videoLinks.length,
      (index) => VideoPlayerController.network(videoLinks[index]),
    );

    // 비디오 초기화 완료를 기다리는 Future 리스트
    _initializeVideoPlayerFutures = List<Future<void>>.generate(
      videoLinks.length,
      (index) => _videoControllers[index].initialize(),
    );

    // 비디오 기본 값 설정
    _videoControllers[currentIndex].play(); // 재생되는 상태
    _videoControllers[currentIndex].setLooping(true); // 영상 무한 반복
    _videoControllers[currentIndex].setVolume(1.0); // 볼륨 설정

    super.initState();
  }

  @override
  void dispose() {
    // 자원을 반환하기 위해 VideoPlayerController dispose.
    for (int i = 0; i < videoLinks.length; i++) {
      _videoControllers[i].dispose();
    }
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _videoControllers[currentIndex].pause().then((_) {
        // 다음 비디오로 변경
        currentIndex = index;

        // 다음 비디오 기본 값 설정
        _videoControllers[currentIndex].play();
        _videoControllers[currentIndex].setLooping(true);
        _videoControllers[currentIndex].setVolume(1.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        allowImplicitScrolling: true,
        itemCount: videoLinks.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
              future: _initializeVideoPlayerFutures[currentIndex],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // 데이터가 수신되었을 때
                  return Stack(children: <Widget>[
                    GestureDetector(
                      // 비디오 클릭 시 영상 정지/재생
                      onTap: () {
                        if (_videoControllers[index].value.isPlaying) {
                          _videoControllers[index].pause();
                        } else {
                          // 만약 영상 일시 중지 상태였다면, 재생.
                          _videoControllers[index].play();
                        }
                      },
                      child: VideoPlayer(_videoControllers[index]),
                    ),
                    // PoPo, Upload, Search
                    const VideoFrameHeaderWidget(),
                    // like, chat, share, progress
                    VideoFrameRightWidget(
                        like: likes[index], chat: chats[index]),
                    // profile, nicname, content
                    VideoFrameContentWidget(
                        profile: profiles[index],
                        nickname: nicknames[index],
                        content: contents[index]),
                  ]);
                } else {
                  // 만약 VideoPlayerController가 여전히 초기화 중이라면, 로딩 스피너를 보여줌.
                  return const Center(child: CircularProgressIndicator());
                }
              });
        },
        onPageChanged: onPageChanged,
      ),
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
      margin: const EdgeInsets.fromLTRB(20, 35, 20, 30),
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
  const VideoFrameRightWidget({
    super.key,
    required this.like,
    required this.chat,
  });

  final String like;
  final String chat;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.orange,
      margin: const EdgeInsets.fromLTRB(335, 515, 20, 60),
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
                  like,
                  style: const TextStyle(color: Colors.white),
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
                  chat,
                  style: const TextStyle(color: Colors.white),
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
  const VideoFrameContentWidget({
    super.key,
    required this.profile,
    required this.nickname,
    required this.content,
  });

  final String profile;
  final String nickname;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.green,
      margin: const EdgeInsets.fromLTRB(20, 615, 100, 80),
      child: Column(children: <Widget>[
        GestureDetector(
          onTap: () {
            Fluttertoast.showToast(msg: 'user 클릭');
          },
          child: Row(children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(profile, width: 35)),
            const Padding(padding: EdgeInsets.only(left: 8)),
            Text(
              nickname,
              style: const TextStyle(color: Colors.white),
            ),
          ]),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 8)),
        Text(
          content,
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
