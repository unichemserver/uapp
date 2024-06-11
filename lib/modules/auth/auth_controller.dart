import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/sync/sync_api_service.dart';
import 'package:uapp/core/sync/sync_manager.dart';
import 'package:uapp/core/utils/instance.dart';
import 'package:uapp/modules/auth/auth_api.dart';

class AuthController extends GetxController {
  final box = Hive.box(HiveKeys.appBox);
  bool _isPasswordVisible = false;
  String? _selectedInstance;
  String? _loadingMessage;

  bool get isPasswordVisible => _isPasswordVisible;
  String? get selectedInstance => _selectedInstance;
  String? get loadingMessage => _loadingMessage;

  void setSelectedInstance(String? value) {
    box.put(HiveKeys.baseURL, instances[value]);
    _selectedInstance = value;
    update();
  }

  void setLoadingMessage(String? value) {
    _loadingMessage = value;
    update();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    update();
  }

  login(String username, String password) {
    final url = box.get(HiveKeys.baseURL);
    setLoadingMessage('Login...');
    AuthApi.login(url, username, password).then((user) {
      if (user != null) {
        setLoadingMessage('Sinkronisasi...');
        box.put(HiveKeys.userData, json.encode(user.toJson()));
        Get.snackbar(
          'Login Berhasil',
          'Selamat datang ${user.namaPanggilan}',
        );
        Get.offAllNamed(Routes.HOME);
      } else {
        setLoadingMessage(null);
        Get.back();
        Get.snackbar(
          'Login Gagal',
          'Username atau password salah',
        );
      }
    });
  }
}
