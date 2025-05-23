import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
// import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/profile_image.dart';
import 'package:uapp/modules/home/home_controller.dart';
import 'package:uapp/modules/home/widget/home_drawer.dart';
// import 'package:uapp/modules/home/widget/hr_pending_approval.dart';
import 'package:uapp/modules/home/widget/list_sub_menu.dart';
import 'package:uapp/modules/home/widget/main_services.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final bool isHrApproval = Utils.allowedPosisi.contains(Utils.getUserData().posisi);

  // Method untuk menghitung tinggi notifikasi berdasarkan konten
  double _calculateNotificationHeight(String? title, String? content) {
    if (title == null || content == null) return 0;
    
    // Estimasi tinggi berdasarkan panjang teks
    final titleLines = (title.length / 35).ceil(); // ~35 karakter per baris untuk title
    final contentLines = (content.length / 45).ceil(); // ~45 karakter per baris untuk content
    
    // Base height + title height + content height + padding
    double baseHeight = 80; // tinggi minimum
    double titleHeight = titleLines * 18; // 18px per baris title
    double contentHeight = contentLines * 16; // 16px per baris content
    double padding = 20; // padding tambahan
    
    double totalHeight = baseHeight + titleHeight + contentHeight + padding;
    
    // Maksimal 250, jika lebih akan ada "See More"
    return totalHeight > 250 ? 250 : totalHeight;
  }

  // Method untuk menentukan apakah perlu tombol "See More"
  bool _needsSeeMore(String? title, String? content) {
    if (title == null || content == null) return false;
    
    final titleLines = (title.length / 35).ceil();
    final contentLines = (content.length / 45).ceil();
    double totalHeight = 80 + (titleLines * 18) + (contentLines * 16) + 20;
    
    return totalHeight > 250;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      initState: (_) {},
      builder: (ctx) {
        // Kalkulasi tinggi notifikasi
        final notificationHeight = ctx.latestNotification != null 
            ? _calculateNotificationHeight(
                ctx.latestNotification?['title'], 
                ctx.latestNotification?['content']
              ) 
            : 0;
            
        final needsSeeMore = ctx.latestNotification != null 
            ? _needsSeeMore(
                ctx.latestNotification?['title'], 
                ctx.latestNotification?['content']
              ) 
            : false;

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: const Color(0xFFF5F7FA),
            appBar: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: const Text(
                "UAPP",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                  fontSize: 18,
                ),
              ),
              leading: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 2,
                        ),
                      ),
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
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF4A5568),
                  ),
                  onPressed: () {
                   Get.toNamed(Routes.NOTIF); 
                  },
                ),
              ],
            ),
            drawer: SafeArea(
              child: Drawer(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: HomeDrawer(
                  name: ctx.nama,
                  menus: ctx.menus,
                  jabatan: ctx.userData!.namaJabatan,
                  foto: ctx.foto,
                  department: ctx.userData!.department,
                  scaffoldKey: _scaffoldKey,
                ),
              ),
            ),
            body: RefreshIndicator(
              color: Theme.of(context).primaryColor,
              onRefresh: () async {
                // Get.delete<HomeController>();
                // Get.put(HomeController());
                ctx.getNotification(); // panggil getNotification saat refresh
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: Stack(
                children: [
                  // Notifikasi section dengan tinggi yang adaptif
                  if (ctx.latestNotification != null)
                    Positioned(
                      top: 110,
                      left: 20,
                      right: 20,
                      child: Container(
                        height: notificationHeight.toDouble(),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.yellow[200],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Notifikasi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  ctx.latestNotification?['created_at']?.toString().substring(0, 16) ?? '',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ctx.latestNotification?['title'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600, 
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    maxLines: needsSeeMore ? 2 : null,
                                    overflow: needsSeeMore ? TextOverflow.ellipsis : null,
                                  ),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ctx.latestNotification?['content'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                              maxLines: needsSeeMore ? 6 : null,
                                              overflow: needsSeeMore ? TextOverflow.ellipsis : null,
                                            ),
                                            if (needsSeeMore) ...[
                                              const SizedBox(height: 4),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(Routes.NOTIF);
                                                  },
                                                  child: Text(
                                                    'See More',
                                                    style: TextStyle(
                                                      color: Colors.blue.shade700,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      decoration: TextDecoration.underline,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Welcome header section
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x0D000000),
                            offset: Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ctx.titleAppbar(),
                            style: const TextStyle(
                              color: Color(0xFF2D3748),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ctx.userData!.namaJabatan,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Main content dengan margin yang dinamis
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(
                      top: ctx.latestNotification != null 
                          ? 110 + notificationHeight + -50 // header + notification + spacing
                          : 100, // hanya header
                      // bottom: isHrApproval ? Get.height * 0.35 : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        if (ctx.showMarketingMenu())
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), 
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Lihat performa kamu di sini',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.bar_chart_outlined,
                                    color: Colors.blueAccent,
                                  ),
                                  onPressed: () {
                                    Get.toNamed(Routes.MKT_DASHBOARD);
                                  },
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),
                        // Main services icons with enhanced styling
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.08),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: MainServiceIcon(
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
                        ),
                        const SizedBox(height: 24),
                        // Menu section title
                        const Text(
                          'Menu Options',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Sub menu list with enhanced styling
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: ctx.getSelectedServiceLength(),
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.06),
                                      spreadRadius: 0,
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListSubMenu(
                                  index: index,
                                  selectedService: ctx.selectedService,
                                  masterServices: ctx.masterServices,
                                  transactionService: ctx.transactionService,
                                  reportService: ctx.reportService,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // HR Approval section with modern design
                  // if (isHrApproval && ctx.hrResponse != null)
                  //   DraggableScrollableSheet(
                  //     initialChildSize: (Get.height * 0.35) / Get.height,
                  //     minChildSize: (Get.height * 0.35) / Get.height,
                  //     maxChildSize: 0.8,
                  //     builder: (BuildContext context, ScrollController scrollController) {
                  //       return Container(
                  //         decoration: const BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.vertical(
                  //             top: Radius.circular(24),
                  //           ),
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Color(0x1A000000),
                  //               blurRadius: 12,
                  //               spreadRadius: 0,
                  //               offset: Offset(0, -4),
                  //             ),
                  //           ],
                  //         ),
                  //         child: Column(
                  //           children: [
                  //             // Drag handle
                  //             Container(
                  //               width: Get.width * 0.15,
                  //               height: 5,
                  //               margin: const EdgeInsets.symmetric(vertical: 12),
                  //               decoration: BoxDecoration(
                  //                 color: Colors.grey[300],
                  //                 borderRadius: BorderRadius.circular(3),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(horizontal: 20),
                  //               child: Column(
                  //                 children: [
                  //                   Row(
                  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                  //                         children: [
                  //                           Text(
                  //                             'Pending Approvals',
                  //                             style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  //                               fontWeight: FontWeight.w600,
                  //                               color: const Color(0xFF2D3748),
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             '${ctx.hrApprovalList.length} items waiting',
                  //                             style: TextStyle(
                  //                               color: Colors.grey[600],
                  //                               fontSize: 12,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       ctx.hrApprovalList.isNotEmpty
                  //                         ? Row(
                  //                             children: [
                  //                               _ApprovalActionButton(
                  //                                 icon: Icons.close,
                  //                                 color: const Color(0xFFF56565),
                  //                                 onPressed: () {
                  //                                   // ctx.rejectAll();
                  //                                 },
                  //                                 label: 'Reject All',
                  //                               ),
                  //                               const SizedBox(width: 8),
                  //                               _ApprovalActionButton(
                  //                                 icon: Icons.check,
                  //                                 color: const Color(0xFF48BB78),
                  //                                 onPressed: () {
                  //                                   // ctx.approveAll();
                  //                                 },
                  //                                 label: 'Approve All',
                  //                               ),
                  //                             ],
                  //                           )
                  //                         : const SizedBox(),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             const Divider(height: 24),
                  //             Expanded(
                  //               child: HrPendingApproval(
                  //                 hrResponse: ctx.hrResponse,
                  //                 scrollController: scrollController,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //   ),
                ],
              ),
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     // Handle quick action
            //   },
            //   backgroundColor: Theme.of(context).primaryColor,
            //   elevation: 4,
            //   child: const Icon(
            //     Icons.add,
            //     color: Colors.white,
            //   ),
            // ),
          ),
        );
      },
    );
  }
}

// // New component for approval buttons
// class _ApprovalActionButton extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final VoidCallback onPressed;
//   final String label;

//   const _ApprovalActionButton({
//     required this.icon,
//     required this.color,
//     required this.onPressed,
//     required this.label,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       onPressed: onPressed,
//       icon: Icon(
//         icon,
//         color: Colors.white,
//         size: 16,
//       ),
//       label: Text(
//         label,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 12,
//         ),
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         elevation: 0,
//       ),
//     );
//   }
// }