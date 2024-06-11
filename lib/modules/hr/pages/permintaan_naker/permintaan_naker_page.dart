import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/opt_emp_data_widget.dart';

class PermintaanNakerPage extends StatefulWidget {
  const PermintaanNakerPage({super.key});

  @override
  State<PermintaanNakerPage> createState() => _PermintaanNakerPageState();
}

class _PermintaanNakerPageState extends State<PermintaanNakerPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Box box = Hive.box(HiveKeys.appBox);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController divisionController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Permintaan Tenaga Kerja'),
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
                  // row for tanggal awal dan tanggal akhir
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Tanggal Awal',
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
                          decoration: InputDecoration(
                            labelText: 'Tanggal Akhir',
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
                    children: [
                      Expanded(
                        child: TextFormField(
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
                  // tugas kerja
                  TextFormField(
                    maxLines: 3,
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
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  minimumSize: const Size(double.infinity, 0),
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
