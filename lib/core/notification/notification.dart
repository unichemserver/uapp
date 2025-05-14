import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

// Tambahkan getter untuk akses global
FlutterLocalNotificationsPlugin get notificationPlugin =>
    flutterLocalNotificationsPlugin;

Future<void> showNotification(
  String channelID,
  String channelName,
  int id,
  String title,
  String body, {
  bool ongoing = false,
  Priority priority = Priority.high,
  Importance importance = Importance.max,
}) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    channelID,
    channelName,
    channelDescription: 'your_channel_description',
    importance: importance,
    priority: priority,
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

// Tambahkan fungsi untuk mendapatkan implementasi spesifik platform
AndroidFlutterLocalNotificationsPlugin? get androidNotificationPlugin =>
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

Future<void> configureFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Dapatkan token perangkat
  String? token = await messaging.getToken();
  print('Device Token: $token');

  // Tangani notifikasi saat aplikasi berjalan di foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      showNotification(
        'approval_channel',
        'Approval Notifications',
        0,
        message.notification!.title ?? 'New Notification',
        message.notification!.body ?? 'You have a new approval.',
      );
    }
  });
}

// Tambahkan handler untuk background message
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Inisialisasi sistem notifikasi lokal
  await initializeNotifications();

  // Tampilkan notifikasi berdasarkan pesan yang diterima
  showNotification(
    'approval_channel', // ID channel
    'Approval Notifications', // Nama channel
    0, // ID notifikasi
    message.notification?.title ?? 'New Notification', // Judul notifikasi
    message.notification?.body ?? 'You have a new approval.', // Isi notifikasi
  );
}

void sendApprovalNotification(int count) {
  showNotification(
    'approval_channel',
    'Approval Notifications',
    0,
    'New Approval Data',
    'You have $count new approval data.',
  );
}
