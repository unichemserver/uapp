// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:uapp/modules/auth/auth_binding.dart';
import 'package:uapp/modules/auth/auth_screen.dart';
import 'package:uapp/modules/chat/chat_binding.dart';
import 'package:uapp/modules/chat/chat_screen.dart';
import 'package:uapp/modules/chat/pages/contact_page.dart';
import 'package:uapp/modules/home/home_binding.dart';
import 'package:uapp/modules/home/home_screen.dart';
import 'package:uapp/modules/home/pages/change_password_page.dart';
import 'package:uapp/modules/home/pages/sync_page.dart';
import 'package:uapp/modules/hr/hr_menu_page.dart';
import 'package:uapp/modules/marketing/marketing_binding.dart';
import 'package:uapp/modules/marketing/marketing_screen.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/canvasing_binding.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/canvasing_page.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_binding.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_page.dart';
import 'package:uapp/modules/memo/memo_utils.dart';
import 'package:uapp/modules/profile/profile_binding.dart';
import 'package:uapp/modules/profile/profile_screen.dart';
import 'package:uapp/modules/report/report_binding.dart';
import 'package:uapp/modules/report/report_screen.dart';
import 'package:uapp/modules/settings/setting_binding.dart';
import 'package:uapp/modules/settings/setting_screen.dart';
import 'package:uapp/modules/splash/splash_binding.dart';
import 'package:uapp/modules/splash/splash_screen.dart';

class Routes {
  static const String INITIAL = '/';
  static const String HOME = '/home';
  static const String AUTH = '/auth';
  static const String MARKETING = '/marketing';
  static const String REPORT = '/report';
  static const String CANVASING = '/canvasing';
  static const String NOO = '/noo';
  static const String PERMISSION = '/permission';
  static const String SYNC = '/sync';
  static const String HR = '/hr';
  static const String CHANGE_PASSWORD = '/change-password';
  static const String PROFILE = '/profile';
  static const String CHAT = '/chat';
  static const String CONTACT = '/contact';
  static const String SETTING = '/setting';

  static List<GetPage> pages = [
    GetPage(
      name: INITIAL,
      page: () => SplashScreen(),
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
    GetPage(
      name: PROFILE,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: CHAT,
      page: () => const ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: CONTACT,
      page: () => ContactPage(),
    ),
    GetPage(
      name: SETTING,
      page: () => SettingScreen(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: NOO,
      page: () => NooPage(),
      binding: NooBinding(),
    ),
    ...createdMemoList.map((e) => GetPage(
          name: '/${e.name.replaceAll(' ', '_').toLowerCase()}',
          page: () => e.page,
        )),
  ];
}
