// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:uapp/modules/auth/auth_binding.dart';
import 'package:uapp/modules/auth/auth_screen.dart';
import 'package:uapp/modules/home/home_binding.dart';
import 'package:uapp/modules/home/home_screen.dart';
import 'package:uapp/modules/home/pages/change_password_page.dart';
import 'package:uapp/modules/home/pages/sync_page.dart';
import 'package:uapp/modules/hr/hr_menu_page.dart';
import 'package:uapp/modules/marketing/marketing_binding.dart';
import 'package:uapp/modules/marketing/marketing_screen.dart';
import 'package:uapp/modules/marketing/pages/canvasing/canvasing_binding.dart';
import 'package:uapp/modules/marketing/pages/canvasing/canvasing_page.dart';
import 'package:uapp/modules/report/report_binding.dart';
import 'package:uapp/modules/report/report_screen.dart';
import 'package:uapp/modules/splash/permission_screen.dart';
import 'package:uapp/modules/splash/splash_binding.dart';
import 'package:uapp/modules/splash/splash_screen.dart';

class Routes {
  static const String INITIAL = '/';
  static const String HOME = '/home';
  static const String AUTH = '/auth';
  static const String MARKETING = '/marketing';
  static const String REPORT = '/report';
  static const String CANVASING = '/canvasing';
  static const String PERMISSION = '/permission';
  static const String SYNC = '/sync';
  static const String HR = '/hr';
  static const String CHANGE_PASSWORD = '/change-password';

  static List<GetPage> pages = [
    GetPage(
      name: INITIAL,
      page: () => SplashScren(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AUTH,
      page: () => AuthScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: MARKETING,
      page: () => MarketingScreen(),
      binding: MarketingBinding(),
    ),
    GetPage(
      name: REPORT,
      page: () => ReportScreen(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: CANVASING,
      page: () => CanvasingPage(),
      binding: CanvasingBinding(),
    ),
    GetPage(
      name: PERMISSION,
      page: () => PermissionScreen(),
    ),
    GetPage(
      name: SYNC,
      page: () => const SyncPage(),
    ),
    GetPage(
      name: HR,
      page: () => const HrMenuPage(),
    ),
    GetPage(
      name: CHANGE_PASSWORD,
      page: () => ChangePasswordPage(),
    ),
  ];
}
