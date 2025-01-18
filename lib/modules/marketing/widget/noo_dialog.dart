import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/widget/speech_to_textfield.dart';
import 'package:uapp/models/noo.dart';
import 'package:uapp/models/wilayah.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';

class NooDialog extends StatefulWidget {
  const NooDialog({super.key});

  @override
  State<NooDialog> createState() => _NooDialogState();
}

class _NooDialogState extends State<NooDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController ktpController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController terminController = TextEditingController();
  final TextEditingController kodePosController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String baseUrl = 'https://www.emsifa.com/api-wilayah-indonesia/api';
  final List<String> nooList = [
    'Modern Trade',
    'Distributor',
    'Luar Pulau',
    'GT - Grosir',
    'GT - Retail',
    'Lainnya',
  ];
  final List<String> paymentMethod = [
    'Terms of Payment (TOP)',
    'Cash Before Delivery (CBD)',
    'Cash on Delivery (COD)',
  ];
  final List<String> jaminanList = [
    'BANK GARANSI',
    'DCV',
    'TIDAK ADA',
  ];
  List<Wilayah> provinces = [Wilayah(id: '', name: 'Pilih Provinsi')];
  List<Wilayah> cities = [Wilayah(id: '', name: 'Pilih Kota/Kabupaten')];
  List<Wilayah> districts = [Wilayah(id: '', name: 'Pilih Kecamatan')];
  List<Wilayah> subDistricts = [Wilayah(id: '', name: 'Pilih Desa/Kelurahan')];

  int selectedGroup = -1;
  int selectedPayment = -1;
  int selectedJaminan = -1;

  String selectedProvince = '';
  String selectedCity = '';
  String selectedDistrict = '';
  String selectedSubDistrict = '';
  String selectedJekel = '';
  // String ktpImgPath = '';
  // String npwpImgPath = '';
  // String ownerPICImgPath = '';
  // String outletImgPath = '';
  // String gudangImgPath = '';

  bool showDocument = false;

  void toggleDocument() {
    showDocument = !showDocument;
    setState(() {});
  }

  void getProvince() async {
    final response = await http.get(Uri.parse('$baseUrl/provinces.json'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      provinces.clear();
      provinces.add(Wilayah(id: '', name: 'Pilih Provinsi'));
      provinces.addAll(data.map((e) => Wilayah.fromJson(e)).toList());
      setState(() {});
    }
  }

  void getCity(String idProvince) async {
    final response =
        await http.get(Uri.parse('$baseUrl/regencies/$idProvince.json'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      cities.clear();
      cities.add(Wilayah(id: '', name: 'Pilih Kota/Kabupaten'));
      cities.addAll(data.map((e) => Wilayah.fromJson(e)).toList());
      setState(() {});
    }
  }

  void getDistrict(String idCity) async {
    final response =
        await http.get(Uri.parse('$baseUrl/districts/$idCity.json'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      districts.clear();
      districts.add(Wilayah(id: '', name: 'Pilih Kecamatan'));
      districts.addAll(data.map((e) => Wilayah.fromJson(e)).toList());
      setState(() {});
    }
  }

  void getSubDistrict(String idDistrict) async {
    final response =
        await http.get(Uri.parse('$baseUrl/villages/$idDistrict.json'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      subDistricts.clear();
      subDistricts.add(Wilayah(id: '', name: 'Pilih Desa/Kelurahan'));
      subDistricts.addAll(data.map((e) => Wilayah.fromJson(e)).toList());
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getProvince();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Outlet Opening'),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Group Pelanggan:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 0,
                      children: List.generate(
                        nooList.length,
                        (index) {
                          return ChoiceChip(
                            label: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(nooList[index]),
                            ),
                            selected: selectedGroup == index,
                            onSelected: (value) {
                              if (selectedGroup == 1 && index != 1) {
                                selectedJaminan = -1;
                                setState(() {});
                              }
                              selectedGroup = value ? index : 0;
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Metode Pembayaran Pelanggan:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 0,
                      children: List.generate(
                        paymentMethod.length,
                        (index) {
                          return ChoiceChip(
                            label: Text(paymentMethod[index]),
                            selected: selectedPayment == index,
                            onSelected: (value) {
                              selectedPayment = value ? index : 0;
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Termin Pembayaran:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SpeechToTextField(
                            controller: terminController,
                            hintText: 'Masukkan termin pembayaran',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Termin pembayaran tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Hari',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    selectedGroup == 1
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jaminan',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Wrap(
                                spacing: 8,
                                runSpacing: 0,
                                children: List.generate(
                                  jaminanList.length,
                                  (index) {
                                    return ChoiceChip(
                                      label: Text(jaminanList[index]),
                                      selected: selectedJaminan == index,
                                      onSelected: (value) {
                                        selectedJaminan = value ? index : 0;
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    SizedBox(height: selectedGroup == 1 ? 16 : 0),
                    Text(
                      'Nama Toko / Perusahaan:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SpeechToTextField(
                      controller: nameController,
                      hintText: 'Masukkan nama toko/perusahaan',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama toko/perusahaan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Area Pemasaran:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SpeechToTextField(
                      controller: areaController,
                      hintText: 'Masukkan area pemasaran',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Area pemasaran tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Data Pemilik Perusahaan/Toko:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SpeechToTextField(
                      controller: ownerController,
                      hintText: 'Masukkan nama pemilik',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama pemilik tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    SpeechToTextField(
                      controller: ktpController,
                      hintText: 'Masukkan nomor KTP',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nomor KTP tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SpeechToTextField(
                            controller: ageController,
                            hintText: 'Masukkan umur',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Umur tidak boleh kosong';
                              }
                              if (value.length > 2) {
                                return 'Masukkan umur yang valid';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            ChoiceChip(
                              label: const Text('L'),
                              selected: selectedJekel == 'L',
                              onSelected: (value) {
                                selectedJekel = 'L';
                                setState(() {});
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('P'),
                              selected: selectedJekel == 'P',
                              onSelected: (value) {
                                selectedJekel = 'P';
                                setState(() {});
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    SpeechToTextField(
                      controller: phoneController,
                      hintText: 'Masukkan nomor telepon',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nomor telepon tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    SpeechToTextField(
                      controller: emailController,
                      hintText: 'Masukkan email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    SpeechToTextField(
                      controller: addressController,
                      hintText: 'Masukkan alamat',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Alamat tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownSearch<Wilayah>(
                      items: provinces,
                      itemAsString: (Wilayah item) => item.name,
                      selectedItem: provinces.first,
                      popupProps: PopupProps.modalBottomSheet(
                        showSearchBox: true,
                        disabledItemFn: (item) => item.id.isEmpty,
                      ),
                      onChanged: (value) {
                        selectedProvince = value!.name;
                        getCity(value.id);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownSearch<Wilayah>(
                      items: cities,
                      itemAsString: (Wilayah item) => item.name,
                      selectedItem: cities.first,
                      popupProps: PopupProps.modalBottomSheet(
                        showSearchBox: true,
                        disabledItemFn: (item) => item.id.isEmpty,
                      ),
                      onChanged: (value) {
                        selectedCity = value!.name;
                        getDistrict(value.id);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownSearch<Wilayah>(
                      items: districts,
                      itemAsString: (Wilayah item) => item.name,
                      selectedItem: districts.first,
                      popupProps: PopupProps.modalBottomSheet(
                        showSearchBox: true,
                        disabledItemFn: (item) => item.id.isEmpty,
                      ),
                      onChanged: (value) {
                        selectedDistrict = value!.name;
                        getSubDistrict(value.id);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownSearch<Wilayah>(
                      items: subDistricts,
                      itemAsString: (Wilayah item) => item.name,
                      selectedItem: subDistricts.first,
                      popupProps: PopupProps.modalBottomSheet(
                        showSearchBox: true,
                        disabledItemFn: (item) => item.id.isEmpty,
                      ),
                      onChanged: (value) {
                        selectedSubDistrict = value!.name;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 8),
                    SpeechToTextField(
                      controller: kodePosController,
                      hintText: 'Masukkan kode pos',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Kode pos tidak boleh kosong';
                        }
                        if (value.length != 5) {
                          return 'Masukkan kode pos yang valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Dokumen:',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.add_a_photo),
                                Text('KTP Image'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.add_a_photo),
                                Text('NPWP Image'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.add_a_photo),
                                Text('Owner PIC Image'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.add_a_photo),
                                Text('Outlet Image'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.add_a_photo),
                                Text('Gudang Image'),
                              ],
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
                    bool isValid = _isValidate();
                    if (!isValid) return;
                    Get.dialog(
                      PopScope(
                        canPop: false,
                        child: AlertDialog(
                          title: const Text('Perhatian!'),
                          content: const Text(
                            'Apakah Anda yakin ingin menyimpan data ini?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                var jaminan =
                                    nooList[selectedGroup] == 'Distributor'
                                        ? jaminanList[selectedJaminan]
                                        : '';
                                var data = Noo(
                                  groupPelanggan: nooList[selectedGroup],
                                  metodePembayaran:
                                      paymentMethod[selectedPayment],
                                  termin: terminController.text,
                                  jaminan: jaminan,
                                  namaPerusahaan: nameController.text,
                                  areaPemasaran: areaController.text,
                                  namaOwner: ownerController.text,
                                  noKtp: ktpController.text,
                                  umur: int.tryParse(ageController.text),
                                  jekel: selectedJekel,
                                  noTelepon: phoneController.text,
                                  email: emailController.text,
                                  address: addressController.text,
                                  desa: selectedSubDistrict,
                                  kec: selectedDistrict,
                                  kab: selectedCity,
                                  prov: selectedProvince,
                                  kodePos: kodePosController.text,
                                );
                                Get.back();
                                _saveDataToDb(data);
                              },
                              child: const Text('Simpan'),
                            ),
                          ],
                        ),
                      ),
                      barrierDismissible: false,
                    );
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
      ),
    );
  }

  bool _isValidate() {
    if (selectedGroup == -1) {
      Get.snackbar('Peringatan', 'Silahkan pilih group pelanggan');
      return false;
    }
    if (selectedPayment == -1) {
      Get.snackbar('Peringatan', 'Silahkan pilih metode pembayaran');
      return false;
    }
    if (selectedGroup == 1 && selectedJaminan == -1) {
      Get.snackbar('Peringatan', 'Silahkan pilih jaminan');
      return false;
    }
    if (!formKey.currentState!.validate()) {
      return false;
    }
    if (selectedProvince.isEmpty) {
      Get.snackbar('Peringatan', 'Silahkan pilih provinsi');
      return false;
    }
    if (selectedCity.isEmpty) {
      Get.snackbar('Peringatan', 'Silahkan pilih kota/kabupaten');
      return false;
    }
    if (selectedDistrict.isEmpty) {
      Get.snackbar('Peringatan', 'Silahkan pilih kecamatan');
      return false;
    }
    if (selectedSubDistrict.isEmpty) {
      Get.snackbar('Peringatan', 'Silahkan pilih desa/kelurahan');
      return false;
    }
    if (selectedJekel.isEmpty) {
      Get.snackbar('Peringatan', 'Silahkan pilih jenis kelamin');
      return false;
    }
    return true;
  }

  _saveDataToDb(Noo data) async {
    final ctx = Get.find<MarketingController>();
    // int custID = await ctx.saveDataNooToDB(data);
    // ctx.setCustomerId(custID.toString());
    Get.back();
    ctx.changeIndex(1);
  }
}
