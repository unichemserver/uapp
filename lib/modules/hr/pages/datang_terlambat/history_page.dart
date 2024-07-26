import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/model/mdt.dart';
import 'package:uapp/modules/hr/pages/datang_terlambat/api.dart' as api;
import 'package:uapp/core/utils/date_utils.dart' as du;
import 'package:uapp/modules/hr/widget/keterangan_status.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final box = Hive.box(HiveKeys.appBox);
  bool isLoading = false;
  List<Mdt> mdtList = [];

  void setisLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void getHistory() async {
    setisLoading(true);
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    var nik = userData.id;
    var res = await api.getDatangTerlambat(nik);
    setState(() {
      isLoading = false;
      mdtList = res;
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
        title: const Text('Riwayat Datang Terlambat'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : mdtList.isEmpty
              ? LottieBuilder.asset(Assets.noDataAnimation)
              : _buildListData(),
    );
  }

  _buildListData() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mdtList.length,
            itemBuilder: (context, index) {
              var item = mdtList[index];
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
                  title: Text(item.nomorMdt),
                  trailing: Text('${item.terlambat} menit'),
                  subtitle: RichText(
                    text: TextSpan(
                      text: 'Tanggal: ',
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: du.DateUtils.getFormattedDateFromYMD(item.tgl),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  children: [
                    ListTile(
                      title: const Text('Alasan'),
                      subtitle: Text(
                        'Ijin kepentingan: ${item.kepentingan}\ndengan keperluan, ${item.keperluan}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    item.status == '1' || item.status == '2'
                        ? ListTile(
                            title: Text(
                              item.status == '1'
                                  ? 'Disetujui oleh'
                                  : 'Ditolak oleh',
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
                                            api
                                                .deleteDatangTerlambat(item.nomorMdt)
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
                ),
              );
            },
          ),
        ),
        KeteranganStatus(),
      ],
    );
  }
}
