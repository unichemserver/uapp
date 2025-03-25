import 'package:flutter/material.dart';
import 'package:uapp/core/widget/app_textfield.dart';

class InspeksiFormPage extends StatefulWidget {
  @override
  _InspeksiFormPageState createState() => _InspeksiFormPageState();
}

class _InspeksiFormPageState extends State<InspeksiFormPage> {
  final TextEditingController hariTanggalController = TextEditingController();
  final TextEditingController transporterController = TextEditingController();
  final TextEditingController noPolisiController = TextEditingController();
  final TextEditingController noContainerController = TextEditingController();
  final TextEditingController lokasiMuatController = TextEditingController();
  final TextEditingController namaBarangController = TextEditingController();

  final Map<String, String?> selectedOptions = {
    'Kondisi Lantai Armada': null,
    'Dinding Armada / Container': null,
    'Atap Armada / Container': null,
    'Aroma Armada / Container': null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Inspeksi Pengiriman'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionDropdown(
              icon: Icons.local_shipping,
              title: 'Informasi Pengiriman',
              children: [
                _buildTextField(hariTanggalController, 'Hari / Tanggal', Icons.date_range),
                _buildTextField(transporterController, 'Transporter / Sopir', Icons.person),
                _buildTextField(noPolisiController, 'No. Polisi', Icons.car_rental),
                _buildTextField(noContainerController, 'No. Container', Icons.fire_truck),
                _buildTextField(lokasiMuatController, 'Lokasi Muat', Icons.location_on),
                _buildTextField(namaBarangController, 'Nama Barang', Icons.inventory),
              ],
            ),
            _buildSectionDropdown(
              icon: Icons.fact_check,
              title: 'Pengecekan Armada',
              children: selectedOptions.keys
                  .map((key) => _buildChoiceChipRow(key, ['Kotor', 'Bersih', 'Rusak']))
                  .toList(),
            ),
            _buildSectionDropdown(
              icon: Icons.list_alt,
              title: 'Preparation Sheet',
              children: [
                _buildTextField(TextEditingController(), 'Jumlah Palet', Icons.format_list_numbered),
                _buildTextField(TextEditingController(), 'Kode Produk / Jumlah', Icons.code),
                _buildTextField(TextEditingController(), 'Jumlah TIR', Icons.numbers),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: null, // Placeholder for navigation logic
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
          child: const Text('Lanjut'),
        ),
      ),
    );
  }

  Widget _buildSectionDropdown({required IconData icon, required String title, required List<Widget> children}) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      children: children,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          AppTextField(
            controller: controller,
            hintText: 'Masukan $label',
            prefixIcon: Icon(icon),
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

Widget _buildChoiceChipRow(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Wrap(
          spacing: 8,
          runSpacing: 0,
          children: options.map((option) {
            return ChoiceChip(
                 label: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      option,
                      textAlign: TextAlign.center,
                    ),
                  ),
                selected: selectedOptions[title] == option,
                onSelected: (isSelected) {
                  setState(() {
                    selectedOptions[title] = isSelected ? option : null;
                  });
                },
              );
          }).toList(),
        ),
      ],
    );
  }
}
