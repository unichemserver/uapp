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
  final Future<bool> _approvalAccessFuture = Get.find<HomeController>().hasApprovalAccess();

  bool isMenuAvailable(String menuName) {
    return menus.any((menu) => menu.namaMenu.toLowerCase() == menuName.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return _buildDrawer(context);

  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _buildDrawerMenu(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(foto),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    jabatan,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    department.replaceAll('amp;', ''),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDrawerMenu(BuildContext context) {
    return [
      _buildMenuSection('Menu Utama', context),
      if (isMenuAvailable('Document'))
        ListTile(
          title: const Text('Document'),
          leading: const Icon(Icons.description),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewScreen(
                  url: menus.firstWhere((element) =>
                          element.namaMenu.toLowerCase().contains('document'))
                      .urlMenu,
                  title: 'Document',
                ),
              ),
            );
          },
        ),
      if (isMenuAvailable('HR Form Submission'))
        ListTile(
          title: const Text('HR Form Submission'),
          leading: const Icon(Icons.assignment),
          onTap: () {
            Get.toNamed(Routes.HR);
          },
        ),
        FutureBuilder<bool>(
        future: _approvalAccessFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          if (snapshot.hasData && snapshot.data == true) {
            return ListTile(
              title: const Text('Approval'),
              leading: const Icon(Icons.approval),
              onTap: () {
                Get.toNamed(Routes.APPROVAL);
              },
            );
          }
          return const SizedBox();
        },
      ),
      if (ctx.showMarketingMenu()) const MarketingDrawer(),
      _buildMenuSection('Personal', context),
      ListTile(
        title: const Text('Profil'),
        leading: const Icon(Icons.person),
        onTap: () {
          Get.toNamed(Routes.PROFILE);
        },
      ),
    ];
  }

  Widget _buildMenuSection(String title, BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, top: 8),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }
}
