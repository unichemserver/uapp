import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:uapp/core/utils/utils.dart';
import 'approval_controller.dart';
// import 'approval_api.dart'; // Import ApprovalApi
import 'package:uapp/core/database/marketing_database.dart';
import 'Package:uapp/modules/approval/widget/approval_data_screen.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({Key? key}) : super(key: key); // Maintain Key? key

  @override
  _ApprovalScreenState createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  final ApprovalController controller = Get.put(ApprovalController());
  final db = MarketingDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.approvalData.isEmpty) {
          return const Center(child: Text('No approval data available'));
        }

        return ListView.builder(
          itemCount: controller.approvalData.length,
          itemBuilder: (context, index) {
            final item = controller.approvalData[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item['nama_outlet']}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Group:',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                            Text(
                              '${item['groupPelanggan']?.split('[').first.trim()}\n[${item['groupPelanggan']?.split('[').last.trim()}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID Noo:',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                            Text('${item['idNoo']}'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'User ID: ${item['userId']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 16.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final ApprovalController controller = Get.find();
                          controller.setIdNoo(item['idNoo']); // Set idNoo before navigating
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Get.to(() => ApprovalDataScreen());
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.description),
                        label: const Text('Details'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // void _showConfirmationDialog(BuildContext context, String action, String userId, String idNoo, int creditLimit, String paymentMethod) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Konfirmasi'),
  //         content: Text('Apakah Anda yakin ingin $action data ini?'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               Navigator.of(context).pop();
  //               if (action == 'menyetujui') {
  //                 final success = await ApprovalApi.approveData(userId, idNoo, creditLimit, paymentMethod);
  //                 if (success) {
  //                   Utils.showInAppNotif('Outlet Disetujui', "Data outlet berhasil disetujui");
  //                   await controller.fetchAllApprovalData(); // Refresh all data
  //                 } else {
  //                   Utils.showInAppNotif('Outlet Ditolak', "Data outlet gagal disetujui");
  //                 }
  //               } else {
  //                 // Handle rejection logic here if needed
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(content: Text('Data ditolak')),
  //                 );
  //                 await controller.fetchAllApprovalData(); // Refresh all data
  //               }
  //             },
  //             child: const Text('Yes'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
