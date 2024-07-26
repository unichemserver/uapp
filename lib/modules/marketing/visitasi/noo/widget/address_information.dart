import 'package:flutter/material.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';

class AddressInformation extends StatelessWidget {
  AddressInformation({super.key, required this.title});

  final String title;

  final creditLimitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      leading: const Icon(Icons.location_on),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpeechToTextField(
          controller: creditLimitController,
          hintText: 'Nama Jalan',
        ),
        const SizedBox(height: 16),
        SpeechToTextField(
          controller: creditLimitController,
          hintText: 'Nomor Rumah',
        ),
        const SizedBox(height: 16),
        SpeechToTextField(
          controller: creditLimitController,
          hintText: 'RT/RW',
        ),const SizedBox(height: 16),
        SpeechToTextField(
          controller: creditLimitController,
          hintText: 'Provinsi',
        ),const SizedBox(height: 16),
        SpeechToTextField(
          controller: creditLimitController,
          hintText: 'Kabupaten',
        ),const SizedBox(height: 16),
        SpeechToTextField(
          controller: creditLimitController,
          hintText: 'Kecamatan',
        ),const SizedBox(height: 16),
        SpeechToTextField(
          controller: creditLimitController,
          hintText: 'Desa/Kelurahan',
        ), const SizedBox(height: 16),
        SpeechToTextField(
          controller: creditLimitController,
          hintText: 'Kode Pos',
        ),
      ],
    );
  }
}
