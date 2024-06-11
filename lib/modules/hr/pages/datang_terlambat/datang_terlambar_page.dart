import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/opt_emp_data_widget.dart';
import 'package:uapp/core/utils/date_utils.dart' as du;

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
                      // set last date is 7 days from now
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 7)),
                      ).then((value) {
                        if (value != null) {
                          dateController.text =
                              du.DateUtils.getDayDate(value);
                        }
                      });
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
                          controller: timeController,
                          readOnly: true,
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
                          keyboardType: TextInputType.number,
                          controller: lateController,
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
                    
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
