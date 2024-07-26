import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/utils/notification.dart';
import 'package:uapp/core/widget/profile_image.dart';
import 'package:uapp/modules/home/home_controller.dart';
import 'package:uapp/modules/home/widget/home_drawer.dart';
import 'package:uapp/modules/home/widget/list_sub_menu.dart';
import 'package:uapp/modules/home/widget/main_services.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      initState: (_) {},
      builder: (ctx) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(ctx.titleAppbar()),
              leading: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipOval(
                        child: ProfileImage(
                          imgUrl: ctx.foto,
                        ),
                      ),
                    ),
                  );
                },
              ),
              actions: [
                // notification button
                // IconButton(
                //   icon: const Icon(Icons.notifications),
                //   onPressed: () {
                //     showNotification('Notification', 'This is a notification');
                //   },
                // ),
              ],
            ),
            drawer: SafeArea(
              child: Drawer(
                child: HomeDrawer(
                  name: ctx.nama,
                  menus: ctx.menus,
                  jabatan: ctx.userData!.namaJabatan,
                  foto: ctx.foto,
                  department: ctx.userData!.namaDepartment,
                  scaffoldKey: _scaffoldKey,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  MainServiceIcon(
                    isMasterAvailable: ctx.masterServices != null,
                    isMasterSelected: ctx.selectedService == 1,
                    onMasterSelected: () => ctx.onSelectedService(1),
                    isTransactionAvailable: ctx.transactionService != null,
                    isTransactionSelected: ctx.selectedService == 2,
                    onTransactionSelected: () => ctx.onSelectedService(2),
                    isReportAvailable: ctx.reportService != null,
                    isReportSelected: ctx.selectedService == 3,
                    onReportSelected: () => ctx.onSelectedService(3),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ctx.getSelectedServiceLength(),
                      itemBuilder: (context, index) {
                        return ListSubMenu(
                          index: index,
                          selectedService: ctx.selectedService,
                          masterServices: ctx.masterServices,
                          transactionService: ctx.transactionService,
                          reportService: ctx.reportService,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
