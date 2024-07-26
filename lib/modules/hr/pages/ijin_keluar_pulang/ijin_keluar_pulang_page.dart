import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/model/sik.dart';
import 'package:uapp/modules/hr/opt_emp_data_widget.dart';
import 'package:uapp/modules/hr/pages/ijin_keluar_pulang/api_param.dart';
import 'package:uapp/modules/hr/pages/ijin_keluar_pulang/api.dart' as api;
import 'package:uapp/modules/hr/pages/ijin_keluar_pulang/history_page.dart';

class IjinKeluarPulangPage extends StatefulWidget {
  const IjinKeluarPulangPage({super.key});

  @override
  State<IjinKeluarPulangPage> createState() => _IjinKeluarPulangPageState();
}

class _IjinKeluarPulangPageState extends State<IjinKeluarPulangPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Box box = Hive.box(HiveKeys.appBox);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController divisionController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController exitTimeController = TextEditingController();
  final TextEditingController returnTimeController = TextEditingController();

  bool isExpanded = false;
  bool isEditing = false;
  String selectedReason = '';
  int maxLines = 1;
  String? nomorSik;

  void getEmployeeData() {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    nameController.text = userData.nama;
    nikController.text = userData.id;
    departmentController.text = userData.department;
    divisionController.text = userData.bagian;
    positionController.text = userData.jabatan;
  }

  void clearForm() {
    destinationController.clear();
    reasonController.clear();
    exitTimeController.clear();
    returnTimeController.clear();
    setState(() {
      selectedReason = '';
      maxLines = 1;
    });
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
        title: const Text('Surat Ijin Keluar/Pulang'),
        actions: [
          IconButton(
            onPressed: () async {
              var item = await Get.to(() => HistoryPage(isMulti: false,));
              if (item != null) {
                var data = item as Sik;
                nomorSik = data.nomorSik;
                isEditing = true;
                destinationController.text = data.tujuan;
                selectedReason = data.kepentingan;
                reasonController.text = data.alasan;
                exitTimeController.text = data.jamKeluar.substring(0, 5);
                returnTimeController.text = data.jamMasuk.substring(0, 5);
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
                      if (value == null || value.isEmpty) {
                        return 'Tujuan tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Tujuan',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alasan tidak boleh kosong';
                      }
                      return null;
                    },
                    controller: reasonController,
                    onTap: () {},
                    maxLines: maxLines,
                    minLines: 1,
                    onChanged: (text) {
                      if (text.length % 50 == 0) {
                        setState(() {
                          maxLines++;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Alasan',
                      prefixIcon: const Icon(Icons.info),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jam keluar kosong';
                            }
                            return null;
                          },
                          controller: exitTimeController,
                          readOnly: true,
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                exitTimeController.text =
                                    value.format(context).toString();
                              }
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Jam Keluar',
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
                            if (value == null || value.isEmpty) {
                              return 'Jam kembali kosong';
                            }
                            return null;
                          },
                          controller: returnTimeController,
                          readOnly: true,
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                returnTimeController.text =
                                    value.format(context).toString();
                              }
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Jam Kembali',
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (selectedReason.isEmpty) {
                            Get.snackbar(
                              'Peringatan',
                              'Kepentingan harus dipilih',
                            );
                          } else {
                            var user = User.fromJson(
                                jsonDecode(box.get(HiveKeys.userData)));
                            var nik = user.id;
                            var data = ApiParams(
                              nik: nik,
                              method: isEditing
                                  ? HrMethodApi.editSuratIjinKeluarPulang
                                  : HrMethodApi.suratIjinKeluarPulang,
                              tujuan: destinationController.text,
                              kepentingan: selectedReason,
                              alasan: reasonController.text,
                              jamKeluar: exitTimeController.text,
                              jamMasuk: returnTimeController.text,
                            );
                            if (isEditing) {
                              data.nomorSik = nomorSik;
                            }
                            Get.dialog(
                              LoadingDialog(
                                message: isEditing
                                    ? 'Memperbarui ijin...'
                                    : 'Mengajukan ijin...',
                              ),
                              barrierDismissible: false,
                            );
                            api.addSuratIjinKeluar(data.toJson()).then((message) {
                              Get.back();
                              if (message == null) {
                                Get.snackbar(
                                  'Berhasil',
                                  isEditing
                                      ? 'Surat ijin keluar/pulang berhasil diubah'
                                      : 'Surat ijin keluar/pulang berhasil ditambahkan',
                                );
                                clearForm();
                                Get.to(() => HistoryPage(isMulti: false,));
                              } else {
                                Get.snackbar(
                                  'Gagal',
                                  message,
                                );
                              }
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        isEditing ? 'Perbarui' : 'Ajukan',
                      ),
                    ),
                  ),
                  // button to reset if editing
                  isEditing
                      ? IconButton(
                          onPressed: () {
                            clearForm();
                            setState(() {
                              isEditing = false;
                            });
                          },
                          icon: const Icon(Icons.lock_reset),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
