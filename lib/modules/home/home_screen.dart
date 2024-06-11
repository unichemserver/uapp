import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/modules/home/home_controller.dart';
import 'package:uapp/modules/home/pages/sync_page.dart';
import 'package:uapp/modules/home/widget/home_drawer.dart';
import 'package:uapp/modules/home/widget/list_sub_menu.dart';
import 'package:uapp/modules/home/widget/main_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                        child: FadeInImage.assetNetwork(
                          placeholder: Assets.logoAsset,
                          image: ctx.foto,
                          fit: BoxFit.cover,
                          width: 48.0,
                          height: 48.0,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return const CircleAvatar(
                              backgroundImage: AssetImage(Assets.logoAsset),
                              backgroundColor: Colors.white,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              actions: [
                ctx.showMarketingMenu()
                    ? IconButton(
                        onPressed: () {
                          ctx.getListMarketingActivity();
                          Get.toNamed(Routes.SYNC);
                        },
                        icon: const Icon(Icons.sync),
                      )
                    : const SizedBox(),
              ],
            ),
            drawer: SafeArea(
              child: Drawer(
                child: HomeDrawer(
                  name: ctx.nama,
                  menus: ctx.menus,
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
