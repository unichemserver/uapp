import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/app/strings.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class UApp extends StatelessWidget {
  const UApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey, // Use global navigatorKey
      title: Strings.appTitle,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          secondary: Colors.lightBlue,
          primary: Colors.blueAccent,
          surface: Colors.white,
        ),
        useMaterial3: true,
      ),
      initialRoute: Routes.INITIAL,
      getPages: Routes.pages,
      defaultTransition: Transition.cupertino, 
      debugShowCheckedModeBanner: false, 
    );
  }
}