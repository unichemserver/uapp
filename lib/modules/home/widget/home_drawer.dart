import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/models/menu.dart';
import 'package:uapp/modules/home/home_controller.dart';
import 'package:uapp/modules/home/widget/logout_dialog.dart';
import 'package:uapp/modules/webview/webview_screen.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key, required this.name, required this.menus});

  final String name;
  final List<MenuData> menus;
  final ctx = Get.put(HomeController());

  bool isMenuAvailable(String menuName) {
    for (var menu in menus) {
      if (menu.namaMenu.toLowerCase() == menuName.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
        isMenuAvailable('Orlansoft')
            ? ListTile(
                title: const Text('Orlansoft'),
                leading: const Icon(Icons.home),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: menus
                            .firstWhere(
                              (element) =>
                                  element.namaMenu.toLowerCase().contains(
                                        'orlansoft',
                                      ),
                            )
                            .urlMenu,
                      ),
                    ),
                  );
                },
              )
            : const SizedBox(),
        isMenuAvailable('Webmail')
            ? ListTile(
                title: const Text('Webmail'),
                leading: const Icon(Icons.email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: menus
                            .firstWhere(
                              (element) =>
                                  element.namaMenu.toLowerCase().contains(
                                        'webmail',
                                      ),
                            )
                            .urlMenu,
                      ),
                    ),
                  );
                },
              )
            : const SizedBox(),
        isMenuAvailable('NEWS &amp; EVENT')
            ? ListTile(
                title: const Text('News & Event'),
                leading: const Icon(Icons.event),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: menus
                            .firstWhere(
                              (element) =>
                                  element.namaMenu.toLowerCase().contains(
                                        'news',
                                      ),
                            )
                            .urlMenu,
                      ),
                    ),
                  );
                },
              )
            : const SizedBox(),
        isMenuAvailable('Document')
            ? ListTile(
                title: const Text('Document'),
                leading: const Icon(Icons.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: menus
                            .firstWhere(
                              (element) =>
                                  element.namaMenu.toLowerCase().contains(
                                        'document',
                                      ),
                            )
                            .urlMenu,
                      ),
                    ),
                  );
                },
              )
            : const SizedBox(),
        isMenuAvailable('HR Form Submission')
            ? ListTile(
                title: const Text('HR Form Submission'),
                leading: const Icon(Icons.assignment),
                onTap: () {
                  Get.toNamed(Routes.HR);
                },
              )
            : const SizedBox(),
        ctx.showMarketingMenu()
            ? ListTile(
                title: const Text('Marketing'),
                leading: const Icon(Icons.mark_email_read),
                onTap: () {
                  final box = Hive.box(HiveKeys.appBox);
                  final baseUrl = box.get(HiveKeys.baseURL);
                  bool isUnichem = baseUrl.contains('unichem');
                  if (isUnichem) {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Konfirmasi'),
                        content: const Text(
                          'Apakah anda yakin ingin melakukan canvasing?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              box.put(HiveKeys.isCheckIn, true);
                              box.put(HiveKeys.jenisCall, Call.canvasing);
                              Get.toNamed(Routes.CANVASING);
                            },
                            child: const Text('Lanjut'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Get.toNamed(Routes.MARKETING);
                  }
                },
              )
            : const SizedBox(),
        const Spacer(),
        // ListTile(
        //   title: const Text('Logout'),
        //   leading: const Icon(Icons.logout),
        //   onTap: () {
        //     showDialog(
        //       context: context,
        //       builder: (context) => LogoutDialog(),
        //       barrierDismissible: false,
        //     );
        //   },
        // ),
      ],
    );
  }
}
