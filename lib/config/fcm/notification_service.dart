import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pocket_pose/config/fcm/remote_notifications_ervice.dart';
import 'package:pocket_pose/main.dart';

NotificationService notificationService = NotificationService();

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = 'popo_notification';
  static const channelName = 'popo_notification';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    RemoteNotificationService();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  final AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: 'popo description',
    playSound: true,
    priority: Priority.high,
    importance: Importance.max,
  );

  Future<void> showNotifications(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title,
        notification?.body,
        payload: jsonEncode(message.data),
        NotificationDetails(android: _androidNotificationDetails));
  }

  Future<void> showForegroundNotifications(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title,
        notification?.body,
        payload: jsonEncode(message.data),
        NotificationDetails(android: _androidNotificationDetails));
  }

  Future<void> scheduleNotifications(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title,
        notification?.body,
        payload: jsonEncode(message.data),
        NotificationDetails(android: _androidNotificationDetails));
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

void onDidReceiveNotificationResponse(details) async {
  if (details.payload != null) {
    try {
      Map<String, dynamic> notificationPayload = jsonDecode(details.payload!);
      setNotificationHandler(notificationPayload);
    } catch (error) {
      debugPrint('mmm Notification payload error $error');
    }
  }
}
