import 'package:flutter/material.dart';
import 'package:uapp/core/widget/app_textfield.dart';

class CompanyProfileInformation extends StatelessWidget {
  const CompanyProfileInformation({
    super.key,
    required this.bidangUsahaCtrl,
    required this.tglMulaiUsahaCtrl,
    required this.produkUtamaCtrl,
    required this.produkLainCtrl,
    required this.limaCustUtamaCtrl,
    required this.estOmsetMonthCtrl,
  });

  final TextEditingController bidangUsahaCtrl;
  final TextEditingController tglMulaiUsahaCtrl;
  final TextEditingController produkUtamaCtrl;
  final TextEditingController produkLainCtrl;
  final TextEditingController limaCustUtamaCtrl;
  final TextEditingController estOmsetMonthCtrl;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Profil Perusahaan'),
      leading: const Icon(Icons.business),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bidang Usaha:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          controller: bidangUsahaCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          'Mulai menjalankan usaha:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          controller: tglMulaiUsahaCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          'Produk/ Jasa Utama:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          controller: produkUtamaCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          'Produk/ Jasa Lainnya:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          controller: produkLainCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          '5 Pelanggan Utama:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          controller: limaCustUtamaCtrl,
          maxLines: 5,
        ),
        const SizedBox(height: 16),
        Text(
          'Perkiraan Omset per Bulan:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          controller: estOmsetMonthCtrl,
        ),
      ],
    );
  }
}
