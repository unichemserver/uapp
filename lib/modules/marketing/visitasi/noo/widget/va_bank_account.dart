import 'package:flutter/material.dart';
import 'package:uapp/core/widget/app_textfield.dart';

class VaBankAccount extends StatelessWidget {
  const VaBankAccount({
    super.key,
    required this.namaBankCtrl,
    required this.nomorVaCtrl,
    required this.namaPemilikCtrl,
    required this.cabangBankCtrl,
  });

  final TextEditingController namaBankCtrl;
  final TextEditingController nomorVaCtrl;
  final TextEditingController namaPemilikCtrl;
  final TextEditingController cabangBankCtrl;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Rekening Bank VA PT. UCI'),
      leading: const Icon(Icons.account_balance),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nama Bank:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          hintText: 'Masukan nama bank',
          controller: namaBankCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          'Nomor Rekening Virtual Account:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          hintText: 'Masukan nomor rekening VA',
          controller: nomorVaCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          'Nama Pemilik Rekening (Pelanggan):',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          hintText: 'Masukan nama pemilik rekening',
          controller: namaPemilikCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          'Cabang Bank:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          hintText: 'Masukan cabang bank',
          controller: cabangBankCtrl,
        ),
      ],
    );
  }
}
