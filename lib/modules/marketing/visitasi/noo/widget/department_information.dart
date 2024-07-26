import 'package:flutter/material.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';

class DepartmentInformation extends StatelessWidget {
  DepartmentInformation({super.key, required this.title});

  final String title;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      leading: const Icon(Icons.location_city),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nama/ Jabatan',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(controller: controller),
        const SizedBox(height: 16),
        Text(
          'No. Telp./ Handphone',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(controller: controller),
        const SizedBox(height: 16),
        Text(
          'Website/ Email',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(controller: controller),
      ],
    );
  }
}
