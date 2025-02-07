import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/instance.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/auth/auth_api.dart';

class AuthController extends GetxController {
  final box = Hive.box(HiveKeys.appBox);
  bool showInstanceError = false;
  bool _isPasswordVisible = false;
  bool _isAgree = false;
  String? _selectedInstance;
  String? _loadingMessage;

  bool get isPasswordVisible => _isPasswordVisible;
  String? get selectedInstance => _selectedInstance;
  String? get loadingMessage => _loadingMessage;
  bool get isAgree => _isAgree;

  void toggleInstanceSelected(bool value) {
    showInstanceError = value;
    update();
  }

  void toggleAgree(bool value) {
    _isAgree = value;
    update();
  }

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

  Future<void> login(String username, String password) async {
    final url = box.get(HiveKeys.baseURL);
    setLoadingMessage('Login...');

    final User? user = await AuthApi.login(url, username, password);
    if (user == null) {
      setLoadingMessage(null);
      Get.back();
      Get.snackbar(
        'Login Gagal',
        'Username atau password salah',
      );
      return;
    }

    setLoadingMessage('Sinkronisasi...');
    box.put(HiveKeys.userData, json.encode(user.toJson()));

    Get.offAllNamed(Routes.HOME);
    Get.snackbar(
      'Login Berhasil',
      'Selamat datang ${user.namaPanggilan}',
    );
  }
}
