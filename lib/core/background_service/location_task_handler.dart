import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:uapp/core/hive/hive_service.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:uapp/core/utils/utils.dart';

class LocationTaskHandler extends TaskHandler {
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    Log.d('Foreground service stopped at $timestamp');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    Log.d('Foreground service repeated at $timestamp');
    _sendLocationToServer();
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    Log.d('Foreground service started at $timestamp');
    _sendLocationToServer();
  }

  Future<void> _sendLocationToServer() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      Log.d('Lokasi saat ini: ${position.latitude}, ${position.longitude}');
      // Replace with your API endpoint.
      String apiUrl = HiveService.baseUrl();
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
        Log.d("Lokasi berhasil dikirims");
      } else {
        Log.d(
          "Gagal mengirim lokasi: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      Log.d("Terjadi kesalahan saat mengirim lokasi: $e");
    }
  }
}
