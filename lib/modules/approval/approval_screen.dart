import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/utils/utils.dart';
import 'approval_controller.dart';
import 'approval_api.dart'; // Import ApprovalApi
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item['nama_outlet']}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text('${item['groupPelanggan']}'),
                    Text('${item['idNoo']}'),
                    Text('User ID: ${item['userId']}'),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            final ApprovalController controller = Get.find();
                            controller.setIdNoo(item['idNoo']); // Set idNoo sebelum pindah ke halaman
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Get.to(() => ApprovalDataScreen());
                            });
                          },
                          icon: const Icon(Icons.description),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                          onPressed: () {
                            _showConfirmationDialog(context, 'menyetujui', item['userId'], item['idNoo']);
                          },
                          icon: const Icon(Icons.check, color: Colors.green),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                          onPressed: () {
                            _showConfirmationDialog(context, 'menolak', item['userId'], item['idNoo']);
                          },
                          icon: const Icon(Icons.close, color: Colors.red),
                        ),
                      ],
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

  void _showConfirmationDialog(BuildContext context, String action, String userId, String idNoo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin $action data ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (action == 'menyetujui') {
                  final success = await ApprovalApi.approveData(userId, idNoo);
                  if (success) {
                    Utils.showInAppNotif('Outlet Disetujui', "Data outlet berhasil disetujui");
                    await controller.fetchAllApprovalData(); // Refresh all data
                  } else {
                    Utils.showInAppNotif('Outlet Ditolak', "Data outlet gagal disetujui");
                  }
                } else {
                  // Handle rejection logic here if needed
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data ditolak')),
                  );
                  await controller.fetchAllApprovalData(); // Refresh all data
                }
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
