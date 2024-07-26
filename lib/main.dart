import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uapp/app/app.dart';
import 'package:uapp/core/hive/hive_service.dart';
import 'package:uapp/core/utils/notification.dart';
import 'core/utils/alarm_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await initializeAlarmManager();
  await initializeNotifications();
  await initHive();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  runApp(const UApp());
}
