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
      elevation: 0, // Mengurangi shadow untuk tampilan lebih modern
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(), // Menambahkan efek scroll yang smooth
              children: _buildDrawerMenu(context),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 24, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(foto),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        jabatan,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      department.replaceAll('amp;', ''),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDrawerMenu(BuildContext context) {
    return [
      const SizedBox(height: 16),
      _buildMenuSection('Menu Utama', context),
      const SizedBox(height: 8),
      if (isMenuAvailable('Document'))
        _buildMenuTile(
          context,
          title: 'Document',
          icon: Icons.description_outlined,
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
        _buildMenuTile(
          context,
          title: 'HR Form Submission',
          icon: Icons.assignment_outlined,
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
            return _buildMenuTile(
              context,
              title: 'Approval',
              icon: Icons.approval_outlined,
              onTap: () {
                Get.toNamed(Routes.APPROVAL);
              },
            );
          }
          return const SizedBox();
        },
      ),
      if (ctx.showMarketingMenu()) const MarketingDrawer(),
      const SizedBox(height: 16),
      _buildMenuSection('Personal', context),
      const SizedBox(height: 8),
      _buildMenuTile(
        context,
        title: 'Profil',
        icon: Icons.person_outlined,
        onTap: () {
          Get.toNamed(Routes.PROFILE);
        },
      ),
    ];
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    final color = isActive 
        ? Theme.of(context).primaryColor 
        : Colors.grey.shade700;
        
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isActive 
            ? Theme.of(context).primaryColor.withOpacity(0.1) 
            : Colors.transparent,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        leading: Icon(
          icon,
          color: color,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {
          scaffoldKey.currentState?.closeDrawer();
          onTap();
        },
      ),
    );
  }

  Widget _buildMenuSection(String title, BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 24, right: 24),
      child: Text(
        title.toUpperCase(),
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'v2.0.0',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}