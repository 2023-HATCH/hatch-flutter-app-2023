import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/route_manager.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pocket_pose/config/share/dynamic_link.dart';
import 'package:pocket_pose/data/local/provider/local_pref_provider.dart';
import 'package:pocket_pose/data/local/provider/multi_video_play_provider.dart';
import 'package:pocket_pose/data/remote/provider/chat_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/comment_provider.dart';
import 'package:pocket_pose/data/remote/provider/follow_provider.dart';
import 'package:pocket_pose/data/remote/provider/kakao_login_provider.dart';
import 'package:pocket_pose/data/remote/provider/like_provider.dart';
import 'package:pocket_pose/data/remote/provider/profile_provider.dart';
import 'package:pocket_pose/data/remote/provider/search_provider.dart';
import 'package:pocket_pose/data/remote/provider/share_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/socket_chat_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/socket_stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/stage_talk_provider_impl.dart';
import 'package:pocket_pose/data/remote/provider/video_provider.dart';
import 'package:pocket_pose/firebase_options.dart';
import 'package:pocket_pose/ui/screen/chat/chat_detail_screen.dart';
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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DynamicLink().setup();
  // 푸시알림 설정
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = const DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse details) async {
      // 푸시알림 클릭 시 동작
      if (details.payload != null) {
        try {
          Map<String, dynamic> notificationPayload =
              jsonDecode(details.payload!);
          switch (notificationPayload['type']) {
            case "SEND_CHAT_MESSAGE":
              Get.to(
                  transition: Transition.rightToLeft,
                  () => ChatDetailScreen(
                        chatRoomId: notificationPayload['chatRoomId'],
                        opponentUserNickName: notificationPayload['title'],
                      ));
              break;
          }
        } catch (error) {
          debugPrint('mmm Notification payload error $error');
        }
      }
    },
  );
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'popo_notification', 'popo_notification',
      description: 'popo 알림', importance: Importance.max);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (message.notification != null) {
      message.data.putIfAbsent('title', () => notification?.title);
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          payload: jsonEncode(message.data),
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
            ),
          ));
    }
  });

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => MultiVideoPlayProvider()),
    ChangeNotifierProvider(create: (_) => KaKaoLoginProvider()),
    ChangeNotifierProvider(create: (_) => VideoProvider()),
    ChangeNotifierProvider(create: (_) => LikeProvider()),
    ChangeNotifierProvider(create: (_) => CommentProvider()),
    ChangeNotifierProvider(create: (_) => ProfileProvider()),
    ChangeNotifierProvider(create: (_) => FollowProvider()),
    ChangeNotifierProvider(create: (_) => SearchProvider()),
    ChangeNotifierProvider(create: (_) => ChatProviderImpl()),
    ChangeNotifierProvider(create: (_) => SocketChatProviderImpl()),
    ChangeNotifierProvider(create: (_) => StageProviderImpl()),
    ChangeNotifierProvider(create: (_) => SocketStageProviderImpl()),
    ChangeNotifierProvider(create: (_) => StageTalkProviderImpl()),
    ChangeNotifierProvider(create: (_) => ShareProviderImpl()),
  ], child: MyApp(showOnBoarding: showOnBoarding)));
}

class MyApp extends StatelessWidget {
  final bool showOnBoarding;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key, required this.showOnBoarding});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'GmarketSans'),
      themeMode: ThemeMode.system,
      home: showOnBoarding ? const OnBoardingScreen() : const MainScreen(),
      navigatorKey: navigatorKey,
    );
  }
}
