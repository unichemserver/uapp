import 'package:flutter/material.dart';
import 'package:uapp/modules/hr/pages/realisasi_permintaan_naker/screen/alat_berat_screen.dart';
import 'package:uapp/modules/hr/pages/realisasi_permintaan_naker/screen/karyawan_screen.dart';

class RealisasiPermintaanNakerPage extends StatelessWidget {
  const RealisasiPermintaanNakerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Form Realisasi Permintaan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Tenaga Kerja',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
          ),
        ],
      ),
      body: PageView(
        children: [KaryawanScreen(), AlatBeratScreen()],
      ),
    );
  }
}
