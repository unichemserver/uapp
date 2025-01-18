import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/modules/marketing/model/noo_model.dart';

class NooSaved extends StatefulWidget {
  const NooSaved({super.key});

  @override
  State<NooSaved> createState() => _NooSavedState();
}

class _NooSavedState extends State<NooSaved> {
  final db = MarketingDatabase();
  List<NooModel> nooData = [];

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

  @override
  void initState() {
    super.initState();
    getNooData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data KIL'),
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
