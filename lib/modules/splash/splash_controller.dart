import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/fake_gps_checker.dart';

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
    _getFCMToken();
  }

  void _getFCMToken() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? fcmToken = await firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');
  }

  void initAnimation() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 1, end: 0.5).animate(
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

  void _checkLogin() async {
    _isLogged = box.get(HiveKeys.userData) != null;
    bool isFakeGpsInstalled = await FakeGpsChecker.isFakeGpsInstalled();
    bool isUsingMockLocation = await FakeGpsChecker.isMockLocationEnabled();

    Future.delayed(const Duration(seconds: 2), () {
      if (isFakeGpsInstalled || isUsingMockLocation) {
        Get.dialog(
          PopScope(
            canPop: true,
            child: AlertDialog(
              title: const Text('Warning'),
              content: const Text('Anda terdeteksi menggunakan Fake GPS atau Mock Location'),
              actions: [
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      } else {
        if (_isLogged) {
          Get.offNamed(Routes.HOME);
        } else {
          Get.offNamed(Routes.AUTH);
        }
      }
    });
  }

  @override
  void onClose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.onClose();
  }
}
