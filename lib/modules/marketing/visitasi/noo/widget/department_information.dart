import 'package:flutter/material.dart';
import 'package:uapp/core/widget/app_textfield.dart';

class DepartmentInformation extends StatelessWidget {
  const DepartmentInformation({
    super.key,
    required this.title,
    required this.namaCtrl,
    required this.noTelpCtrl,
    required this.emailCtrl,
  });

  final String title;
  final TextEditingController namaCtrl;
  final TextEditingController noTelpCtrl;
  final TextEditingController emailCtrl;

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
        AppTextField(controller: namaCtrl, hintText: 'Masukan Nama/ Jabatan'),
        const SizedBox(height: 16),
        Text(
          'No. Telp./ Handphone',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(controller: noTelpCtrl, hintText: 'Masukan Nomer Telepon'),
        const SizedBox(height: 16),
        Text(
          'Website/ Email',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(controller: emailCtrl, hintText: 'Masukan email',),
      ],
    );
  }
}
