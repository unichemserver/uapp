import 'package:geolocator/geolocator.dart';
import 'package:uapp/core/hive/hive_service.dart';
import 'package:uapp/core/notification/notif_id.dart';
import 'package:uapp/core/notification/notification.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:http/http.dart' as http;

class LocationWorker {
  static Future<void> updateLocation() async {
    try {
      await HiveService.init();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      sendLocationToAPI(position);
      showNotification(
        NotifId.USER_LOC_CH_ID,
        NotifId.USER_LOC_CH_NAME,
        NotifId.USER_LOC_ID,
        'Aplikasi Berjalan',
        'Aplikasi sedang berjalan di latar belakang',
        ongoing: true,
      );
    } catch(e) {
      Log.d('Terjadi kesalahan saat mengambil lokasi: $e');
    }
  }

  static Future<void> sendLocationToAPI(Position position) async {
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
        Log.d("Lokasi berhasil dikirim");
      } else {
        Log.d("Gagal mengirim lokasi: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      Log.d("Terjadi kesalahan saat mengirim lokasi: $e");
    }
  }
}