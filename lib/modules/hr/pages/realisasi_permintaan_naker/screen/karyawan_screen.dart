import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:uapp/models/barang.dart';
import 'package:uapp/models/contact.dart';
import 'package:uapp/modules/hr/pages/realisasi_lembur/temp_data.dart';

class KaryawanScreen extends StatelessWidget {
  KaryawanScreen({
    super.key,
    required this.tempData,
    required this.listKaryawan,
    required this.listBarang,
    required this.onSaved,
  });

  final List<TempData> tempData;
  final List<Contact> listKaryawan;
  final List<Barang> listBarang;
  final Function(TempData) onSaved;
  final _formKey = GlobalKey<FormState>();
  Contact? selectedKaryawan;
  Barang? selectedBarang;
  var jamMasukController = TextEditingController();
  var jamPulangController = TextEditingController();
  var keteranganController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownSearch<Contact>(
              validator: (Contact? contact) {
                if (contact == null) {
                  return 'Pilih Karyawan';
                }
                return null;
              },
              items: listKaryawan,
              onChanged: (Contact? contact) {
                selectedKaryawan = contact!;
              },
              selectedItem: listKaryawan.first,
              itemAsString: (Contact contact) => contact.name,
              popupProps: PopupProps.bottomSheet(
                showSearchBox: true,
                disabledItemFn: (Contact contact) {
                  return contact.id == '' ||
                      tempData.any((element) => element.id == contact.id);
                },
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: 'Pilih Rencana Lembur',
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
            DropdownSearch<Barang>(
              validator: (Barang? barang) {
                if (barang == null) {
                  return 'Pilih Barang';
                }
                return null;
              },
              items: listBarang,
              onChanged: (Barang? barang) {
                selectedBarang = barang!;
              },
              selectedItem: listBarang.first,
              itemAsString: (Barang barang) => barang.namaBarang,
              popupProps: PopupProps.bottomSheet(
                showSearchBox: true,
                disabledItemFn: (Barang barang) {
                  return barang.id == '' ||
                      tempData.any((element) => element.id == barang.id);
                },
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: 'Pilih Barang',
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: jamMasukController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Jam Masuk tidak boleh kosong';
                      }
                      return null;
                    },
                    readOnly: true,
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        if (value != null) {
                          jamMasukController.text = value.format(context);
                        }
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Jam Masuk',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.access_time),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: jamPulangController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Jam Pulang tidak boleh kosong';
                      }
                      return null;
                    },
                    readOnly: true,
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        if (value != null) {
                          jamPulangController.text = value.format(context);
                        }
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Jam Pulang',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.access_time),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // textfield keterangan
            TextFormField(
              controller: keteranganController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Keterangan tidak boleh kosong';
                }
                return null;
              },
              maxLines: null,
              minLines: 1,
              decoration: InputDecoration(
                labelText: 'Keterangan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.description),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  onSaved(
                    TempData(
                      primaryKey: tempData.length + 1,
                      isKaryawan: true,
                      barang: selectedBarang!.id,
                      namaBarang: selectedBarang!.namaBarang,
                      id: selectedKaryawan!.id,
                      nama: selectedKaryawan!.name,
                      jamMasuk: jamMasukController.text,
                      jamPulang: jamPulangController.text,
                      keterangan: keteranganController.text,
                    ),
                  );
                  _formKey.currentState!.reset();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
