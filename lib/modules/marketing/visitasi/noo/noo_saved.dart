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
import 'package:uapp/modules/marketing/visitasi/noo/widget/noo_form_widget.dart';
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
        // await showNotification(
        //   NotifId.MKT_SYNC_CH_ID,
        //   NotifId.MKT_SYNC_CH_NAME,
        //   NotifId.MKT_SYNC_ID,
        //   'Data sudah tersinkronisasi',
        //   'Data dengan id $id sudah tersinkronisasi.',
        // );
        Log.d("idnoo $id sudah tersinkronisasi.");
      }
    }
  } finally {
    Navigator.pop(context);
    getNooData();
  }
}

  String safeValue(dynamic value) {
  if (value == null || value == "null") return "-";
  return value.toString();
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
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              data.namaPerusahaan ?? 'Nama Perusahaan Tidak Diketahui',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Group: ${data.groupCust ?? 'Tidak Diketahui'}'),
                Text('ID: ${data.id}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (activity.statussync == 0) ...[
                  IconButton(
                    icon: const Icon(Icons.sync, color: Colors.blue),
                    onPressed: () {
                      syncNooById(data.id!);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
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
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      Get.back(result: data);
                    },
                  ),
                ] else ...[
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {
                      Get.dialog(
                        Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: NooFormWidget(
                            masternoo: {
                              'id': safeValue(data.id),
                              'nama_perusahaan': safeValue(data.namaPerusahaan),
                              'group_cust': safeValue(data.groupCust),
                              'termin': safeValue(data.termin),
                              'credit_limit': safeValue(data.creditLimit),
                              'payment_method': safeValue(data.paymentMethod),
                              'jaminan': safeValue(data.jaminan),
                              'nilai_jaminan': safeValue(data.nilaiJaminan),
                              'area_marketing': safeValue(data.areaMarketing),
                              'tgl_join': safeValue(data.tglJoin),
                              'spv_uci': safeValue(data.spvUci),
                              'nama_owner': safeValue(data.namaOwner),
                              'nohp_owner': safeValue(data.nohpOwner),
                              'email_owner': safeValue(data.emailOwner),
                              'alamat_owner': safeValue(data.alamatOwner),
                              'alamat_kantor': safeValue(data.alamatKantor),
                              'status_pajak': safeValue(data.statusPajak),
                              'nama_npwp': safeValue(data.namaNpwp),
                              'no_npwp': safeValue(data.noNpwp),
                              'nama_bank': safeValue(data.namaBank),
                              'no_rek_va': safeValue(data.noRekVa),
                              'nama_rek': safeValue(data.namaRek),
                              'cabang_bank': safeValue(data.cabangBank),
                              'bidang_usaha': safeValue(data.bidangUsaha),
                              'tgl_mulai_usaha': safeValue(data.tglMulaiUsaha),
                              'produk_utama': safeValue(data.produkUtama),
                              'produk_lain': safeValue(data.produkLain),
                              'lima_cust_utama': safeValue(data.limaCustUtama),
                              'est_omset_month': safeValue(data.estOmsetMonth),
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
