import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class KaryawanScreen extends StatelessWidget {
  const KaryawanScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.table_chart),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownSearch(
            items: const ['1', '2', '3', '4', '5'],
            onChanged: print,
            selectedItem: '1',
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
          TextField(
            decoration: InputDecoration(
              labelText: 'Tanggal Lembur',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.calendar_today),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownSearch(
            items: const ['123', '456', '789'],
            onChanged: print,
            selectedItem: '123',
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: 'Pilih NIK Karyawan',
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
            children: [
              Expanded(
                child: TextField(
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
                child: TextField(
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
          TextField(
            maxLines: 3,
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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
