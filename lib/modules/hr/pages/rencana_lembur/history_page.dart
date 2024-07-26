import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/modules/hr/model/rc.dart';
import 'package:uapp/modules/hr/pages/rencana_lembur/api.dart' as api;
import 'package:uapp/modules/hr/widget/keterangan_status.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Rc> rcList = [];
  bool isLoading = true;

  void getRcList() async {
    final result = await api.getRencanaLembur();
    setState(() {
      rcList = result;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getRcList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Lembur'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : rcList.isEmpty
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
      itemCount: rcList.length,
      itemBuilder: (context, index) {
        final item = rcList[index];
        return ExpansionTile(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(item.nomorRc),
          subtitle: Text('Rencana lembur: ${item.tgl}'),
          children: [
            ListTile(
              title: const Text('Jam Lembur'),
              subtitle: Text(
                '${item.jamAwal.substring(0, 5)} - ${item.jamAkhir.substring(0, 5)}',
              ),
            ),
            ListTile(
              title: const Text('Alasan Lembur'),
              subtitle: Text(
                'Tugas : ${item.tugasKerja}\ndengan jumlah tenaga kerja: ${item.tenagaKerja} orang',
              ),
            ),
            item.status == '1' || item.status == '2'
                ? ListTile(
                    title: Text(
                      item.status == '1' ? 'Disetujui oleh' : 'Ditolak oleh',
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
                                    api.deleteRencanaLembur(item.nomorRc);
                                    setState(() {
                                      rcList.removeAt(index);
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
