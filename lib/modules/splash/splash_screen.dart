import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/fonts.dart';
import 'package:uapp/app/strings.dart';
import 'package:uapp/modules/splash/splash_controller.dart';

class SplashScren extends StatelessWidget {
  const SplashScren({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          body: Center(
            child: Text(
              Strings.appTitle,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontFamily: Fonts.rubik,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
            ),
          ),
        );
      },
    );
  }
}
