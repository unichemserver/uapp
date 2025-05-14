import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/modules/approval/widget/approval_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:uapp/app/app.dart'; // Import navigatorKey from app.dart

class NotificationHandler {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions for iOS
    await messaging.requestPermission();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Log.d('FCM: Received message in foreground: ${message.notification?.title}');
      _showNotification(message);
    });

    // Handle background messages
    // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    //   Log.d('FCM: Received message in background: ${message.notification?.title}');
    //   await _showNotification(message);
    // });


    // Handle background and terminated messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Log.d('FCM: Notification clicked');
      _handleNotificationClick(message);
    });

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        _navigateToApprovalPage(payload);
      }
    });
  }



  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'approval_channel',
      'Approval Notifications',
      channelDescription: 'Notifications for new approvals',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data['approvalId'], // Pass approval ID as payload
    );
  }

  static Future<void> showFallbackNotification(int count) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'approval_channel',
      'Approval Notifications',
      channelDescription: 'Notifications for new approvals',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch,
      'New Approvals',
      '$count new approvals are available.',
      platformChannelSpecifics,
    );
  }

  static void _handleNotificationClick(RemoteMessage message) {
    String? approvalId = message.data['approvalId'];
    if (approvalId != null) {
      _navigateToApprovalPage(approvalId);
    }
  }

  static void _navigateToApprovalPage(String approvalId) {
    // Navigate to Approval Data Screen
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => ApprovalDataScreen(),
      ),
    );
  }
}
