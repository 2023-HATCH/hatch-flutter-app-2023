import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pocket_pose/data/local/provider/local_pref_provider.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/chat_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/comment_provider.dart';
import 'package:pocket_pose/data/remote/provider/follow_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/data/remote/provider/like_provider.dart';
import 'package:pocket_pose/data/remote/provider/profile_provider.dart';
import 'package:pocket_pose/data/remote/provider/socket_chat_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_talk_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/video_provider.dart';
import 'package:pocket_pose/ui/screen/main_screen.dart';
import 'package:pocket_pose/ui/screen/on_boarding_screen.dart';
import 'package:provider/provider.dart';

// 카메라 목록 변수
List<CameraDescription> cameras = [];

Future<void> main() async {
  KakaoSdk.init(nativeAppKey: 'f03a21b3fa588715cb55730113dea1ab');
  // 비동기 메서드를 사용함
  WidgetsFlutterBinding.ensureInitialized();
  // 사용 가능한 카메라 목록 받아옴
  cameras = await availableCameras();

  bool showOnBoarding = await LocalPrefProvider().getShowOnBoarding();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => MultiVideoPlayProvider()),
    ChangeNotifierProvider(create: (_) => KaKaoLoginProvider()),
    ChangeNotifierProvider(create: (_) => VideoProvider()),
    ChangeNotifierProvider(create: (_) => LikeProvider()),
    ChangeNotifierProvider(create: (_) => CommentProvider()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ChangeNotifierProvider(create: (_) => FollowProvider()),
    ChangeNotifierProvider(create: (_) => ChatProviderImpl()),
    ChangeNotifierProvider(create: (_) => SocketChatProviderImpl()),
    ChangeNotifierProvider(create: (_) => StageProviderImpl()),
    ChangeNotifierProvider(create: (_) => SocketStageProviderImpl()),
    ChangeNotifierProvider(create: (_) => StageTalkProviderImpl()),
  ], child: MyApp(showOnBoarding: showOnBoarding)));
}

class MyApp extends StatelessWidget {
  final bool showOnBoarding;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key, required this.showOnBoarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'GmarketSans'),
      themeMode: ThemeMode.system,
      home: showOnBoarding ? const OnBoardingScreen() : const MainScreen(),
      navigatorKey: navigatorKey,
    );
  }
}
