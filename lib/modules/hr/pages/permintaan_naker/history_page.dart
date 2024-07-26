import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/model/ptk.dart';
import 'package:uapp/modules/hr/pages/permintaan_naker/api.dart';
import 'package:uapp/modules/hr/widget/keterangan_status.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool isLoading = true;
  List<Ptk> ptkList = [];
  final box = Hive.box(HiveKeys.appBox);

  void getHistory() async {
    final userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    var res = await getPtk(userData.id);
    setState(() {
      ptkList = res;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Permintaan Naker'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ptkList.isEmpty
              ? Center(child: LottieBuilder.asset(Assets.noDataAnimation))
              : Column(
                  children: [
                    Expanded(
                      child: _buildListData(),
                    ),
                    KeteranganStatus(),
                  ],
                ),
    );
  }

  _buildListData() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ptkList.length,
      itemBuilder: (context, index) {
        var item = ptkList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: item.status == '1'
                ? Colors.green[100]
                : item.status == '0'
                    ? Colors.red[100]
                    : item.status == '2'
                        ? Colors.redAccent
                        : Colors.white,
            collapsedBackgroundColor: item.status == '1'
                ? Colors.green[100]
                : item.status == '0'
                    ? Colors.red[100]
                    : item.status == '2'
                        ? Colors.redAccent
                        : Colors.white,
            title: Text(item.nomorPtk),
            subtitle: Text(
              'Diajukan pada tanggal: ${item.createdAt}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              item.status == '1' || item.status == '2'
                  ? ListTile(
                      title: Text(
                        item.status == '1'
                            ? 'Disetujui oleh ${item.approvedBy}'
                            : 'Ditolak oleh ${item.approvedBy}',
                      ),
                      subtitle: Text(
                        '${item.approvedBy}\nPada tanggal: ${item.approvedAt}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox(),
              item.status == '0'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                  'Apakah anda yakin ingin menghapus data ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _removePtk(item.nomorPtk);
                                    },
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 8),
                              Text('Hapus'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            Get.back(
                              result: item,
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }

  void _removePtk(String nomorPtk) async {
    Get.back();
    Get.dialog(
      const LoadingDialog(
        message: 'Menghapus data...',
      ),
      barrierDismissible: false,
    );
    String? response = await deletePtk(nomorPtk);
    Get.back();
    if (response != null) {
      Get.snackbar(
        'Gagal',
        response,
      );
    } else {
      getHistory();
      Get.snackbar(
        'Berhasil',
        'Data berhasil dihapus',
      );
    }
  }
}
