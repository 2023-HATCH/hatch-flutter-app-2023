import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/data/local/provider/local_pref_provider.dart';
import 'package:pocket_pose/ui/screen/main_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _introKey = GlobalKey<IntroductionScreenState>();
  late double screenHeightSize;

  bool _skipState = true;

  @override
  Widget build(BuildContext context) {
    screenHeightSize = MediaQuery.of(context).size.height;

    return IntroductionScreen(
      onChange: (value) {
        if (value == 4) {
          _skipState = false;
        } else {
          _skipState = true;
        }
        setState(() {});
      },
      globalBackgroundColor: Colors.black,
      globalHeader:
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextButton(
            onPressed: () {
              _introKey.currentState?.skipToEnd();
            },
            child: Text(
              _skipState ? "건너뛰기" : "",
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ),
        )
      ]),
      globalFooter: const SizedBox(
        height: 30.0,
      ),
      key: _introKey,
      pages: [
        getImagePageViewModel(
            title: "대기",
            context: "참여자가 3명 이상이어야\n‘PoPo 스테이지’를시작할 수 있어요.🔥",
            imgPath: "assets/images/img_onboarding_wait.jpeg",
            isVisibleLeft: false),
        getImagePageViewModel(
            title: "캐치",
            context:
                "랜덤으로 챌린지 노래가 선정됩니다.\n선착순 3명만 참여 가능하니 캐치 버튼을 빨리 눌러 참여해봐요! 💪",
            imgPath: "assets/images/img_onboarding_catch.jpeg"),
        getImagePageViewModel(
            title: "플레이",
            context: "노래에 맞춰 춤을 춰봐요.✨\n춤 동작 마다 점수가 표시됩니다.",
            imgPath: "assets/images/img_onboarding_play.jpeg"),
        getImagePageViewModel(
            title: "결과",
            context:
                "최고의 평가를 받은 MVP가 선정 됩니다. 🥳🎉\nMVP는 5초간 모두의 앞에서 세레머니를 할 기회가 주어집니다.",
            imgPath: "assets/images/img_onboarding_result.jpeg"),
        getSvgPageViewModel(
            title: "시작하기",
            context: "자 그럼 지금부터\n포포와 함께 춤 짱이 되러 가볼까요?😝",
            imgPath: "assets/images/bg_popo_result.png"),
      ],
      onDone: () => goHomepage(),
      showDoneButton: false,
      showNextButton: false,
      showSkipButton: false,
      skip: const Text(
        'Skip',
        style: TextStyle(color: Colors.white),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
      done: const Text(
        'Done',
        style: TextStyle(color: Colors.white),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size(8.0, 8.0),
        color: Colors.white,
        activeSize: const Size(8.0, 8.0),
        activeColor: AppColor.purpleColor,
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  PageViewModel getImagePageViewModel(
      {required String title,
      required context,
      required imgPath,
      bool isVisibleLeft = true,
      bool isVisibleRight = true,
      bool isVisibleSkip = true}) {
    return PageViewModel(
      useScrollView: false,
      title: "",
      bodyWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              shadows: [
                for (double i = 1; i < 7; i++)
                  Shadow(color: AppColor.purpleColor2, blurRadius: 3 * i)
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 90,
            child: Text(
              context,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  _introKey.currentState?.previous();
                },
                icon: Visibility(
                  visible: isVisibleLeft,
                  child: SvgPicture.asset(
                    'assets/icons/ic_left_purple.svg',
                  ),
                ),
              ),
              const SizedBox(
                width: 26.0,
              ),
              Expanded(
                child: Image.asset(
                  imgPath,
                  height: screenHeightSize * 0.5,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(
                width: 26.0,
              ),
              IconButton(
                onPressed: () {
                  _introKey.currentState?.next();
                },
                icon: Visibility(
                  visible: isVisibleRight,
                  child: SvgPicture.asset(
                    'assets/icons/ic_right_purple.svg',
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  PageViewModel getSvgPageViewModel(
      {required String title, required context, required imgPath}) {
    return PageViewModel(
        useScrollView: false,
        title: "",
        bodyWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                shadows: [
                  for (double i = 1; i < 7; i++)
                    Shadow(color: AppColor.purpleColor2, blurRadius: 3 * i)
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 90,
              child: Text(
                context,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _introKey.currentState?.previous();
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/ic_left_purple.svg',
                  ),
                ),
                Flexible(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/charactor_on_boarding.svg',
                        fit: BoxFit.contain,
                        height: screenHeightSize * 0.4,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              for (double i = 1; i < 4; i++)
                                BoxShadow(
                                    color: AppColor.blueColor,
                                    blurStyle: BlurStyle.outer,
                                    blurRadius: 3 * i)
                            ]),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            side: const BorderSide(
                                color: Colors.white, width: 2.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () {
                            permission();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "PoPo 입장",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _introKey.currentState?.next();
                  },
                  icon: Visibility(
                    visible: false,
                    child: SvgPicture.asset(
                      'assets/icons/ic_right_purple.svg',
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  void goHomepage() async {
    LocalPrefProvider().setShowOnBoarding(false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  Future<bool> permission() async {
    await [Permission.camera, Permission.storage, Permission.microphone]
        .request();

    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted &&
        await Permission.microphone.isGranted) {
      goHomepage();
      return Future.value(true);
    } else {
      Fluttertoast.showToast(msg: '포포 스테이지를 즐기기 위해 권한을 설정해주세요.');
      return Future.value(false);
    }
  }
}
