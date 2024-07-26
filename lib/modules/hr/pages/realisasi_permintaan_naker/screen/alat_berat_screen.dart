import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:uapp/models/alat_berat.dart';
import 'package:uapp/modules/hr/pages/realisasi_lembur/temp_data.dart';

class AlatBeratScreen extends StatelessWidget {
  AlatBeratScreen({
    super.key,
    required this.tempData,
    required this.listAlatBerat,
    required this.onSaved,
  });

  final List<TempData> tempData;
  final List<AlatBerat> listAlatBerat;
  final _formKey = GlobalKey<FormState>();
  final Function(TempData) onSaved;
  AlatBerat? selectedAlatBerat;
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
            DropdownSearch<AlatBerat>(
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (AlatBerat? alatBerat) {
                if (alatBerat == null) {
                  return 'Pilih Alat Berat';
                }
                return null;
              },
              items: listAlatBerat,
              onChanged: (AlatBerat? alatBerat) {
                selectedAlatBerat = alatBerat!;
              },
              selectedItem: listAlatBerat.first,
              itemAsString: (AlatBerat alatBerat) =>
              alatBerat.namaJenisAlatBerat,
              popupProps: PopupProps.menu(
                disabledItemFn: (AlatBerat alatBerat) => alatBerat.id == '',
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: 'Pilih Alat Berat',
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
            // row textfield jam masuk dan jam pulang
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: jamMasukController,
                    readOnly: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Jam Masuk tidak boleh kosong';
                      }
                      return null;
                    },
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((TimeOfDay? value) {
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
                    readOnly: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Jam Pulang tidak boleh kosong';
                      }
                      return null;
                    },
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((TimeOfDay? value) {
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
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
                      id: selectedAlatBerat!.id,
                      nama: selectedAlatBerat!.namaJenisAlatBerat,
                      jamMasuk: jamMasukController.text,
                      jamPulang: jamPulangController.text,
                      keterangan: keteranganController.text,
                      isKaryawan: false,
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
