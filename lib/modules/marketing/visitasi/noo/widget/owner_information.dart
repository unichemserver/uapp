import 'package:flutter/material.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/address_information.dart';

class OwnerInformation extends StatelessWidget {
  const OwnerInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Data Pemilik Perusahaan/ Toko'),
      leading: const Icon(Icons.person),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nama Pemilik Usaha:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'No. KTP/SIM:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'Umur/ Jenis Kelamin:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'No. Telepon/ Handphone:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'Email:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        AddressInformation(
          title: 'Alamat Rumah Pemilik',
        )
      ],
    );
  }
}
