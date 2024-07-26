import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/core/widget/created_date.dart';
import 'package:uapp/modules/hr/model/sik.dart';
import 'package:uapp/modules/hr/widget/keterangan_status.dart';
import 'package:uapp/modules/hr/pages/ijin_keluar_pulang/api.dart' as api;

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.isMulti});

  final bool isMulti;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Sik> sikList = [];
  bool isLoading = true;

  void getHistory() async {
    var res = await api.getSuratIjinKeluar();
    if (widget.isMulti) {
      res = res.where((element) => element.nik != null && element.nik!.isNotEmpty).toList();
    } else {
      res = res.where((element) => element.nik == null || element.nik == '').toList();
    }
    setState(() {
      sikList = res;
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
        title: const Text('History'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : sikList.isEmpty
              ? Center(
                  child: LottieBuilder.asset(Assets.noDataAnimation),
                )
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
    return RefreshIndicator(
      onRefresh: () async {
        getHistory();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sikList.length,
        itemBuilder: (context, index) {
          final item = sikList[index];
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
              leading: CreatedDate(
                createdDate: item.createdDate,
              ),
              title: Text(item.nomorSik),
              children: [
                ListTile(
                  title: const Text('Alasan'),
                  subtitle: Text('Kepentingan ${item.kepentingan}, ${item.alasan}'),
                ),
                ListTile(
                  title: const Text('Tujuan'),
                  subtitle: Text(item.tujuan),
                ),
                ListTile(
                  title: const Text('Waktu Ijin'),
                  subtitle: Text(
                    '${item.jamKeluar.substring(0,5)} s/d ${item.jamMasuk.substring(0,5)}',
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
                                      onPressed: () async {
                                        var res = await api
                                            .deleteSuratIjinKeluar(item.nomorSik);
                                        if (res == null) {
                                          Get.back();
                                          Get.snackbar(
                                            'Informasi',
                                            'Data berhasil dihapus.',
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
            ),
          );
        },
      ),
    );
  }
}
