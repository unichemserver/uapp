import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/opt_emp_data_widget.dart';

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
  String selectedReason = '';

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
        title: const Text('Surat Ijin Keluar/Pulang'),
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
                    controller: reasonController,
                    onTap: () {},
                    maxLines: 3,
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
                    children: [
                      Expanded(
                        child: TextFormField(
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
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process data.
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
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
