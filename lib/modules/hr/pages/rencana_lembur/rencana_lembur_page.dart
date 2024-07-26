import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/alat_berat.dart';
import 'package:uapp/models/barang.dart';
import 'package:uapp/models/gudang.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/model/rc.dart';
import 'package:uapp/modules/hr/opt_emp_data_widget.dart';
import 'package:uapp/core/utils/date_utils.dart' as du;
import 'package:uapp/modules/hr/pages/rencana_lembur/api.dart' as api;
import 'package:uapp/modules/hr/pages/rencana_lembur/api_param.dart';
import 'package:uapp/modules/hr/pages/rencana_lembur/history_page.dart';

class RencanaLemburPage extends StatefulWidget {
  const RencanaLemburPage({super.key});

  @override
  State<RencanaLemburPage> createState() => _RencanaLemburPageState();
}

class _RencanaLemburPageState extends State<RencanaLemburPage> {
  final Box box = Hive.box(HiveKeys.appBox);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController divisionController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController workerController = TextEditingController();

  final List<Barang> _listBarang = [];
  final List<Gudang> _listGudang = [];
  final List<AlatBerat> _listAlatBerat = [];
  List<AlatBerat> selectedAlatBerat = [];

  bool isExpanded = false;
  bool isEditing = false;
  int selectedBarang = -1;
  int selectedGudang = -1;
  String? nomorRc;

  void getDataUtils() async {
    final data = await api.getDataUtils();
    if (data.isNotEmpty) {
      final listBarang = data['barang'] as List;
      final listGudang = data['gudang'] as List;
      final listAlatBerat = data['alat_berat'] as List;

      _listBarang.addAll(listBarang.map((e) => Barang.fromJson(e)));
      _listGudang.addAll(listGudang.map((e) => Gudang.fromJson(e)));
      _listAlatBerat.addAll(listAlatBerat.map((e) => AlatBerat.fromJson(e)));
      setState(() {});
      if (Get.isDialogOpen!) {
        Get.back();
      }
    }
  }

  void getEmployeeData() {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    nameController.text = userData.nama;
    nikController.text = userData.id;
    departmentController.text = userData.namaDepartment;
    divisionController.text = userData.namaBagian;
    positionController.text = userData.namaJabatan;
  }

  void clearForm() {
    dateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    taskController.clear();
    workerController.clear();
    selectedBarang = -1;
    selectedGudang = -1;
    selectedAlatBerat.clear();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(const LoadingDialog(
        message: 'Mengambil data...',
      ));
    });
    getEmployeeData();
    getDataUtils();
  }

  @override
  void dispose() {
    nameController.dispose();
    nikController.dispose();
    departmentController.dispose();
    divisionController.dispose();
    positionController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    taskController.dispose();
    workerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Rencana Lembur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () async {
              var item = await Get.to(() => const HistoryPage());
              if (item != null) {
                isEditing = true;
                var data = item as Rc;
                nomorRc = data.nomorRc;
                dateController.text = data.tgl;
                startTimeController.text = data.jamAwal.substring(0, 5);
                endTimeController.text = data.jamAkhir.substring(0, 5);
                taskController.text = data.tugasKerja;
                workerController.text = data.tenagaKerja;
                selectedBarang = _listBarang
                    .indexWhere((element) => element.id == data.barang);
                selectedGudang = _listGudang
                    .indexWhere((element) => element.id == data.gudang);
                selectedAlatBerat.clear();
                if (data.bantuanAlat != null && data.bantuanAlat!.isNotEmpty) {
                  data.bantuanAlat?.split(',').forEach((element) {
                    selectedAlatBerat.add(
                      _listAlatBerat.firstWhere((e) => e.id == element),
                    );
                  });
                }
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: 'Pilih Gudang',
                        prefixIcon: const Icon(Icons.home),
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
                  Text(
                    'Tanggal dan Waktu Lembur:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tanggal harus diisi';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      ).then((value) {
                        if (value != null) {
                          dateController.text =
                              du.DateUtils.getYMDFormat(value);
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Tanggal Lembur',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: startTimeController,
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Jam mulai harus diisi';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                startTimeController.text =
                                    value.format(context);
                              }
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Jam Mulai',
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: endTimeController,
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Jam selesai harus diisi';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                endTimeController.text = value.format(context);
                              }
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Jam Selesai',
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
                  Text(
                    'Tugas Kerja:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: taskController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tugas kerja harus diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Tugas kerja yang akan dilakukan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.work),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Jumlah Tenaga Kerja:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: workerController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Jumlah tenaga kerja harus diisi';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  const SizedBox(height: 16),
                  Text(
                    'Bantuan Alat Berat:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 2,
                    children: List.generate(
                      _listAlatBerat.length,
                      (index) {
                        return ChoiceChip(
                          label: Text(_listAlatBerat[index].namaJenisAlatBerat),
                          selected:
                              selectedAlatBerat.contains(_listAlatBerat[index]),
                          onSelected: (value) {
                            setState(() {
                              if (value) {
                                selectedAlatBerat.add(_listAlatBerat[index]);
                              } else {
                                selectedAlatBerat.remove(_listAlatBerat[index]);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  bool isValid = _formKey.currentState!.validate();
                  if (isValid) {
                    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
                    var gudang = selectedGudang == -1
                        ? ''
                        : _listGudang[selectedGudang].id;
                    var barang = selectedBarang == -1
                        ? ''
                        : _listBarang[selectedBarang].id;
                    var method = isEditing
                        ? HrMethodApi.editRencanaLembur
                        : HrMethodApi.formRencanaLembur;
                    List<String> sortedIds = selectedAlatBerat
                        .map((e) => e.id)
                        .toList()
                      ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
                    var data = ApiParams(
                      nik: userData.id,
                      gudang: gudang,
                      barang: barang,
                      method: method,
                      tanggal: dateController.text,
                      jamAwal: startTimeController.text,
                      jamAkhir: endTimeController.text,
                      tugasKerja: taskController.text,
                      tenagaKerja: workerController.text,
                      bantuanAlatBerat: sortedIds.join(','),
                    );
                    Get.dialog(const LoadingDialog(
                      message: 'Menyimpan data...',
                    ));
                    if (isEditing) {
                      data.nomorRc = nomorRc;
                    }
                    print(data.toJson());
                    api.addRencanaLembur(data).then((value) {
                      if (value == null) {
                        Get.back();
                        Get.snackbar(
                          'Berhasil',
                          'Data berhasil disimpan',
                        );
                        setState(() {
                          isEditing = false;
                          nomorRc = null;
                        });
                        clearForm();
                        Get.to(() => const HistoryPage());
                      } else {
                        Get.back();
                        Get.snackbar(
                          'Gagal',
                          value,
                        );
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  isEditing ? 'Simpan Perubahan' : 'Simpan',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
