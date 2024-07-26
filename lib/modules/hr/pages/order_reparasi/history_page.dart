import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/api.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/api_param.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<ApiParams> data = <ApiParams>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getORP().then((value) {
      isLoading = false;
      data = value;
      setState(() {});
    });
  }

  String jeniPeralatan(String jenis) {
    if (jenis == '1') {
      return 'Peralatan Non IT';
    } else if (jenis == '2') {
      return 'Peralatan IT';
    } else {
      return 'Kendaraan/Alat Berat';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Order Reparasi'),
      ),
      body: FutureBuilder<List<ApiParams>>(
        future: getORP(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}\nSilahkan coba tarik ke bawah untuk memuat ulang',
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Data tidak ditemukan'),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                data = await getORP();
                setState(() {});
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(data[index].nomorOrder!),
                      subtitle: Text(jeniPeralatan(data[index].jenisAlat)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: const Text(
                                      'Apakah Anda yakin ingin menghapus data ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        Get.dialog(
                                          const LoadingDialog(
                                            message: 'Menghapus Data',
                                          ),
                                          barrierDismissible: false,
                                        );
                                        deleteORP(data[index].nomorOrder!)
                                            .then((value) {
                                          Get.back();
                                          if (value == null) {
                                            Get.snackbar('Berhasil',
                                                'Data berhasil dihapus');
                                            data.removeAt(index);
                                            setState(() {});
                                          } else {
                                            Get.snackbar('Gagal', value);
                                          }
                                        });
                                      },
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
