import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uapp/core/background_service/alarm_id.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/hive/hive_service.dart';
import 'package:uapp/core/notification/notif_id.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/notification/notification.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/api/api_client.dart';
import 'package:uapp/modules/marketing/api/sync_marketing_activity_api.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/modules/approval/approval_api.dart';
import 'package:uapp/core/notification/notification_handler.dart';

class AlarmManager {
  static Future<void> init() async {
    await AndroidAlarmManager.initialize();
  }

  static void scheduleUploadDataMA() {
    const int alarmId = AlarmId.marketingPeriodic;
    AndroidAlarmManager.periodic(
      const Duration(minutes: 10),
      alarmId,
      _uploadDataMarketing,
      allowWhileIdle: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  static uploadDataMA() {
    const int alarmId = AlarmId.marketingPeriodic;
    AndroidAlarmManager.oneShot(
      const Duration(seconds: 5),
      alarmId,
      _uploadDataMarketing,
      exact: true,
    );
  }

  static void _uploadDataMarketing() async {
    await HiveService.init();
    final db = MarketingDatabase();
    final api = MarketingApiClient();
    final sync = SyncMarketingActivityApi(api: api, db: db);
    if (await Utils.isInternetAvailable()) {
      HiveService.setTimerSyncMkt(DateTime.now().millisecondsSinceEpoch);
      await sync.syncMarketingActivity();
    } else {
      showNotification(
        NotifId.MKT_SYNC_CH_ID,
        NotifId.MKT_SYNC_CH_NAME,
        NotifId.MKT_SYNC_ID,
        'Sinkronisasi Data',
        'Tidak ada koneksi internet yang tersedia',
      );
    }
  }

  static void updateLocation() {
    const int alarmId = AlarmId.location;
    AndroidAlarmManager.periodic(
      const Duration(seconds: 10),
      alarmId,
      _updateLocation,
      allowWhileIdle: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    ).then((value) {
      Log.d('Alarm location berhasil dijalankan $value');
    });
  }

  static void _updateLocation() async {
    await HiveService.init();
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    sendLocationToAPI(position);
    // showNotification(
    //   NotifId.USER_LOC_CH_ID,
    //   NotifId.USER_LOC_CH_NAME,
    //   NotifId.USER_LOC_ID,
    //   'Aplikasi Berjalan',
    //   'Aplikasi sedang berjalan di latar belakang',
    // );
  }

  static void scheduleApprovalCheck() {
    Log.d('AlarmManager: scheduleApprovalCheck called');
    const int alarmId = AlarmId.approvalPeriodic;
    AndroidAlarmManager.periodic(
      const Duration(minutes: 15), // Interval periodik
      alarmId,
      _checkApprovalData,
      allowWhileIdle: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  static void _checkApprovalData() async {
    try {
      final userId = Utils.getUserData().id;
      if (userId.isNotEmpty) {
        final approvalData = await ApprovalApi.getApprovalData(userId);
        if (approvalData != null && approvalData.isNotEmpty) {
          Log.d('AlarmManager: New approval data found (${approvalData.length} items)');
          NotificationHandler.showFallbackNotification(approvalData.length);
        } else {
          Log.d('AlarmManager: No new approval data found');
        }
      } else {
        Log.d('AlarmManager: User ID is empty');
      }
    } catch (e) {
      Log.d('AlarmManager: Error while checking approval data - $e');
    }
  }

  static Future<void> cancelAllAlarm() async {
    await AndroidAlarmManager.cancel(AlarmId.marketingPeriodic);
    await AndroidAlarmManager.cancel(AlarmId.location);
  }
}

Future<void> sendLocationToAPI(Position position) async {
  String apiUrl = HiveService.baseUrl();
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "action": "location_track",
        "nik": Utils.getUserData().id,
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString(),
        "mocked": position.isMocked.toString(),
      },
    );

    if (response.statusCode == 200) {
      Log.d("Lokasi berhasil dikirimb");
    } else {
      Log.d("Gagal mengirim lokasi: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    Log.d("Terjadi kesalahan saat mengirim lokasi: $e");
  }
}
