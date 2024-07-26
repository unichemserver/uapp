import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/models/menu.dart';
import 'package:uapp/modules/home/home_controller.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/history_canvasing_screen.dart';
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
    return ListView(
      children: [
        SizedBox(
          width: double.infinity,
          child: DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
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
        ),
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
                        title: 'Orlansoft',
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
                        title: 'Webmail',
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
                        title: 'News & Event',
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
            ? Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 16),
                    child: Text(
                      'Marketing',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ExpansionTile(
                    title: const Text('Kunjungan'),
                    leading: const Icon(Icons.location_on),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: ListTile(
                          title: const Text('On Route'),
                          leading: const Icon(Icons.location_on),
                          onTap: () {
                            Get.toNamed(Routes.MARKETING);
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: ExpansionTile(
                          title: const Text('Off Route'),
                          leading: const Icon(Icons.location_off),
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 16),
                              child: ListTile(
                                title: const Text('Customer Active'),
                                leading: const Icon(Icons.group_add_outlined),
                                onTap: (){},
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 16),
                              child: ListTile(
                                title: const Text('New Opening Outlet'),
                                leading: const Icon(Icons.add_location_alt_outlined),
                                onTap: () {
                                  Get.toNamed(Routes.NOO);
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 16),
                              child: ListTile(
                                title: const Text('Canvasing'),
                                leading: const Icon(Icons.manage_search),
                                onTap: () {
                                  Get.to(() => const HistoryCanvasingScreen());
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  ListTile(
                    title: const Text('Sinkronisasi Data'),
                    leading: const Icon(Icons.sync),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Sinkronisasi Data'),
                          content: const Text(
                              'Apakah anda yakin ingin melakukan sinkronisasi data?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                bool isDrawerOpen =
                                    scaffoldKey.currentState?.isDrawerOpen ??
                                        false;
                                if (isDrawerOpen) {
                                  scaffoldKey.currentState?.closeDrawer();
                                }
                                ctx.performSyncOperation();
                              },
                              child: const Text('Ya'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )
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
          title: const Text('Chat'),
          leading: const Icon(Icons.chat),
          onTap: () {
            Get.toNamed(Routes.CHAT);
          },
        ),
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
