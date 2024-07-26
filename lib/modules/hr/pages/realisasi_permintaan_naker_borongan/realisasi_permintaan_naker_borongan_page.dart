import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/alat_berat.dart';
import 'package:uapp/models/barang.dart';
import 'package:uapp/models/contact.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/pages/realisasi_lembur/temp_data.dart';
import 'package:uapp/modules/hr/pages/realisasi_lembur/temp_data_widget.dart';
import 'package:uapp/modules/hr/pages/realisasi_permintaan_naker/nomor_ptk.dart';
import 'package:uapp/modules/hr/pages/realisasi_permintaan_naker/screen/alat_berat_screen.dart';
import 'package:uapp/modules/hr/pages/realisasi_permintaan_naker/screen/karyawan_screen.dart';
import 'package:uapp/modules/hr/pages/rencana_lembur/api.dart' as alberapi;
import 'package:uapp/modules/hr/pages/realisasi_permintaan_naker/api.dart'
    as api;
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/pages/realisasi_permintaan_naker/api_params.dart';

class RealisasiPermintaanNakerBoronganPage extends StatefulWidget {
  const RealisasiPermintaanNakerBoronganPage({super.key});

  @override
  State<RealisasiPermintaanNakerBoronganPage> createState() =>
      _RealisasiPermintaanNakerBoronganPageState();
}

