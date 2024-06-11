import 'package:flutter/foundation.dart';

class Log {
  static void d(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}