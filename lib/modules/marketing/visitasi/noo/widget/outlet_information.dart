import 'package:flutter/material.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/address_information.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/department_information.dart';

class OutletInformation extends StatelessWidget {
  const OutletInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Domisili Perusahaan/Toko'),
      leading: const Icon(Icons.store),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressInformation(title: 'Alamat Kantor'),
        DepartmentInformation(title: 'Departemen Keuangan'),
        DepartmentInformation(title: 'Departemen Penjualan'),
        AddressInformation(title: 'Alamat Gudang'),
        Text(
          'Nama PIC/ Jabatan:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'No. Telp./ Handphone:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
      ],
    );
  }
}
