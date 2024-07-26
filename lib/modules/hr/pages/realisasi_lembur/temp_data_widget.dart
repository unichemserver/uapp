import 'package:flutter/material.dart';
import 'package:uapp/modules/hr/pages/realisasi_lembur/temp_data.dart';

class TempDataWidget extends StatelessWidget {
  const TempDataWidget({
    super.key,
    required this.tempData,
    required this.onDelete,
  });

  final List<TempData> tempData;
  final Function(TempData) onDelete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Realisasi Lembur'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExpansionTile(
            initiallyExpanded: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.grey[200],
            collapsedBackgroundColor: Colors.grey[200],
            title: const Text('Data Karyawan'),
            children: tempData.where((element) => element.isKaryawan).map((e) {
              return ListTile(
                title: Text(e.nama),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${e.jamMasuk} - ${e.jamPulang}'),
                    e.barang != null
                        ? Text('Barang: ${e.namaBarang!}')
                        : const SizedBox(),
                    Text('Keterangan: ${e.keterangan}'),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    onDelete(e);
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ExpansionTile(
            initiallyExpanded: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.grey[200],
            collapsedBackgroundColor: Colors.grey[200],
            title: const Text('Data Alat Berat'),
            children: tempData.where((element) => !element.isKaryawan).map((e) {
              return ListTile(
                title: Text(e.nama),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${e.jamMasuk} - ${e.jamPulang}'),
                    Text(e.keterangan),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    onDelete(e);
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
