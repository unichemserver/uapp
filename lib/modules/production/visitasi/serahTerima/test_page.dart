import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:uapp/core/widget/app_textfield.dart';

class SerahTerimaPage extends StatelessWidget {
  final TextEditingController nomorDokumenCtrl = TextEditingController();
  final TextEditingController tanggalCtrl = TextEditingController();
  final TextEditingController shiftCtrl = TextEditingController();
  final TextEditingController namaBarangCtrl = TextEditingController();
  final TextEditingController qtyCtrl = TextEditingController();
  final TextEditingController keteranganCtrl = TextEditingController();
  final TextEditingController diterimaOlehCtrl = TextEditingController();
  final TextEditingController diberikanOlehCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Serah Terima Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ExpansionTile(
              title: const Text('Informasi Umum'),
              leading: const Icon(Icons.info),
              expandedAlignment: Alignment.topLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nomor Dokumen:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                AppTextField(
                  hintText: 'Masukkan Nomor Dokumen',
                  controller: nomorDokumenCtrl,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tanggal:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                AppTextField(
                  hintText: 'Pilih Tanggal',
                  controller: tanggalCtrl,
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((value) {
                      if (value != null) {
                        tanggalCtrl.text = value.toIso8601String().split('T')[0];
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Shift:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    hintText: 'Pilih Shift',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Shift 1', 'Shift 2', 'Shift 3']
                      .map((shift) => DropdownMenuItem(
                            value: shift,
                            child: Text(shift),
                          ))
                      .toList(),
                  onChanged: (value) {
                    shiftCtrl.text = value ?? '';
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              title: const Text('Detail Barang'),
              leading: const Icon(Icons.inventory),
              expandedAlignment: Alignment.topLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama Barang:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                AppTextField(
                  hintText: 'Masukkan Nama Barang',
                  controller: namaBarangCtrl,
                ),
                const SizedBox(height: 16),
                Text(
                  'Qty:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                AppTextField(
                  hintText: 'Masukkan Qty',
                  controller: qtyCtrl,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Text(
                  'Keterangan:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                AppTextField(
                  hintText: 'Masukkan Keterangan',
                  controller: keteranganCtrl,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              title: const Text('Tanda Tangan'),
              leading: const Icon(Icons.person),
              expandedAlignment: Alignment.topLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diterima Oleh:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                AppTextField(
                  hintText: 'Masukkan Nama Penerima',
                  controller: diterimaOlehCtrl,
                ),
                const SizedBox(height: 16),
                Text(
                  'Diberikan Oleh:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                AppTextField(
                  hintText: 'Masukkan Nama Pemberi',
                  controller: diberikanOlehCtrl,
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Placeholder for form submission
              },
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
