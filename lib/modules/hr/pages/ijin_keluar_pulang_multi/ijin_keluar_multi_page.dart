import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/contact.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/opt_emp_data_widget.dart';
import 'package:uapp/modules/hr/pages/ijin_keluar_pulang//api.dart' as api;
import 'package:uapp/modules/hr/pages/ijin_keluar_pulang_multi/api_param.dart';

import '../ijin_keluar_pulang/history_page.dart';

class IjinKeluarMultiPage extends StatefulWidget {
  const IjinKeluarMultiPage({super.key});

  @override
  State<IjinKeluarMultiPage> createState() => _IjinKeluarMultiPageState();
}

class _IjinKeluarMultiPageState extends State<IjinKeluarMultiPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Box box = Hive.box(HiveKeys.appBox);
  final db = DatabaseHelper();
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
  List<Contact> nikKaryawan = [];
  List<Contact> selectedNik = [];

  void getEmployeeData() {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    nameController.text = userData.nama;
    nikController.text = userData.id;
    departmentController.text = userData.namaDepartment;
    divisionController.text = userData.namaBagian;
    positionController.text = userData.namaJabatan;
  }

  getListContacts() async {
    final userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final selfId = userData.id;
    final List<Contact> availableContacts = await db.getContact(selfId);
    nikKaryawan.clear();
    setState(() {
      nikKaryawan.addAll(availableContacts);
    });
  }

  void clearForm() {
    _formKey.currentState!.reset();
    setState(() {
      selectedReason = '';
      maxLines = 1;
      selectedNik.clear();
    });
  }

  void simpanData() async {
    bool isValid = _formKey.currentState!.validate() &&
        selectedReason.isNotEmpty &&
        selectedNik.isNotEmpty;
    if (isValid) {
      var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
      var noNik = userData.id;
      var nik = selectedNik.map((e) => e.id).join(',');
      var data = ApiParams(
        noNik: noNik,
        method: isEditing
            ? HrMethodApi.editSuratKeluarPulangMulti
            : HrMethodApi.suratKeluarPulangMulti,
        tujuan: destinationController.text,
        kepentingan: selectedReason,
        alasan: reasonController.text,
        jamKeluar: exitTimeController.text,
        jamMasuk: returnTimeController.text,
        nik: nik,
      );
      if (isEditing) {
        data.nomorSik = nomorSik;
      }
      Get.dialog(
        const LoadingDialog(
          message: 'Menyimpan data...',
        ),
        barrierDismissible: false,
      );
      String? result = await api.addSuratIjinKeluar(data.toJson());
      Get.back();
      if (result != null) {
        Get.snackbar(
          'Gagal',
          result,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Berhasil',
          'Data berhasil disimpan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clearForm();
      }
    } else {
      Get.snackbar(
        'Gagal',
        'Data tidak lengkap',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getEmployeeData();
    getListContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ijin Keluar/Pulang Multi'),
        actions: [
          IconButton(
            onPressed: () async {
              var item = await Get.to(() => const HistoryPage(
                    isMulti: true,
                  ));
              if (item != null) {
                reasonController.text = item.alasan;
                destinationController.text = item.tujuan;
                exitTimeController.text = item.jamKeluar;
                returnTimeController.text = item.jamMasuk;
                setState(() {
                  nomorSik = item.nomorSik;
                  isEditing = true;
                  selectedReason = item.kepentingan.toString();
                  selectedReason = selectedReason[0].toUpperCase() +
                      selectedReason.substring(1);
                  selectedNik.clear();
                  var nikList = item.nik.split(',');
                  for (var nik in nikList) {
                    var contact = nikKaryawan.firstWhere(
                      (element) => element.id == nik,
                      orElse: () => Contact(
                          id: '',
                          nickName: '',
                          name: '',
                          jekel: '',
                          foto: '',
                          jabatan: '',
                          bagian: ''),
                    );
                    if (contact.id.isNotEmpty) {
                      selectedNik.add(contact);
                    }
                  }
                });
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
                  Divider(),
                  DropdownSearch<Contact>(
                    items: nikKaryawan,
                    onChanged: (Contact? contact) {
                      if (contact != null) {
                        setState(() {
                          selectedNik.add(contact);
                        });
                      }
                    },
                    itemAsString: (Contact contact) {
                      return '${contact.id} - ${contact.nickName}';
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: 'Pilih NIK',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                    popupProps: PopupProps.modalBottomSheet(
                      showSelectedItems: false,
                      showSearchBox: true,
                      disabledItemFn: (Contact contact) =>
                          selectedNik.contains(contact),
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
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: selectedNik
                        .map(
                          (Contact contact) => Chip(
                            label: Text(contact.nickName),
                            onDeleted: () {
                              setState(() {
                                selectedNik.remove(contact);
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: simpanData,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  isEditing ? 'Update' : 'Simpan',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
