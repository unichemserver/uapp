import 'package:flutter/material.dart';
import 'package:uapp/modules/hr/pages/realisasi_lembur/screen/alat_berat_screen.dart';
import 'package:uapp/modules/hr/pages/realisasi_lembur/screen/karyawan_screen.dart';

class RealisasiLemburPage extends StatefulWidget {
  const RealisasiLemburPage({super.key});

  @override
  State<RealisasiLemburPage> createState() => _RealisasiLemburPageState();
}

class _RealisasiLemburPageState extends State<RealisasiLemburPage> {
  int indexPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Realisasi Lembur'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: PageView(
        children: const [
          KaryawanScreen(),
          AlatBeratScreen(),
        ],
        onPageChanged: (int index) {
          setState(() {
            indexPage = index;
          });
        },
      ),
    );
  }
}