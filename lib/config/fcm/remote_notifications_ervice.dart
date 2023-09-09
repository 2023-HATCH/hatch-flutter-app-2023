import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pocket_pose/config/fcm/notification_service.dart';

class RemoteNotificationService {
  RemoteNotificationService() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    initNotificationSettings(messaging);
  }

  Future<void> initNotificationSettings(FirebaseMessaging messaging) async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      notificationService.showForegroundNotifications(message);
    });
  }
}
