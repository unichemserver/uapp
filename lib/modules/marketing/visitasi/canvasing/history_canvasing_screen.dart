import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/alarm_manager.dart';
import 'package:uapp/core/utils/utils.dart';

class HistoryCanvasingScreen extends StatefulWidget {
  const HistoryCanvasingScreen({super.key});

  @override
  State<HistoryCanvasingScreen> createState() => _HistoryCanvasingScreenState();
}

class _HistoryCanvasingScreenState extends State<HistoryCanvasingScreen> {
  final box = Hive.box(HiveKeys.appBox);
  final db = DatabaseHelper();
  bool isSyncing = false;

  toggleSyncing(bool value) {
    setState(() {
      isSyncing = value;
    });
  }

  deleteData(Map<String, dynamic> data) async {
    await db.deleteCanvasing(data['CustID']);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    box.watch(key: HiveKeys.isSyncing).listen((event) {
      toggleSyncing(event.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History Canvasing',
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: isSyncing
                ? null
                : () async {
                    if (!(await Utils.isInternetAvailable())) {
                      Get.snackbar(
                        'Sinkronisasi Data',
                        'Tidak ada koneksi internet',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    scheduleUploadData();
                  },
            icon: const Icon(
              Icons.sync,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: const Text('Konfirmasi'),
              content: const Text(
                'Apakah anda yakin ingin melakukan canvasing?',
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
                    Get.back();
                    Get.toNamed(Routes.CANVASING)?.then((value) async {
                      setState(() {});
                      if (!(await Utils.isInternetAvailable())) {
                        Get.snackbar(
                          'Sinkronisasi Data',
                          'Tidak ada koneksi internet',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      scheduleUploadData();
                    });
                  },
                  child: const Text('Lanjut'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add_business_outlined),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseHelper().getCanvasingList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Data tidak ditemukan'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: data['waktu_co'] == null
                        ? Colors.amberAccent[100]
                        : data['status_sync'] == 1
                            ? Colors.green[100]
                            : Colors.red[100],
                    title: Text('Nama Toko: ${data['nama_outlet']}'),
                    subtitle: Text('Nama Owner: ${data['nama_owner']}'),
                    trailing: data['waktu_co'] == null
                        ? const Icon(Icons.sync_disabled)
                        : data['status_sync'] == 1
                            ? const Icon(Icons.check_circle)
                            : IconButton(
                                onPressed: isSyncing
                                    ? null
                                    : () {
                                        _syncData(data);
                                      },
                                icon: const Icon(Icons.sync),
                              ),
                    onTap: () {
                      if (data['waktu_co'] == null) {
                        _confirmationDialog(data);
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  _syncData(Map<String, dynamic> data) async {
    if (!(await Utils.isInternetAvailable())) {
      Get.snackbar(
        'Sinkronisasi Data',
        'Tidak ada koneksi internet',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text(
                'Sedang menyinkronkan data...\nHarap tunggu...',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Tutup'),
              ),
            ],
          ),
        ),
      ),
    );
    var result = await uploadReportData(db, data['id']);
    if (Get.isDialogOpen!) {
      Get.back();
    }
    setState(() {});
    if (result != null) {
      Get.snackbar(
        'Sinkronisasi Data',
        'Data berhasil disinkronisasi',
        backgroundColor: Colors.green,
      );
    } else {
      Get.snackbar(
        'Sinkronisasi Data',
        'Data gagal disinkronisasi',
        backgroundColor: Colors.red,
      );
    }
  }

  _confirmationDialog(Map<String, dynamic> data) {
    print(data);
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text(
          'Apa yang ingin anda lakukan?',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Get.back();
              deleteData(data).then((value) {
                setState(() {});
              });
            },
            child: const Text('Hapus'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              Get.toNamed(Routes.CANVASING, arguments: data)?.then((value) {
                setState(() {});
                scheduleUploadData();
              });
            },
            child: const Text('Lanjut'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }
}