class _RealisasiPermintaanNakerBoronganPageState
    extends State<RealisasiPermintaanNakerBoronganPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _tglLemburController = TextEditingController();
  late TabController _tabController;
  final db = DatabaseHelper();
  final pageController = PageController();
  final box = Hive.box(HiveKeys.appBox);
  List<NomorPtk> listNomorPtk = [];
  List<TempData> savedTempData = [];
  List<AlatBerat> selectedAlatBerat = [];
  List<AlatBerat> listAlatBerat = [
    AlatBerat(
      id: '',
      namaJenisAlatBerat: 'Pilih Alat Berat',
    )
  ];
  List<Barang> listBarang = [
    Barang(
      id: '',
      namaBarang: 'Pilih Barang',
    )
  ];
  List<Contact> listKaryawan = [
    Contact(
      id: '',
      name: 'Pilih Karyawan',
      nickName: '',
      jekel: '',
      foto: '',
      jabatan: '',
      bagian: '',
    )
  ];
  String selectedNomorPtk = '';

  Future<void> getKaryawan() async {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    var listKaryawan = await db.getContact(userData.id);
    setState(() {
      this.listKaryawan.addAll(listKaryawan);
    });
  }

  Future<void> getAlatBerat() async {
    var data = await alberapi.getDataUtils();
    var dataAlatBerat = data['alat_berat'] as List;
    var dataBarang = data['barang'] as List;
    var listBarang = dataBarang.map((e) => Barang.fromJson(e)).toList();
    var listAlatBerat =
        dataAlatBerat.map((e) => AlatBerat.fromJson(e)).toList();
    setState(() {
      this.listAlatBerat.addAll(listAlatBerat);
      this.listBarang.addAll(listBarang);
    });
  }

  Future<void> getNomorPTKB() async {
    var listNomorPtk = await api.getNomorPtk(true);
    setState(() {
      listNomorPtk.addAll(listNomorPtk);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        const LoadingDialog(
          message: 'Mendapatkan data...',
        ),
        barrierDismissible: false,
      );
      Future.wait([
        getKaryawan(),
        getAlatBerat(),
        getNomorPTKB(),
      ]).then((value) {
        Get.back();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Realisasi Permintaan Naker',
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (selectedNomorPtk.isEmpty) {
                Get.snackbar(
                  'Peringatan',
                  'Nomor rencana lembur belum dipilih',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              if (_tglLemburController.text.isEmpty) {
                Get.snackbar(
                  'Peringatan',
                  'Tanggal lembur belum dipilih',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              if (savedTempData.isEmpty) {
                Get.snackbar(
                  'Peringatan',
                  'Data masih kosong',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              var userData =
                  User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
              var noNik = userData.id;
              var nik = savedTempData
                  .where((element) => element.isKaryawan)
                  .map((e) => e.id)
                  .join(',');
              var jamAwal = savedTempData
                  .where((element) => element.isKaryawan)
                  .map((e) => e.jamMasuk)
                  .join(',');
              var jamAkhir = savedTempData
                  .where((element) => element.isKaryawan)
                  .map((e) => e.jamPulang)
                  .join(',');
              var keterangan = savedTempData
                  .where((element) => element.isKaryawan)
                  .map((e) => e.keterangan)
                  .join(',');
              var alatBerat = savedTempData
                  .where((element) => !element.isKaryawan)
                  .map((e) => e.id)
                  .join(',');
              var jamAwalAlatBerat = savedTempData
                  .where((element) => !element.isKaryawan)
                  .map((e) => e.jamMasuk)
                  .join(',');
              var jamAkhirAlatBerat = savedTempData
                  .where((element) => !element.isKaryawan)
                  .map((e) => e.jamPulang)
                  .join(',');
              var keteranganAlatBerat = savedTempData
                  .where((element) => !element.isKaryawan)
                  .map((e) => e.keterangan)
                  .join(',');
              var barang = savedTempData
                  .where((element) => element.isKaryawan)
                  .map((e) => e.namaBarang)
                  .join(',');

              var data = ApiParams(
                nomorPtk: selectedNomorPtk,
                noNik: noNik,
                barang: barang,
                method: HrMethodApi.formRealisasiNakerBorongan,
                tgl: _tglLemburController.text,
                nik: nik,
                jamAwal: jamAwal,
                jamAkhir: jamAkhir,
                keterangan: keterangan,
                alatBerat: alatBerat,
                jamAwalAlatBerat: jamAwalAlatBerat,
                jamAkhirAlatBerat: jamAkhirAlatBerat,
                keteranganAlatBerat: keteranganAlatBerat,
                isBorongan: true,
              );
              Get.dialog(const LoadingDialog(
                message: 'Menyimpan data...',
              ));
              api.addRealisasiNaker(data).then((message) {
                Get.back();
                if (message == null) {
                  Get.snackbar(
                    'Sukses',
                    'Data berhasil disimpan',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                  setState(() {
                    savedTempData.clear();
                  });
                } else {
                  Get.snackbar(
                    'Gagal',
                    message,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              });
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownSearch<NomorPtk>(
              items: listNomorPtk,
              itemAsString: (NomorPtk nomorRencanLembur) =>
                  nomorRencanLembur.ptk,
              onChanged: (NomorPtk? nomorRencanLembur) {
                selectedNomorPtk = nomorRencanLembur!.ptk;
                _tglLemburController.text =
                    '${nomorRencanLembur.tglAwal} - ${nomorRencanLembur.tglAkhir}';
              },
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: 'Pilih Permintaan Tenaga Kerja',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: TextFormField(
              controller: _tglLemburController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Tanggal Lembur',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Karyawan'),
              Tab(text: 'Alat Berat'),
            ],
            dividerHeight: 0,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                KaryawanScreen(
                  tempData: savedTempData,
                  listKaryawan: listKaryawan,
                  listBarang: listBarang,
                  onSaved: (TempData tempData) {
                    print(tempData.namaBarang);
                    setState(() {
                      savedTempData.add(tempData);
                    });
                  },
                ),
                AlatBeratScreen(
                  tempData: savedTempData,
                  listAlatBerat: listAlatBerat,
                  onSaved: (TempData tempData) {
                    setState(() {
                      savedTempData.add(tempData);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () {
              if (savedTempData.isEmpty) {
                Get.snackbar(
                  'Peringatan',
                  'Data masih kosong',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              Get.to(
                () => TempDataWidget(
                  tempData: savedTempData,
                  onDelete: (TempData tempData) {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Peringatan'),
                        content: Text(
                          'Apakah anda yakin ingin menghapus ${tempData.nama} dari daftar ${tempData.isKaryawan ? 'karyawan' : 'alat berat'} realisasi lembur ini?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Tidak'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                savedTempData.remove(tempData);
                              });
                              Get.back();
                              Get.back();
                            },
                            child: const Text('Ya'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            child: const Icon(Icons.list_alt),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: savedTempData.isEmpty
                ? SizedBox()
                : Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${savedTempData.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
