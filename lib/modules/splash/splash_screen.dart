import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/fonts.dart';
import 'package:uapp/app/strings.dart';
import 'package:uapp/modules/splash/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          body: Center(
            child: AnimatedBuilder(
              animation: controller.scaleAnimation,
              builder: (context, child) {
                return ScaleTransition(
                  scale: controller.scaleAnimation,
                  child: AnimatedBuilder(
                    animation: controller.fadeAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: controller.fadeAnimation,
                        child: Text(
                          Strings.appTitle,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: Fonts.openSans,
                            fontWeight: FontWeight.bold,
                            fontSize: width / 5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}