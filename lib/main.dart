import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pocket_pose/data/local/provider/video_play_provider.dart';
import 'package:provider/provider.dart';
import 'package:pocket_pose/ui/screen/main_screen.dart';

// 카메라 목록 변수
List<CameraDescription> cameras = [];

Future<void> main() async {
  KakaoSdk.init(nativeAppKey: 'f03a21b3fa588715cb55730113dea1ab');
  // 비동기 메서드를 사용함
  WidgetsFlutterBinding.ensureInitialized();
  // 사용 가능한 카메라 목록 받아옴
  cameras = await availableCameras();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => VideoPlayProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'GmarketSans'),
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}
