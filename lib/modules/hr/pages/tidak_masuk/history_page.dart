import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/core/utils/instance.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/model/sjtm.dart';
import 'package:uapp/modules/hr/pages/tidak_masuk/api.dart' as api;
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

  void setisLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  List<Sjtm> sjtmList = [];

  void getHistory() async {
    setisLoading(true);
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    var nik = userData.id;
    var res = await api.getTidakMasuk(nik);
    setState(() {
      isLoading = false;
      sjtmList = res;
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
        title: const Text('History Tidak Masuk'),
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
                  KeteranganStatus(),
                ],
              ),
            ),
    );
  }

  _buildListData() {
    if (sjtmList.isEmpty) {
      return LottieBuilder.asset(Assets.noDataAnimation);
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sjtmList.length,
      itemBuilder: (context, index) {
        var item = sjtmList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ExpansionTile(
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
            title: Text(
              item.nomorSjtm,
              style: TextStyle(
                color: item.status == '1'
                    ? Colors.green
                    : item.status == '0'
                        ? Colors.red
                        : item.status == '2'
                            ? Colors.redAccent
                            : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
                'Dibuat pada\nTanggal\t: ${du.DateUtils.formatDate(item.createdAt)}\nWaktu\t\t\t\t: ${du.DateUtils.formatTime(item.createdAt)} WIB'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              ListTile(
                title: const Text(
                  'Tanggal Ijin:',
                ),
                subtitle: Text(
                  'Dari tanggal\t\t\t\t\t\t\t: ${du.DateUtils.getFormattedDateFromYMD(item.drTgl)}\nSampai tanggal\t: ${du.DateUtils.getFormattedDateFromYMD(item.spTgl)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Keterangan:',
                ),
                subtitle: Text(
                  '${item.keterangan.toUpperCase()} - ${item.keperluan}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              item.dokumenIjinPribadi != null
                  ? ListTile(
                      title: const Text(
                        'Dokumen:',
                      ),
                      subtitle: Text(
                        item.dokumenIjinPribadi!,
                      ),
                      onTap: () {
                        Get.dialog(
                          Dialog(
                            child: Image.network(
                              getBaseImageUrl(
                                box.get(HiveKeys.baseURL),
                                'sjtm',
                                item.dokumenIjinPribadi!,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const SizedBox(),
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
                                    'Apakah anda yakin ingin menghapus data ini?',),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      api
                                          .deleteTidakMasuk(item.nomorSjtm)
                                          .then((message) {
                                        if (message == null) {
                                          Get.back();
                                          Get.snackbar(
                                            'Berhasil',
                                            'Data berhasil dihapus',
                                            backgroundColor: Colors.green,
                                          );
                                          getHistory();
                                        } else {
                                          Get.snackbar(
                                            'Gagal',
                                            message,
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
    );
  }

}
