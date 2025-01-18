import 'package:flutter/material.dart';
import 'package:uapp/core/utils/menu_utils.dart';
import 'package:uapp/models/menu.dart';
import 'package:uapp/modules/webview/webview_screen.dart';

class ListSubMenu extends StatelessWidget {
  const ListSubMenu({
    super.key,
    required this.index,
    required this.selectedService,
    required this.masterServices,
    required this.transactionService,
    required this.reportService,
  });

  final int index;
  final int selectedService;
  final MenuData? masterServices;
  final MenuData? transactionService;
  final MenuData? reportService;

  Icon getIcon(String iconName) {
    const defaultColor = Colors.blueAccent;
    final iconMap = {
      'purchasing': Icons.shopping_cart,
      'distribusi': Icons.local_shipping,
      'dokumen transfer profile': Icons.people,
      'profile': Icons.person,
      'financial': Icons.account_balance,
      'memo': Icons.note,
      'security': Icons.security,
      'menu & roles': Icons.menu_book,
      'hrd': Icons.business_center,
      'production': Icons.factory,
      'marketing': Icons.mark_email_read,
      'transaction': Icons.monetization_on,
      'it': Icons.computer,
      'change entity': Icons.swap_horiz,
      'menus & roles': Icons.menu_book,
      'iso': Icons.verified_user,
    };

    return Icon(
      iconMap[iconName.toLowerCase()] ?? Icons.menu,
      color: defaultColor,
    );
  }

  void _onTapMenu(String url, String title, BuildContext context) {
    if (routeToPage(url, context)) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: url,
          title: title,
        ),
      ),
    );
  }

  ListTile _buildListTile(
    String namaMenu,
    String urlMenu,
    BuildContext context,
  ) {
    return ListTile(
      leading: getIcon(namaMenu),
      title: Text(namaMenu),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
      onTap: () => _onTapMenu(urlMenu, namaMenu, context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuData = selectedService == 1
        ? masterServices
        : selectedService == 2
            ? transactionService
            : reportService;

    if (menuData == null) {
      return const SizedBox.shrink();
    }

    final submenu = menuData.submenu[index];
    final namaMenu = submenu.namaMenu.replaceAll('amp;', '');

    if (submenu.subsubmenu.isEmpty) {
      return _buildListTile(namaMenu, submenu.urlMenu, context);
    }

    return ExpansionTile(
      leading: getIcon(namaMenu),
      title: Text(namaMenu),
      children: submenu.subsubmenu.map((e) {
        return _buildListTile(e.namaMenu, e.urlMenu, context);
      }).toList(),
    );
  }
}
