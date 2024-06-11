import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class AlatBeratScreen extends StatelessWidget {
  const AlatBeratScreen({super.key});

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
            items: const [
              'Forklift',
              'Excavator',
              'Bulldozer',
              'Loader',
              'Dump Truck'
            ],
            onChanged: print,
            selectedItem: 'Forklift',
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
