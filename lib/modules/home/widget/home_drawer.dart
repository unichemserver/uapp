import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/models/menu.dart';
import 'package:uapp/modules/home/home_controller.dart';
import 'package:uapp/modules/home/widget/marketing_drawer.dart';
import 'package:uapp/modules/webview/webview_screen.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({
    super.key,
    required this.name,
    required this.jabatan,
    required this.department,
    required this.foto,
    required this.menus,
    required this.scaffoldKey,
  });

  final String name;
  final String jabatan;
  final String department;
  final String foto;
  final List<MenuData> menus;
  final ctx = Get.put(HomeController());
  final GlobalKey<ScaffoldState> scaffoldKey;

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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Text(
                jabatan,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                department.replaceAll('amp;', ''),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 16),
                child: Text(
                  'Menu Utama',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                              title: 'Document',
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
                  ? const MarketingDrawer()
                  : const SizedBox(),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 16),
                child: Text(
                  'Personal',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Profil'),
                leading: const Icon(Icons.person),
                onTap: () {
                  Get.toNamed(Routes.PROFILE);
                },
              ),
              ListTile(
                title: const Text('Approval'),
                leading: const Icon(Icons.approval),
                onTap: () {
                  Get.toNamed(Routes.APPROVAL);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
