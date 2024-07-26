import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/model/tdl.dart';
import 'package:uapp/modules/hr/pages/dinas_luar/api.dart' as api;
import 'package:uapp/modules/hr/widget/keterangan_status.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final box = Hive.box(HiveKeys.appBox);
  bool isLoading = false;

  void setisLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  List<Tdl> tdlList = [];

  void getHistory() async {
    setisLoading(true);
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    var nik = userData.id;
    var res = await api.getDinasLuar(nik);
    setState(() {
      isLoading = false;
      tdlList = res;
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
        title: const Text('Riwayat Dinas Luar'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                getHistory();
              },
              child: Column(
                children: [
                  Expanded(
                    child: _buildListData(),
                  ),
                  const KeteranganStatus(),
                ],
              ),
            ),
    );
  }

  _buildListData() {
    if (tdlList.isEmpty) {
      return LottieBuilder.asset(Assets.noDataAnimation);
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tdlList.length,
      itemBuilder: (context, index) {
        var item = tdlList[index];
        return ExpansionTile(
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
          title: Text(item.nomorTdl),
          subtitle: Text(
            'Tujuan Dinas : ${item.tujuanDinas}\ndengan keperluan, ${item.keperluan}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Waktu Berangkat'),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.date_range),
                            const SizedBox(width: 10),
                            Text(item.tglBerangkat),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time),
                            const SizedBox(width: 10),
                            Text(item.jamBerangkat),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Waktu Kembali'),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.date_range),
                            const SizedBox(width: 10),
                            Text(item.tglKembali),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time),
                            const SizedBox(width: 10),
                            Text(item.jamKembali),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            item.status == '1' || item.status == '2'
                ? ListTile(
                    title: Text(
                      item.status == '1'
                          ? 'Disetujui oleh ${item.approvedBy}'
                          : 'Ditolak oleh ${item.approvedBy}',
                    ),
                    subtitle: Text(
                      '${item.approvedBy}\nPada tanggal: ${item.approvedDate}',
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
                                  onPressed: () async {
                                    Get.back();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const LoadingDialog(
                                          message: 'Menghapus data...',
                                        );
                                      },
                                    );
                                    api.deleteDinasLuar(item.nomorTdl)
                                    .then((value) {
                                      Navigator.pop(context);
                                      if (value == null) {
                                        Get.snackbar(
                                          'Berhasil',
                                          'Data berhasil dihapus',
                                          backgroundColor: Colors.green,
                                        );
                                        getHistory();
                                      } else {
                                        Get.snackbar(
                                          'Gagal',
                                          value,
                                          backgroundColor: Colors.red,
                                        );
                                      }
                                    });
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
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
