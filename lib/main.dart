import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uapp/app/app.dart';
import 'package:uapp/core/background_service/location_task_handler.dart';
import 'package:uapp/core/background_service/work_manager.dart';
import 'package:uapp/core/hive/hive_service.dart';
import 'package:uapp/core/notification/notification.dart';
import 'package:uapp/core/firebase/firebase_options.dart';
import 'package:workmanager/workmanager.dart';
import 'core/firebase/crashlytics_service.dart';
import 'core/background_service/alarm_manager.dart';
import 'core/utils/log.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await crashlyticsService.init();
    FlutterError.onError = (FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterError(details);
    };

    await initializeDateFormatting('id_ID', null);
    await AlarmManager.init();
    await initializeNotifications();
    await HiveService.init();
    await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
    // FlutterForegroundTask.initCommunicationPort();
    Workmanager().initialize(callbackDispatcher);


    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    runApp(const UApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}
