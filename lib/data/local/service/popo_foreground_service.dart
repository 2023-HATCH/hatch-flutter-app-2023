import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class PoPoForegroundService {
  static void initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
        buttons: [
          const NotificationButton(id: 'sendButton', text: 'Send'),
          const NotificationButton(id: 'testButton', text: 'Test'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<void> startService() async {
    initForegroundTask();
    // 포그라운드 서비스를 시작, 노티피케이션 표시
    await FlutterForegroundTask.startService(
      notificationTitle: 'Your Foreground Service',
      notificationText: 'Foreground service for media projection',
    );
  }

  static Future<void> stopService() async {
    // 포그라운드 서비스를 종료
    await FlutterForegroundTask.stopService();
  }
}
