import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/opt_emp_data_widget.dart';
import 'package:uapp/core/utils/date_utils.dart' as du;
import 'package:uapp/modules/hr/pages/dinas_luar/api.dart' as api;
import 'package:uapp/modules/hr/pages/dinas_luar/api_param.dart';
import 'package:uapp/modules/hr/pages/dinas_luar/history_page.dart';

class DinasLuarPage extends StatefulWidget {
  const DinasLuarPage({super.key});

  @override
  State<DinasLuarPage> createState() => _DinasLuarPageState();
}

class _DinasLuarPageState extends State<DinasLuarPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Box box = Hive.box(HiveKeys.appBox);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController divisionController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController departureDateTimeController =
      TextEditingController();
  final TextEditingController arrivalDateTimeController =
      TextEditingController();

  bool isExpanded = false;
  bool isEditing = false;
  String? nomorTdl;

  void getEmployeeData() {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    nameController.text = userData.nama;
    nikController.text = userData.id;
    departmentController.text = userData.namaDepartment;
    divisionController.text = userData.namaBagian;
    positionController.text = userData.namaJabatan;
  }

  void clearText() {
    destinationController.clear();
    purposeController.clear();
    departureDateTimeController.clear();
    arrivalDateTimeController.clear();
  }

  @override
  void initState() {
    super.initState();
    getEmployeeData();
  }

  @override
  void dispose() {
    nameController.dispose();
    nikController.dispose();
    departmentController.dispose();
    divisionController.dispose();
    positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Dinas Luar'),
        actions: [
          IconButton(
            onPressed: () async {
              var item = await Get.to(() => const HistoryPage());
              if (item != null) {
                destinationController.text = item.tujuanDinas;
                purposeController.text = item.keperluan;
                departureDateTimeController.text =
                    '${item.tglBerangkat} - ${item.jamBerangkat}';
                arrivalDateTimeController.text =
                    '${item.tglKembali} - ${item.jamKembali}';
                isEditing = true;
                nomorTdl = item.nomorTdl;
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
                  TextFormField(
                    controller: destinationController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tujuan dinas tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Tujuan Dinas',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: purposeController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Keperluan tidak boleh kosong';
                      }
                      return null;
                    },
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: 'Keperluan',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Berangkat:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: departureDateTimeController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tanggal dan waktu berangkat tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Tanggal dan Waktu Berangkat',
                      prefixIcon: const Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      ).then((date) {
                        if (date != null) {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((time) {
                            departureDateTimeController.text =
                                '${du.DateUtils.getYMDFormat(date)} - ${time!.format(context)}';
                          });
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Estimasi Kembali:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: arrivalDateTimeController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tanggal dan waktu kembali tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Tanggal dan Waktu Kembali',
                      prefixIcon: const Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      ).then((date) {
                        if (date != null) {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((time) {
                            arrivalDateTimeController.text =
                                '${du.DateUtils.getYMDFormat(date)} - ${time!.format(context)}';
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var tglBerangkat =
                        departureDateTimeController.text.split(' - ')[0];
                    var jamBerangkat =
                        departureDateTimeController.text.split(' - ')[1];
                    var tglKembali =
                        arrivalDateTimeController.text.split(' - ')[0];
                    var jamKembali =
                        arrivalDateTimeController.text.split(' - ')[1];
                    var userData =
                        User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
                    var data = ApiParams(
                      method: isEditing
                          ? HrMethodApi.editTugasDinasLuar
                          : HrMethodApi.tugasDinasLuar,
                      nik: userData.id,
                      tujuanDinas: destinationController.text,
                      keperluan: purposeController.text,
                      tglBerangkat: tglBerangkat,
                      jamBerangkat: jamBerangkat,
                      tglKembali: tglKembali,
                      jamKembali: jamKembali,
                    );
                    if (isEditing) {
                      data.nomorTdl = nomorTdl;
                    }
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const LoadingDialog(
                          message: 'Menyimpan data...',
                        );
                      },
                    );
                    api.addDinasLuar(data).then((value) {
                      Navigator.pop(context);
                      if (value == null) {
                        Get.snackbar(
                          'Berhasil',
                          'Data berhasil disimpan',
                        );
                        clearText();
                        Get.to(() => const HistoryPage());
                      } else {
                        Get.snackbar(
                          'Gagal',
                          value,
                        );
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
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
