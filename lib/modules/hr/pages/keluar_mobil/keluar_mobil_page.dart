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
import 'package:uapp/modules/hr/model/skm.dart';
import 'package:uapp/modules/hr/opt_emp_data_widget.dart';
import 'package:uapp/modules/hr/pages/keluar_mobil/api.dart' as api;
import 'package:uapp/modules/hr/pages/keluar_mobil/api_param.dart';
import 'package:uapp/modules/hr/pages/keluar_mobil/history_page.dart';
import 'package:uapp/modules/hr/pages/keluar_mobil/mobil.dart';

class KeluarMobilPage extends StatefulWidget {
  const KeluarMobilPage({super.key});

  @override
  State<KeluarMobilPage> createState() => _KeluarMobilPageState();
}

class _KeluarMobilPageState extends State<KeluarMobilPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Box box = Hive.box(HiveKeys.appBox);
  final db = DatabaseHelper();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController divisionController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController driverController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController startKmController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController endKmController = TextEditingController();

  bool isExpanded = false;
  bool isEditing = false;
  String? nomorSkm;
  List<Mobil> cars = [];
  List<Contact> followers = [];
  List<Contact> selectedFollowers = [];
  Mobil selectedCar = Mobil(
    id: '0',
    namaMobil: 'Pilih Mobil',
    nomorPolisi: '',
    statusMobil: '',
  );

  getListContacts() async {
    final userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final selfId = userData.id;
    final List<Contact> availableContacts = await db.getContact(selfId);
    followers.clear();
    setState(() {
      followers.addAll(availableContacts);
    });
  }

  getListCars() async {
    final List<Mobil> availableCars = await api.getAvailableCars();
    cars.clear();
    setState(() {
      cars.add(
        Mobil(
          id: '0',
          namaMobil: 'Pilih Mobil',
          nomorPolisi: '',
          statusMobil: '',
        ),
      );
      cars.addAll(availableCars);
    });
  }

  void clearForm() {
    selectedCar = Mobil(
      id: '0',
      namaMobil: 'Pilih Mobil',
      nomorPolisi: '',
      statusMobil: '',
    );
    driverController.clear();
    destinationController.clear();
    purposeController.clear();
    startDateController.clear();
    endDateController.clear();
    startTimeController.clear();
    startKmController.clear();
    endTimeController.clear();
    endKmController.clear();
    selectedFollowers.clear();
  }

  void getEmployeeData() {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    nameController.text = userData.nama;
    driverController.text = userData.nama;
    nikController.text = userData.id;
    departmentController.text = userData.department;
    divisionController.text = userData.bagian;
    positionController.text = userData.jabatan;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        const LoadingDialog(
          message: 'Mengambil data mobil...',
        ),
        barrierDismissible: false,
      );
      getEmployeeData();
      getListContacts();
      getListCars().then((_) {
        Get.back();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Peminjaman Mobil'),
        actions: [
          IconButton(
            onPressed: () async {
              var item = await Get.to(() => HistoryPage());
              if (item != null) {
                isEditing = true;
                var data = item as Skm;
                nomorSkm = data.nomorSkm;
                print(data.nopol);
                selectedCar = cars.firstWhere(
                  (element) => element.id == data.nopol,
                  orElse: () => Mobil(
                    id: '0',
                    namaMobil: 'Pilih Mobil',
                    nomorPolisi: '',
                    statusMobil: '',
                  ),
                );
                driverController.text = data.pembawa;
                destinationController.text = data.tujuan;
                purposeController.text = data.keperluan;
                startDateController.text = data.tglAwal;
                endDateController.text = data.tglAkhir;
                startTimeController.text = data.jamKeluar.substring(0, 5);
                startKmController.text = data.kmKeluar;
                endTimeController.text = data.jamKembali.substring(0, 5);
                endKmController.text = data.kmKembali;
                selectedFollowers.clear();
                print(data.pengikut);
                var followersId = data.pengikut.split(',');
                print(followersId);
                for (var follower in followersId) {
                  var contact = followers.firstWhere(
                    (element) => element.id == follower,
                    orElse: () => Contact(
                      id: '0',
                      nickName: 'Pilih Pengikut',
                      name: '',
                      jekel: '',
                      foto: '',
                      jabatan: '',
                      bagian: '',
                    ),
                  );
                  selectedFollowers.add(contact);
                }
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
                  DropdownSearch<Mobil>(
                    items: cars,
                    onChanged: (Mobil? car) {
                      setState(() {
                        selectedCar = car!;
                      });
                    },
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (Mobil? car) {
                      if (car == null || car.id == '0') {
                        return 'Pilih mobil terlebih dahulu';
                      }
                      return null;
                    },
                    selectedItem: selectedCar,
                    itemAsString: (Mobil car) {
                      var carName = car.namaMobil.replaceAll(
                        RegExp(r'[0-9]'),
                        '',
                      );
                      if (car == selectedCar) {
                        return '$carName - ${car.nomorPolisi}';
                      }
                      return '$carName - ${car.nomorPolisi}\nStatus: ${car.statusMobil}';
                    },
                    popupProps: PopupProps.bottomSheet(
                      showSearchBox: true,
                      disabledItemFn: (Mobil car) =>
                          car.id == '0' ? true : false,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Cari Mobil',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: 'Pilih Mobil',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: driverController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Pembawa',
                      prefixIcon: const Icon(Icons.person),
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
                    controller: destinationController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
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
                  TextFormField(
                    controller: purposeController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Keperluan tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Keperluan',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // row for tanggal awal and tanggal akhir
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Awal:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            TextFormField(
                              controller: startDateController,
                              readOnly: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Tanggal awal tidak boleh kosong';
                                }
                                return null;
                              },
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null) {
                                  setState(() {
                                    startDateController.text =
                                        picked.toString().substring(0, 10);
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Awal',
                                prefixIcon: const Icon(Icons.date_range),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Akhir:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            TextFormField(
                              controller: endDateController,
                              readOnly: true,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Tanggal akhir';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null) {
                                  setState(() {
                                    endDateController.text =
                                        picked.toString().substring(0, 10);
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Akhir',
                                prefixIcon: const Icon(Icons.date_range),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // row for keluar jam and km
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jam Keluar:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            TextFormField(
                              controller: startTimeController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              readOnly: true,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Jam keluar tidak boleh kosong';
                                }
                                return null;
                              },
                              onTap: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    startTimeController.text =
                                        picked.format(context);
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Jam Keluar',
                                prefixIcon: const Icon(Icons.access_time),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KM Awal:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            TextFormField(
                              controller: startKmController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'KM awal tidak boleh kosong';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'x.x',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                suffixText: 'KM',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // row for kembali jam and km
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jam Kembali:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            TextFormField(
                              controller: endTimeController,
                              readOnly: true,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Jam kembali tidak boleh kosong';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onTap: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    endTimeController.text =
                                        picked.format(context);
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Jam Kembali',
                                prefixIcon: const Icon(Icons.access_time),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KM Akhir:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            TextFormField(
                              controller: endKmController,
                              keyboardType: TextInputType.number,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'KM akhir kosong';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: 'x.x',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                suffixText: 'KM',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownSearch<Contact>(
                    items: followers,
                    onChanged: (Contact? contact) {
                      if (contact != null) {
                        setState(() {
                          selectedFollowers.add(contact);
                        });
                      }
                    },
                    itemAsString: (Contact contact) {
                      return '${contact.id} - ${contact.nickName}';
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: 'Pengikut',
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
                          selectedFollowers.contains(contact),
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
                    children: selectedFollowers
                        .map(
                          (Contact contact) => Chip(
                            label: Text(contact.nickName),
                            onDeleted: () {
                              setState(() {
                                selectedFollowers.remove(contact);
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var userData =
                        User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
                    var data = ApiParams(
                      method: isEditing
                          ? HrMethodApi.editSuratKeluarMobil
                          : HrMethodApi.suratKeluarMobil,
                      nik: userData.id,
                      idMobil: selectedCar.id,
                      tujuan: destinationController.text,
                      keperluan: purposeController.text,
                      tglAwal: startDateController.text,
                      tglAkhir: endDateController.text,
                      jamKeluar: startTimeController.text,
                      kmKeluar: startKmController.text,
                      jamKembali: endTimeController.text,
                      kmKembali: endKmController.text,
                      pengikut:
                          selectedFollowers.map((e) => e.id).toList().join(','),
                    );
                    if (isEditing) {
                      data.nomorSkm = nomorSkm;
                    }
                    Get.dialog(
                      LoadingDialog(
                        message: isEditing
                            ? 'Mengirim perubahan...'
                            : 'Mengirim permintaan...',
                      ),
                      barrierDismissible: false,
                    );
                    print(data.toJson());
                    api.addKeluarMobil(data).then((message) {
                      Get.back();
                      if (message != null) {
                        Get.snackbar(
                          'Gagal',
                          message,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      } else {
                        Get.snackbar(
                          'Berhasil',
                          isEditing
                              ? 'Perubahan berhasil dikirim'
                              : 'Permintaan berhasil dikirim',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                        Get.to(() => HistoryPage());
                        clearForm();
                        setState(() {
                          isEditing = false;
                        });
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  isEditing ? 'Simpan Perubahan' : 'Kirim Permintaan',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
