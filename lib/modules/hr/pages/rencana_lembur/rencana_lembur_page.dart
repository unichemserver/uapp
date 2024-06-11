import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/opt_emp_data_widget.dart';
import 'package:uapp/core/utils/date_utils.dart' as du;

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

  final List<String> _listBarang = [
    'Garam',
    'Lada',
    'Kunyit',
    'Ketumbar',
    'Barite',
    'KCL',
    'Saraline',
    'Multi Barang',
  ];
  final List<String> _listGudang = [
    "KANTOR",
    "G01",
    "GABR",
    "G03-08",
    "G04",
    "G09",
    "G10",
    "G06-08",
    "G08-08",
    "G11-08",
    "G11",
    "G15",
    "G15-08",
    "G18",
    "G18-08",
    "G23",
    "G23-08",
    "G12",
    "G14",
    "G16",
    "GDLD",
    "GDKYT",
    "GDKTB",
    "G19",
    "G21",
  ];
  final List<String> _listAlatBerat = [
    'Mobil Operasional',
    'Forklif',
    'Whell Loader',
    'Excavator',
    'Tractor Head',
    'Top Loader',
    'Tronton',
    'Sepeda Motor Operasional',
  ];
  List<String> selectedAlatBerat = [];

  bool isExpanded = false;
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
        title: const Text('Form Rencana Lembur'),
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
                  Wrap(
                    spacing: 8,
                    runSpacing: 2,
                    children: List.generate(
                      _listBarang.length,
                      (index) {
                        return ChoiceChip(
                          label: Text(_listBarang[index]),
                          selected: selectedBarang == index,
                          onSelected: (value) {
                            setState(() {
                              selectedBarang = value ? index : -1;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gudang:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  DropdownSearch<String>(
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
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      ).then((value) {
                        if (value != null) {
                          dateController.text =
                              du.DateUtils.getFormattedDate(value);
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
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: startTimeController,
                          readOnly: true,
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
                    decoration: InputDecoration(
                      hintText: 'Tugas kerja yang akan dilakukan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                          label: Text(_listAlatBerat[index]),
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
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data berhasil disimpan'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
