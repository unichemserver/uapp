import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/modules/hr/model/skm.dart';
import 'package:uapp/modules/hr/pages/keluar_mobil/api.dart' as api;
import 'package:uapp/modules/hr/widget/keterangan_status.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Skm> skmList = [];
  final box = Hive.box(HiveKeys.appBox);
  bool isLoading = false;

  void setisLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void getHistory() async {
    setisLoading(true);
    var res = await api.getKeluarMobil();
    setState(() {
      skmList = res;
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
        title: const Text('Riwayat Keluar Mobil'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : skmList.isEmpty
              ? Center(child: LottieBuilder.asset(Assets.noDataAnimation))
              : Column(
                  children: [
                    Expanded(
                      child: _buildListData(),
                    ),
                    const KeteranganStatus(),
                  ],
                ),
    );
  }

  _buildListData() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: skmList.length,
      itemBuilder: (context, index) {
        final item = skmList[index];
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
          title: Text(item.nomorSkm),
          subtitle: Text(
            'Dibuat pada: ${item.createdDate}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            ListTile(
              title: Text('Keperluan: ${item.keperluan}'),
              subtitle: Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(width: 16),
                  Text(item.tujuan),
                ],
              ),
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
                                    var res = await api
                                        .deleteKeluarMobil(item.nomorSkm);
                                    if (res != null) {
                                      Get.back();
                                      Get.snackbar(
                                        'Informasi',
                                        res,
                                      );
                                      getHistory();
                                    } else {
                                      Get.back();
                                      Get.snackbar(
                                        'Informasi',
                                        'Terjadi kesalahan saat menghapus data. Silahkan coba lagi.',
                                      );
                                    }
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
        );
      },
    );
  }
}
