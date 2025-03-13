import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/modules/marketing/api/api_client.dart';
import 'package:uapp/modules/marketing/api/sync_marketing_activity_api.dart';
// import 'package:uapp/modules/marketing/api/sync_marketing_activity_api.dart';
import 'package:uapp/modules/marketing/model/noo_model.dart';
import 'package:uapp/modules/marketing/model/marketing_activity.dart';

class NooSaved extends StatefulWidget {
  const NooSaved({super.key});

  @override
  State<NooSaved> createState() => _NooSavedState();
}

class _NooSavedState extends State<NooSaved> {
  final db = MarketingDatabase();
  final apiClient = MarketingApiClient();
  List<NooModel> nooData = [];
  List<MarketingActivity> newOpeningOutlet = [];
  late SyncMarketingActivityApi syncApi;

  void getNooData() async {
    final data = await db.query('masternoo');
    setState(() {
      nooData = data.map((e) => NooModel.fromJson(e)).toList();
    });
  }

  void deleteNooData(String id) async {
    await db.delete('masternoo', 'id = ?', [id]);
    await db.delete('noodocument', 'id_noo = ?', [id]);
    await db.delete('noospesimen', 'id_noo = ?', [id]);
    await db.delete('nooaddress', 'id_noo = ?', [id]);
    getNooData();
  }

 Future<void> syncNooById(String id) async {
  // 1. Ambil data dari tabel marketing_activity berdasarkan custId
  final List<Map<String, dynamic>> marketingData = await db.query(
    'marketing_activity',
    where: 'cust_id = ? AND jenis = ?',
    whereArgs: [id, Call.noo],
  );

  if (marketingData.isEmpty) {
    Log.d("Tidak ada data marketing_activity dengan custId: $id");
    return;
  }

  // 2. Looping data yang ditemukan
  for (var record in marketingData) {
    int syncStatus = record['status_sync']; // Ambil statusSync

    if (syncStatus == 0) {
      // 3. Jika statusSync masih 0, panggil fungsi sinkronisasi utama
      await syncApi.syncMarketingActivity();
      Log.d("Sinkronisasi dijalankan untuk custId: $id");
    } else {
      Log.d("custId $id sudah tersinkronisasi.");
    }
  }
}

  @override
  void initState() {
    super.initState();
    syncApi = SyncMarketingActivityApi(api: apiClient, db: db);
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
        return ListTile(
          title: Text(data.namaPerusahaan ?? ''),
          subtitle: Text(data.groupCust ?? ''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.sync),
                onPressed: () {
                  Log.d('View Data');
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
          ),
        );
      },
    );
  }
}
