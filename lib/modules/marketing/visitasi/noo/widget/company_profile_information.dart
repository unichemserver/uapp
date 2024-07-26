import 'package:flutter/material.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';

class CompanyProfileInformation extends StatelessWidget {
  const CompanyProfileInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(title: Text('Profil Perusahaan'),
      leading: const Icon(Icons.business),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bidang Usaha:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        // 2. mulai menjalankan usaha
        // 3. produk/ jasa utama
        // 4. produk/ jasa lainnya
        // 5. 5 pelanggan utama
        // 6. perkiraan omset per bulan
        Text(
          'Mulai menjalankan usaha:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'Produk/ Jasa Utama:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'Produk/ Jasa Lainnya:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          '5 Pelanggan Utama:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'Perkiraan Omset per Bulan:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
      ],
    );
  }
}
