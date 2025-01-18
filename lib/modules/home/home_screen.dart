import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/profile_image.dart';
import 'package:uapp/modules/home/home_controller.dart';
import 'package:uapp/modules/home/widget/home_drawer.dart';
import 'package:uapp/modules/home/widget/hr_pending_approval.dart';
import 'package:uapp/modules/home/widget/list_sub_menu.dart';
import 'package:uapp/modules/home/widget/main_services.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isHrApproval = Utils.allowedPosisi.contains(Utils.getUserData().posisi);

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
            body: RefreshIndicator(
              onRefresh: () async {
                Get.delete<HomeController>();
                Get.put(HomeController());
              },
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    margin: EdgeInsets.only(
                      bottom: isHrApproval ? Get.height * 0.35 : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        MainServiceIcon(
                          isMasterAvailable: ctx.masterServices != null,
                          isMasterSelected: ctx.selectedService == 1,
                          onMasterSelected: () => ctx.onSelectedService(1),
                          isTransactionAvailable:
                              ctx.transactionService != null,
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
                  if (isHrApproval && ctx.hrResponse != null)
                    DraggableScrollableSheet(
                      initialChildSize: (Get.height * 0.35) / Get.height,
                      minChildSize: (Get.height * 0.35) / Get.height,
                      maxChildSize: 1.0,
                      builder: (
                        BuildContext context,
                        ScrollController scrollController,
                      ) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: Get.width * 0.4,
                                height: 4,
                                margin: const EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: Get.width,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'PENDING APPROVE HR SUBMISSION',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    ctx.hrApprovalList.isNotEmpty
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                ),
                                                iconSize: 32,
                                                onPressed: () {
                                                  // ctx.approveAll();
                                                },
                                              ),
                                              const SizedBox(width: 8),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                ),
                                                iconSize: 32,
                                                onPressed: () {
                                                  // ctx.rejectAll();
                                                },
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              const Divider(),
                              Expanded(
                                child: HrPendingApproval(
                                  hrResponse: ctx.hrResponse,
                                  scrollController: scrollController,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
