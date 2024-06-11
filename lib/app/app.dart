import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/app/strings.dart';

class UApp extends StatelessWidget {
  const UApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Strings.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          secondary: Colors.lightBlue,
          primary: Colors.blueAccent,
          background: Colors.white,
        ),
        useMaterial3: true,
      ),
      initialRoute: Routes.INITIAL,
      getPages: Routes.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}