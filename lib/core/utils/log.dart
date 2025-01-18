import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Log {
  static void d(String message) {
    var now = DateTime.now();
    if (kDebugMode) {
      print("[DEBUG] $now: $message");
    }
  }

  static void s(String message) {
    var now = DateTime.now();
    var formatter = DateFormat('yyyyMMdd');
    var fileName = 'log_${formatter.format(now)}.txt';
    var logMessage = "${DateTime.now()}: $message\n";

    var logFile = File(fileName);
    logFile.writeAsStringSync(logMessage, mode: FileMode.append);
  }

}