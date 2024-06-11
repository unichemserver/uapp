import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/no_connection_dialog.dart';
import 'package:uapp/models/user.dart';
import 'package:http/http.dart' as http;

class SplashController extends GetxController {
  final box = Hive.box(HiveKeys.appBox);
  bool _isLogged = false;

  @override
  void onInit() {
    super.onInit();
    _checkLogin();
  }

  void _checkLogin() {
    _isLogged = box.get(HiveKeys.userData) != null;
    var isFirstTime = box.get(HiveKeys.isFirstTime, defaultValue: true);

    Future.delayed(const Duration(seconds: 2), () {
      if (isFirstTime) {
        Get.offNamed(Routes.PERMISSION);
      } else {
        if (_isLogged) {
          _checkInternetAvailability();
        } else {
          Get.offNamed(Routes.AUTH);
        }
      }
    });
  }

  void _checkInternetAvailability() async {
    bool isInternetAvailable = await Utils.isInternetAvailable();
    if (isInternetAvailable) {
      _checkPasswordStatus();
    } else {
      Get.dialog(NoConnectionDialog(
        onOkPressed: () {
          Get.back();
          onInit();
        },
      ));
    }
  }

  void _checkPasswordStatus() async {
    try {
      var userDataJson = box.get(HiveKeys.userData, defaultValue: null);
      print(userDataJson);
      if (userDataJson == null) {
        throw Exception("User data is null");
      }

      var userData = User.fromJson(jsonDecode(userDataJson));
      print(userData.toJson());

      var baseUrlString = box.get(HiveKeys.baseURL, defaultValue: null);
      if (baseUrlString == null) {
        throw Exception("Base URL is null");
      }

      var baseUrl = Uri.parse(baseUrlString);
      print(baseUrl);

      var response = await http.post(baseUrl, body: {
        'action': 'getuserpassword',
        'user_id': userData.id ?? '',
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var status = responseBody['status'];

        if (status == "1") {
          Get.offNamed(Routes.HOME);
        } else {
          Get.offNamed(Routes.CHANGE_PASSWORD);
        }
      } else {
        Get.snackbar('Error', 'Terjadi kesalahan saat mengambil data');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString());
    }
  }

}
