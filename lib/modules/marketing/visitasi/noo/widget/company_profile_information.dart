import 'package:flutter/material.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:intl/intl.dart';

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
          hintText: 'Masukan bidang usaha',
          controller: bidangUsahaCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          'Mulai menjalankan usaha:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
              hintText: 'Pilih Tanggal',
              controller: tglMulaiUsahaCtrl,
              readOnly: true,
              onTap: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ).then((value) {
                  if (value != null) {
                    tglMulaiUsahaCtrl.text = value.toIso8601String().split('T')[0];
                  }
                });
              },
            ),
        const SizedBox(height: 16),
        Text(
          'Produk/ Jasa Utama:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          hintText: 'Masukan produk utama',
          controller: produkUtamaCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          'Produk/ Jasa Lainnya:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          hintText: 'Masukan produk lainnya',	
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
          hintText: 'Masukan perkiraan omset per bulan',
          controller: estOmsetMonthCtrl,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final formattedValue = NumberFormat.decimalPattern('id_ID')
                .format(int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0);
            estOmsetMonthCtrl.value = TextEditingValue(
              text: formattedValue,
              selection: TextSelection.collapsed(offset: formattedValue.length),
            );
          },
        ),  
      ],
    );
  }
}
