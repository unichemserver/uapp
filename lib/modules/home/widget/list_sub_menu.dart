import 'package:flutter/material.dart';
import 'package:uapp/core/utils/menu_utils.dart';
import 'package:uapp/models/menu.dart';
import 'package:uapp/modules/webview/webview_screen.dart';

class ListSubMenu extends StatelessWidget {
  ListSubMenu({
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
    Color defaultColor = Colors.blueAccent;
    switch (iconName.toLowerCase()) {
      case 'purchasing':
        return Icon(Icons.shopping_cart, color: defaultColor);
      case 'distribusi':
        return Icon(Icons.local_shipping, color: defaultColor);
      case 'dokumen transfer profile':
        return Icon(Icons.swap_horiz, color: defaultColor);
      case 'profile':
        return Icon(Icons.person, color: defaultColor);
      case 'financial':
        return Icon(Icons.account_balance, color: defaultColor);
      case 'memo':
        return Icon(Icons.note, color: defaultColor);
      case 'security':
        return Icon(Icons.security, color: defaultColor);
      case 'menu & roles':
        return Icon(Icons.menu_book, color: defaultColor);
      case 'hrd':
        return Icon(Icons.business_center, color: defaultColor);
      case 'production':
        return Icon(Icons.factory, color: defaultColor);
      case 'marketing':
        return Icon(Icons.mark_email_read, color: defaultColor);
      default:
        return Icon(Icons.menu, color: defaultColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedService == 1 &&
        masterServices!.submenu[index].subsubmenu.isEmpty) {
      String namaMenu = masterServices!.submenu[index].namaMenu.replaceAll(
        'amp;',
        '',
      );
      return ListTile(
        leading: getIcon(namaMenu),
        title: Text(namaMenu),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: () {
          if (routeToPage(masterServices!.submenu[index].urlMenu, context)) {
            print('route to page');
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(
                url: masterServices!.submenu[index].urlMenu,
                title: masterServices!.submenu[index].namaMenu,
              ),
            ),
          );
        },
      );
    }
    if (selectedService == 2 &&
        transactionService!.submenu[index].subsubmenu.isEmpty) {
      String namaMenu = transactionService!.submenu[index].namaMenu.replaceAll(
        'amp;',
        '',
      );
      return ListTile(
        leading: getIcon(namaMenu),
        title: Text(namaMenu),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: () {
          if (routeToPage(transactionService!.submenu[index].urlMenu, context)) {
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(
                url: transactionService!.submenu[index].urlMenu,
                title: transactionService!.submenu[index].namaMenu,
              ),
            ),
          );
        },
      );
    }
    if (selectedService == 3 &&
        reportService!.submenu[index].subsubmenu.isEmpty) {
      String namaMenu = reportService!.submenu[index].namaMenu.replaceAll(
        'amp;',
        '',
      );
      return ListTile(
        leading: getIcon(namaMenu),
        title: Text(namaMenu),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: () {
          if (routeToPage(reportService!.submenu[index].urlMenu, context)) {
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(
                url: reportService!.submenu[index].urlMenu,
                title: reportService!.submenu[index].namaMenu,
              ),
            ),
          );
        },
      );
    }
    return ExpansionTile(
      leading: getIcon(selectedService == 1
          ? masterServices!.submenu[index].namaMenu.replaceAll(
              'amp;',
              '',
            )
          : selectedService == 2
              ? transactionService!.submenu[index].namaMenu.replaceAll(
                  'amp;',
                  '',
                )
              : reportService!.submenu[index].namaMenu.replaceAll('amp;', '')),
      title: Text(
        selectedService == 1
            ? masterServices!.submenu[index].namaMenu.replaceAll(
                'amp;',
                '',
              )
            : selectedService == 2
                ? transactionService!.submenu[index].namaMenu.replaceAll(
                    'amp;',
                    '',
                  )
                : reportService!.submenu[index].namaMenu.replaceAll(
                    'amp;',
                    '',
                  ),
      ),
      children: selectedService == 1
          ? masterServices!.submenu[index].subsubmenu
              .map((e) => ListTile(
                    onTap: () {
                      if (routeToPage(e.urlMenu, context)) {
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            url: e.urlMenu,
                            title: e.namaMenu,
                          ),
                        ),
                      );
                    },
                    leading: const SizedBox(width: 20),
                    title: Text(e.namaMenu),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ))
              .toList()
          : selectedService == 2
              ? transactionService!.submenu[index].subsubmenu
                  .map((e) => ListTile(
                        onTap: () {
                          if (routeToPage(e.urlMenu, context)) {
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                url: e.urlMenu,
                                title: e.namaMenu,
                              ),
                            ),
                          );
                        },
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                        leading: const SizedBox(width: 20),
                        title: Text(e.namaMenu),
                      ))
                  .toList()
              : reportService!.submenu[index].subsubmenu
                  .map((e) => ListTile(
                        onTap: () {
                          if (routeToPage(e.urlMenu, context)) {
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                url: e.urlMenu,
                                title: e.namaMenu,
                              ),
                            ),
                          );
                        },
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                        leading: const SizedBox(width: 20),
                        title: Text(e.namaMenu),
                      ))
                  .toList(),
    );
  }
}
