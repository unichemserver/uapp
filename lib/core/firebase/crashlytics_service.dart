import 'package:firebase_crashlytics/firebase_crashlytics.dart';

final crashlyticsService = CrashlyticsService();

class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  // Inisialisasi Crashlytics
  Future<void> init() async {
    // Mengaktifkan logging non-fatal errors
    await _crashlytics.setCrashlyticsCollectionEnabled(true);
  }

  // Rekam error non-fatal
  void logError(Exception exception, StackTrace stackTrace) {
    _crashlytics.recordError(exception, stackTrace);
  }

  // Rekam log custom
  void logCustomMessage(String message) {
    _crashlytics.log(message);
  }

  // Paksa crash untuk testing
  void crashApp() {
    _crashlytics.crash();
  }
}