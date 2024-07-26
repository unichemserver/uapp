import 'package:flutter/material.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';

class VaBankAccount extends StatelessWidget {
  const VaBankAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Rekening Bank VA PT. UCI'),
      leading: const Icon(Icons.account_balance),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nama Bank:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'Nomor Rekening Virtual Account:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'Nama Pemilik Rekening (Pelanggan):',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'Cabang Bank:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
      ],
    );
  }
}
