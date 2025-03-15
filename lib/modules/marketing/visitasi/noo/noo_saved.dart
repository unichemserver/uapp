import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/api/api_client.dart';
import 'package:uapp/modules/marketing/marketing_api.dart';
import 'package:uapp/modules/marketing/model/noo_model.dart';
import 'package:uapp/modules/marketing/model/noo_activity.dart';
import 'package:uapp/modules/marketing/api/sync_noo_activity_api.dart';
// import 'package:uapp/core/notification/notification.dart';
// import 'package:uapp/core/notification/notif_id.dart';

class NooSaved extends StatefulWidget {
  const NooSaved({super.key});

  @override
  State<NooSaved> createState() => _NooSavedState();
}

class _NooSavedState extends State<NooSaved> {
  final db = MarketingDatabase();
  final api = MarketingApiService();
  final apiClient = MarketingApiClient();
  List<NooModel> nooData = [];
  List<NooActivity> nooActivity = [];
  late SyncNooActivityApi syncNooApi;

  void getNooData() async {
    final data = await db.query('masternoo');
    final activityData = await db.query('noo_activity');
    setState(() {
      nooData = data.map((e) => NooModel.fromJson(e)).toList();
      nooActivity = activityData.map((e) => NooActivity.fromJson(e)).toList();

      nooData.sort((a, b) => b.id!.compareTo(a.id!));
    });
  }

  void deleteNooData(String id) async {
    await db.delete('masternoo', 'id = ?', [id]);
    await db.delete('noodocument', 'id_noo = ?', [id]);
    await db.delete('noospesimen', 'id_noo = ?', [id]);
    await db.delete('nooaddress', 'id_noo = ?', [id]);
    await db.delete('noo_activity', 'idnoo = ?', [id]);
    getNooData();
  }

 Future<void> syncNooById(String id) async {
  Utils.showLoadingDialog(context); // Show loading dialog
  try {
    final List<Map<String, dynamic>> nooActivityData = await db.query(
      'noo_activity',
      where: 'idnoo = ?',
      whereArgs: [id],
    );

    if (nooActivityData.isEmpty) {
      Log.d("Tidak ada data noo_activity dengan idnoo: $id");
      return;
    }

    for (var record in nooActivityData) {
      int syncStatus = record['statussync'];

      if (syncStatus == 0) {
        await syncNooApi.syncNooActivity(idNoo: id);
        await db.update(
          'noo_activity',
          {'statussync': 1},
          'idnoo = ?',
          [id],
        );
        // await getUserApprovalAndNotify(id);
        Log.d("Sinkronisasi dijalankan untuk idnoo: $id");

        final response = await apiClient.postRequest(
          method: 'approve_noo',
          additionalData: {'idnoo': id},
        );

        if (response.success && response.data['approved'] == 1) {
          await db.update(
            'noo_activity',
            {'approved': 1},
            'idnoo = ?',
            [id],
          );
          Log.d("Data untuk idnoo $id telah disetujui.");

        }
      } else {
        Log.d("idnoo $id sudah tersinkronisasi.");
      }
    }
  } finally {
    Navigator.pop(context);
    getNooData();
  }
}

// Future<void> getUserApprovalAndNotify(String id) async {
//   final response = await api.getUserApproval(id);

//   if (response != null && response['success'] == true) {
//     final List<dynamic> userData = response['data'];
//     for (var user in userData) {
//       final String nik = user['nik'];
//       final String nomorUrut = user['nomor_urut'];

//       Log.d(nik);
      

//       // Send notification to the user
//       await showNotification(
//         NotifId.NOTIF_CH_ID,
//         NotifId.NOTIF_CH_NAME,
//         int.parse(nomorUrut),
//         'Data Sinkronisasi',
//         'Data dengan id $id telah disinkronisasi dan disetujui.',
//       );
//     }
//   } else {
//     Log.d("Gagal mendapatkan data user approval untuk idnoo: $id");
//   }
// }

  @override
  void initState() {
    super.initState();
    syncNooApi = SyncNooActivityApi(api: apiClient, db: db);
    getNooData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data PDL'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getNooData();
        },
        child: buildBody(context),
      ),
    );
  }

  buildBody(BuildContext context) {
    if (nooData.isEmpty) {
      return const Center(
        child: Text('Tidak ada Data'),
      );
    }
    return ListView.builder(
      itemCount: nooData.length,
      itemBuilder: (context, index) {
        final data = nooData[index];
        final activity = nooActivity.firstWhere(
        (item) => item.idnoo == data.id,
        orElse: () => NooActivity(id: 0, idnoo: data.id!, statussync: 0, approved: 0, status: '', idCustOrlan: ''),
      );
        return ListTile(
          title: Text(data.namaPerusahaan ?? ''),
          subtitle: Text(data.groupCust ?? ''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (activity.statussync == 0) ...[
                IconButton(
                  icon: const Icon(Icons.sync),
                  onPressed: () {
                    syncNooById(data.id!);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Konfirmasi'),
                        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Tidak'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteNooData(data.id!);
                              Get.back();
                            },
                            child: const Text('Ya'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Get.back(result: data);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
