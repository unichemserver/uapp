import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/app/strings.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/model/mdt.dart';
import 'package:uapp/modules/hr/opt_emp_data_widget.dart';
import 'package:uapp/core/utils/date_utils.dart' as du;
import 'package:uapp/modules/hr/pages/datang_terlambat/api.dart' as api;
import 'package:uapp/modules/hr/pages/datang_terlambat/api_param.dart';
import 'package:uapp/modules/hr/pages/datang_terlambat/history_page.dart';

class DatangTerlambatPage extends StatefulWidget {
  const DatangTerlambatPage({super.key});

  @override
  State<DatangTerlambatPage> createState() => _DatangTerlambatPageState();
}

class _DatangTerlambatPageState extends State<DatangTerlambatPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Box box = Hive.box(HiveKeys.appBox);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController divisionController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController lateController = TextEditingController();

  bool isExpanded = false;
  bool isEditing = false;
  String selectedReason = '';
  String? nomorMdt;

  void getEmployeeData() {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    nameController.text = userData.nama;
    nikController.text = userData.id;
    departmentController.text = userData.department;
    divisionController.text = userData.bagian;
    positionController.text = userData.jabatan;
  }

  void clearForm() {
    dateController.clear();
    timeController.clear();
    reasonController.clear();
    lateController.clear();
    selectedReason = '';
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
    dateController.dispose();
    timeController.dispose();
    reasonController.dispose();
    lateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ijin Datang Terlambat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () async {
              var item = await Get.to(() => HistoryPage());
              if (item != null) {
                var data = item as Mdt;
                nomorMdt = data.nomorMdt;
                dateController.text = data.tgl;
                timeController.text = data.jam.substring(0, 5);
                lateController.text = data.terlambat;
                reasonController.text = data.keperluan;
                setState(() {
                  selectedReason = Strings.toTitleWord(data.kepentingan);
                  isEditing = true;
                });
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
                    controller: dateController,
                    readOnly: true,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 7)),
                      ).then((value) {
                        if (value != null) {
                          dateController.text = du.DateUtils.getYMDFormat(value);
                        }
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tanggal tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: timeController,
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Kosong';
                            }
                            return null;
                          },
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                timeController.text = value.format(context);
                              }
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Jam',
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
                        flex: 2,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          controller: lateController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Kosong';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Terlambat',
                            prefixIcon: const Icon(Icons.timer_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            suffixText: 'Menit',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Kepentingan:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Row(
                          children: [
                            Icon(Icons.business),
                            SizedBox(width: 8),
                            Text('Perusahaan'),
                          ],
                        ),
                        selected: selectedReason == 'Perusahaan',
                        onSelected: (value) {
                          setState(() {
                            selectedReason = 'Perusahaan';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 8),
                            Text('Pribadi'),
                          ],
                        ),
                        selected: selectedReason == 'Pribadi',
                        onSelected: (value) {
                          setState(() {
                            selectedReason = 'Pribadi';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: reasonController,
                    maxLines: 2,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Alasan tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Alasan',
                      prefixIcon: const Icon(Icons.text_fields),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (selectedReason.isEmpty) {
                      Get.snackbar(
                        'Peringatan',
                        'Pilih kepentingan terlebih dahulu',
                      );
                      return;
                    }
                    var userData =
                        User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
                    var data = ApiParams(
                      method: isEditing
                          ? HrMethodApi.editDatangTerlambat
                          : HrMethodApi.masukDatangTerlambat,
                      nik: userData.id,
                      tgl: dateController.text,
                      jam: timeController.text,
                      terlambat: lateController.text,
                      kepentingan: selectedReason.toLowerCase(),
                      keperluan: reasonController.text,
                    );
                    if (isEditing) {
                      data.nomorMdt = nomorMdt;
                    }
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const LoadingDialog(
                          message: 'Menyimpan data...',
                        );
                      },
                    );
                    api.addDatangTerlambat(data).then((value) {
                      Navigator.pop(context);
                      if (value == null) {
                        Get.snackbar(
                          'Berhasil',
                          'Data berhasil disimpan',
                        );
                        setState(() {
                          isEditing = false;
                        });
                        clearForm();
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
