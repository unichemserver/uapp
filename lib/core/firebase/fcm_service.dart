import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/background_service/alarm_manager.dart';
import 'package:uapp/core/utils/utils.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> sendTokenToServer(String token) async {
    try {
      await http.post(
        Uri.parse(Utils.getBaseUrl()),
        body: {
          'action': 'upd_fcm_token',
          'nik': Utils.getUserData().id,
          'fcm_token': token,
        },
      );
    } catch (e) {
      print('Failed to send token to server: $e');
    }
  }

  Future<void> initialize() async {
    var token = await getFCMToken();
    if (token != null) {
      sendTokenToServer(token);
    }
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User denied permission');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var data = message.data;
      if (data['action'] != null) {
        switch (data['action']) {
          case 'sync_data_mkt':
            AlarmManager.uploadDataMA();
            break;
          case 'activate_location':
            Geolocator.requestPermission();
            break;
          case 'get_status_device':
            // send status device
            break;
          case 'get_db':
            
            break;
          default:
            break;
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onLaunch/onResume: ${message.messageId}");
    });
  }
}
