import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/app/strings.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/instance.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/opt_emp_data_widget.dart';
import 'package:uapp/core/utils/date_utils.dart' as du;
import 'package:uapp/modules/hr/pages/tidak_masuk/api.dart' as api;
import 'package:uapp/modules/hr/pages/tidak_masuk/api_param.dart';
import 'package:uapp/modules/hr/pages/tidak_masuk/history_page.dart';

class TidakMasukPage extends StatefulWidget {
  const TidakMasukPage({super.key});

  @override
  State<TidakMasukPage> createState() => _TidakMasukPageState();
}

class _TidakMasukPageState extends State<TidakMasukPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final Box box = Hive.box(HiveKeys.appBox);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController divisionController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController attachmentController = TextEditingController();

  bool isExpanded = false;
  bool isEditing = false;
  String? nomorSjtm;
  String docPath = '';
  int selectedKeterangan = -1;
  List<String> keteranganList = [
    'Cuti Bebas',
    'Ijin Perusahaan',
    'Ijin Pribadi',
  ];

  void getEmployeeData() {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    nameController.text = userData.nama;
    nikController.text = userData.id;
    departmentController.text = userData.department;
    divisionController.text = userData.bagian;
    positionController.text = userData.jabatan;
  }

  void initAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: -5, end: 5)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void initState() {
    super.initState();
    initAnimation();
    getEmployeeData();
  }

  void clearData() {
    fromDateController.clear();
    toDateController.clear();
    purposeController.clear();
    attachmentController.clear();
    selectedKeterangan = -1;
  }

  @override
  void dispose() {
    _controller.dispose();
    nameController.dispose();
    nikController.dispose();
    departmentController.dispose();
    divisionController.dispose();
    positionController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    purposeController.dispose();
    attachmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ijin Tidak Masuk"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () async {
              var item = await Get.to(() => HistoryPage());
              if (item != null) {
                var data = item;
                fromDateController.text = data.drTgl;
                toDateController.text = data.spTgl;
                purposeController.text = data.keperluan;
                selectedKeterangan = keteranganList
                    .indexOf(Strings.toTitleWord(data.keterangan));
                if (selectedKeterangan == 2) {
                  attachmentController.text = data.dokumenIjinPribadi!;
                }
                isEditing = true;
                nomorSjtm = data.nomorSjtm;
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
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
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: fromDateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        if (toDateController.text.isNotEmpty) {
                          DateTime toDate =
                              DateTime.parse(toDateController.text);
                          if (date.isAfter(toDate)) {
                            Get.snackbar(
                              'Perhatian',
                              'Tanggal Awal tidak boleh melebihi Tanggal Akhir',
                            );
                            return;
                          }
                        }
                        fromDateController.text =
                            du.DateUtils.getYMDFormat(date);
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Dari Tanggal tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Dari Tanggal',
                      prefixIcon: const Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: toDateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        if (fromDateController.text.isNotEmpty) {
                          DateTime fromDate =
                              DateTime.parse(fromDateController.text);
                          if (date.isBefore(fromDate)) {
                            Get.snackbar(
                              'Perhatian',
                              'Tanggal Akhir tidak boleh sebelum Tanggal Awal',
                            );
                            return;
                          }
                        }
                        toDateController.text = du.DateUtils.getYMDFormat(date);
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Sampai Tanggal tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Sampai Tanggal',
                      prefixIcon: const Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: purposeController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Keperluan tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Keperluan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.description),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Keterangan:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Transform.translate(
                    offset: Offset(_animation.value, 0),
                    child: Wrap(
                      spacing: 8,
                      children: List.generate(
                        keteranganList.length,
                        (index) => ChoiceChip(
                          label: Text(keteranganList[index]),
                          selected: selectedKeterangan == index,
                          onSelected: isEditing
                              ? null
                              : (selected) {
                                  setState(() {
                                    selectedKeterangan =
                                        (selected ? index : null)!;
                                  });
                                },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  selectedKeterangan == 2
                      ? TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: true,
                          controller: attachmentController,
                          validator: (value) {
                            if (selectedKeterangan != 2) {
                              return null;
                            }
                            if (value!.isEmpty) {
                              return 'Lampiran tidak boleh kosong';
                            }
                            return null;
                          },
                          onTap: isEditing
                              ? () {
                                  Get.dialog(
                                    Dialog(
                                      child: Image.network(
                                        getBaseImageUrl(
                                          box.get(HiveKeys.baseURL),
                                          'sjtm',
                                          attachmentController.text,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Lampiran',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                if (isEditing) {
                                  Get.snackbar(
                                    'Perhatian',
                                    'Edit surat ijin tidak masuk, tidak dapat mengubah lampiran',
                                  );
                                  return;
                                }
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  attachmentController.text =
                                      result.files.single.name;
                                  docPath = result.files.single.path!;
                                }
                              },
                              icon: const Icon(Icons.attach_file),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (selectedKeterangan == -1) {
                      _controller.forward(from: 0);
                      Get.snackbar(
                        'Perhatian',
                        'Keterangan tidak boleh kosong',
                      );
                    } else {
                      final box = Hive.box(HiveKeys.appBox);
                      final userData =
                          User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
                      final nik = userData.id;
                      var method = isEditing
                          ? HrMethodApi.editSuratIjinTidakMasuk
                          : HrMethodApi.addSuratIjinTidakMasuk;
                      var data = ApiParams(
                        method: method,
                        nik: nik,
                        drTgl: fromDateController.text,
                        smpTgl: toDateController.text,
                        keperluan: purposeController.text,
                        keterangan:
                            keteranganList[selectedKeterangan].toLowerCase(),
                      );
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const LoadingDialog(
                            message: 'Menyimpan data...',
                          );
                        },
                      );
                      if (isEditing) {
                        data.nomorSjtm = nomorSjtm;
                      }
                      api
                          .addTidakMasuk(
                        data.toJson(),
                        doc: selectedKeterangan != 2 || isEditing
                            ? null
                            : docPath,
                      )
                          .then((message) {
                        Navigator.pop(context);
                        if (message != null) {
                          Get.snackbar(
                            'Gagal',
                            message,
                          );
                        } else {
                          if (isEditing) {
                            setState(() {
                              isEditing = false;
                              nomorSjtm = null;
                              formKey.currentState!.reset();
                            });
                          }
                          clearData();
                          Get.snackbar(
                            'Berhasil',
                            'Data berhasil disimpan',
                          );
                        }
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(isEditing ? 'Simpan Perubahan' : 'Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
