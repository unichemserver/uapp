import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/barang.dart';
import 'package:uapp/models/gudang.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/model/ptk.dart';
import 'package:uapp/modules/hr/opt_emp_data_widget.dart';
import 'package:uapp/modules/hr/pages/permintaan_naker/history_page_ptkb.dart';
import 'package:uapp/modules/hr/pages/rencana_lembur/api.dart' as api;
import 'package:uapp/modules/hr/pages/permintaan_naker/api.dart' as apiNaker;
import 'package:uapp/core/utils/date_utils.dart' as du;

import '../permintaan_naker/api_param.dart';

class PermintaanNakerBoronganPage extends StatefulWidget {
  const PermintaanNakerBoronganPage({super.key});

  @override
  State<PermintaanNakerBoronganPage> createState() => _PermintaanNakerBoronganPageState();
}

class _PermintaanNakerBoronganPageState extends State<PermintaanNakerBoronganPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Box box = Hive.box(HiveKeys.appBox);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController divisionController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController jamAwalController = TextEditingController();
  final TextEditingController jamAkhirController = TextEditingController();
  final TextEditingController tugasKerjaController = TextEditingController();
  final TextEditingController jumlahTenagaController = TextEditingController();

  final List<Barang> _listBarang = [];
  final List<Gudang> _listGudang = [];

  String? nomorPtk;
  bool isExpanded = false;
  bool isEditing = false;
  int selectedBarang = -1;
  int selectedGudang = -1;

  void getEmployeeData() {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    nameController.text = userData.nama;
    nikController.text = userData.id;
    departmentController.text = userData.department;
    divisionController.text = userData.bagian;
    positionController.text = userData.jabatan;
  }

  void getDataUtils() async {
    final data = await api.getDataUtils();
    if (data.isNotEmpty) {
      final listBarang = data['barang'] as List;
      final listGudang = data['gudang'] as List;

      _listBarang.addAll(listBarang.map((e) => Barang.fromJson(e)));
      _listBarang.removeWhere((element) => element.namaBarang.isEmpty);
      _listGudang.addAll(listGudang.map((e) => Gudang.fromJson(e)));
      setState(() {});
      if (Get.isDialogOpen!) {
        Get.back();
      }
    }
  }

  void clearForm() {
    tglAwalController.clear();
    tglAkhirController.clear();
    jamAwalController.clear();
    jamAkhirController.clear();
    tugasKerjaController.clear();
    jumlahTenagaController.clear();
    selectedBarang = -1;
    selectedGudang = -1;
  }

  void _ajukanPermintaan() async {
    if (_formKey.currentState!.validate()) {
      final params = ApiParams(
        method: isEditing
            ? HrMethodApi.editPermintaanNakerBorongan
            : HrMethodApi.formPermintaanNakerBorongan,
        nik: nikController.text,
        barang: _listBarang[selectedBarang].id,
        gudang: _listGudang[selectedGudang].id,
        tglAwal: tglAwalController.text,
        tglAkhir: tglAkhirController.text,
        jamAwal: jamAwalController.text,
        jamAkhir: jamAkhirController.text,
        tugasKerja: tugasKerjaController.text,
        tenagaKerja: jumlahTenagaController.text,
      );
      if (isEditing) {
        params.nomorPtk = nomorPtk;
      }
      Get.dialog(
        LoadingDialog(
          message:
          isEditing ? 'Mengedit permintaan...' : 'Mengajukan permintaan...',
        ),
        barrierDismissible: false,
      );
      String? result = await apiNaker.addPermintaanNakerBorongan(params);
      if (Get.isDialogOpen!) {
        Get.back();
      }
      if (result != null) {
        Get.snackbar(
          'Gagal',
          result,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        clearForm();
        setState(() {
          isEditing = false;
        });
        Get.snackbar(
          'Berhasil',
          'Permintaan tenaga kerja berhasil ${isEditing ? 'diubah' : 'diajukan'}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        const LoadingDialog(
          message: 'Mengambil data...',
        ),
        barrierDismissible: false,
      );
      getDataUtils();
    });
    getEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Permintaan Tenaga Kerja'),
        actions: [
          IconButton(
            onPressed: () async {
              var item = await Get.to(() => HistoryPage());
              if (item != null) {
                var data = item as Ptk;
                isEditing = true;
                nomorPtk = data.nomorPtk;
                tglAwalController.text = data.tglAwal;
                tglAkhirController.text = data.tglAkhir;
                jamAwalController.text = data.jamAwal.substring(0, 5);
                jamAkhirController.text = data.jamAkhir.substring(0, 5);
                tugasKerjaController.text = data.tugasKerja;
                jumlahTenagaController.text = data.tenagaKerja;
                selectedBarang = _listBarang
                    .indexWhere((element) => element.id == data.barang);
                selectedGudang = _listGudang
                    .indexWhere((element) => element.id == data.gudang);
                setState(() {});
              }
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: nameController,
                    readOnly: true,
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      suffixIcon: Icon(
                        isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(
                      milliseconds: 750,
                    ),
                    opacity: isExpanded ? 1 : 0,
                    curve: Curves.easeInOut,
                    child: isExpanded
                        ? AdditionalEmployeeData(
                      nikController: nikController,
                      departmentController: departmentController,
                      divisionController: divisionController,
                      positionController: positionController,
                    )
                        : const SizedBox(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Barang:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  DropdownSearch<Barang>(
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return 'Barang harus dipilih';
                      }
                      return null;
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: 'Pilih Barang',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.shopping_cart),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                    items: _listBarang,
                    itemAsString: (item) => item.namaBarang,
                    onChanged: (value) {
                      setState(() {
                        selectedBarang = _listBarang.indexOf(value!);
                      });
                    },
                    selectedItem: selectedBarang != -1
                        ? _listBarang[selectedBarang]
                        : null,
                    popupProps: PopupProps.modalBottomSheet(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gudang:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  DropdownSearch<Gudang>(
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return 'Gudang harus dipilih';
                      }
                      return null;
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: 'Pilih Gudang',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                    items: _listGudang,
                    itemAsString: (item) => item.namaGudang,
                    onChanged: (value) {
                      setState(() {
                        selectedGudang = _listGudang.indexOf(value!);
                      });
                    },
                    selectedItem: selectedGudang != -1
                        ? _listGudang[selectedGudang]
                        : null,
                    popupProps: PopupProps.modalBottomSheet(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Tgl Awal kosong';
                            }
                            return null;
                          },
                          controller: tglAwalController,
                          readOnly: true,
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2015, 8),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null) {
                              tglAwalController.text =
                                  du.DateUtils.getYMDFormat(picked);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Tgl Awal',
                            prefixIcon: const Icon(Icons.date_range),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Tgl Akhir kosong';
                            }
                            return null;
                          },
                          controller: tglAkhirController,
                          readOnly: true,
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2015, 8),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null) {
                              tglAkhirController.text =
                                  du.DateUtils.getYMDFormat(picked);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Tgl Akhir',
                            prefixIcon: const Icon(Icons.date_range),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // jam awal dan jam akhir
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Jam Awal kosong';
                            }
                            return null;
                          },
                          controller: jamAwalController,
                          readOnly: true,
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              jamAwalController.text = picked.format(context);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Jam Awal',
                            prefixIcon: const Icon(Icons.access_time),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Jam Akhir kosong';
                            }
                            return null;
                          },
                          controller: jamAkhirController,
                          readOnly: true,
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              jamAkhirController.text = picked.format(context);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Jam Akhir',
                            prefixIcon: const Icon(Icons.access_time),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tugas Kerja kosong';
                      }
                      return null;
                    },
                    maxLines: 3,
                    controller: tugasKerjaController,
                    decoration: InputDecoration(
                      labelText: 'Tugas Kerja',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.work),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Jumlah tenaga kerja kosong';
                      }
                      return null;
                    },
                    controller: jumlahTenagaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Jumlah tenaga kerja yang dibutuhkan',
                      prefixIcon: const Icon(Icons.people),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      suffixText: 'Orang',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _ajukanPermintaan,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        minimumSize: const Size(double.infinity, 0),
                      ),
                      child: Text(
                        isEditing ? 'Edit Permintaan' : 'Ajukan Permintaan',
                      ),
                    ),
                  ),
                  isEditing
                      ? IconButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                        clearForm();
                      });
                    },
                    icon: const Icon(Icons.lock_reset_outlined),
                  )
                      : SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}