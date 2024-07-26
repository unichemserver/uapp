import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/no_connection_dialog.dart';
import 'package:uapp/models/user.dart';
import 'package:http/http.dart' as http;

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _fadeController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  final box = Hive.box(HiveKeys.appBox);
  bool _isLogged = false;
  Animation<double> get scaleAnimation => _scaleAnimation;
  Animation<double> get fadeAnimation => _fadeAnimation;

  @override
  void onInit() {
    super.onInit();
    initAnimation();
    _checkLogin();
  }

  void initAnimation() {
    _scaleController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.25).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _fadeController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _fadeController.forward();
      }
    });

    _scaleController.forward().then((value) => _fadeController.forward());
  }

  void _checkLogin() {
    _isLogged = box.get(HiveKeys.userData) != null;

    Future.delayed(const Duration(seconds: 4), () {
      if (_isLogged) {
        // _changeStatusBarVisibility();
        _checkInternetAvailability();
      } else {
        Get.offNamed(Routes.AUTH);
      }
    });
  }

  void _changeStatusBarVisibility() {
    if (Utils.isMarketing()) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ));
    }
  }

  void _checkInternetAvailability() async {
    bool isInternetAvailable = await Utils.isInternetAvailable();
    if (Utils.isMarketing()) {
      Get.offNamed(Routes.HOME);
      return;
    }
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
      if (userDataJson == null) {
        throw Exception("User data is null");
      }

      var userData = User.fromJson(jsonDecode(userDataJson));

      var baseUrlString = box.get(HiveKeys.baseURL, defaultValue: null);
      if (baseUrlString == null) {
        throw Exception("Base URL is null");
      }

      var baseUrl = Uri.parse(baseUrlString);
      var response = await http.post(baseUrl, body: {
        'action': 'getuserpassword',
        'user_id': userData.id,
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
        Get.snackbar('Error', 'Terjadi kesalahan saat mengecek status password');
        Get.offNamed(Routes.HOME);
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onClose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.onClose();
  }
}
