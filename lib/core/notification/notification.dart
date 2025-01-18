import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_logo');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

Future<void> showNotification(
    String channelID, String channelName, int id, String title, String body,
    {bool ongoing = false}) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    channelID,
    channelName,
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
    ongoing: ongoing,
  );

  NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    id,
    title,
    body,
    platformChannelSpecifics,
    payload: 'payload',
  );
}
