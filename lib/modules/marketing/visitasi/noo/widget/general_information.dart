import 'package:flutter/material.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_options.dart';

class GeneralInformation extends StatelessWidget {
  const GeneralInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Informasi Umum'),
      leading: const Icon(Icons.info),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group Pelanggan:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 0,
          children: List.generate(
            NooOptions.custGroup.length,
                (index) {
              return ChoiceChip(
                label: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    NooOptions.custGroup[index],
                    textAlign: TextAlign.center,
                  ),
                ),
                selected: false,
                onSelected: (value) {},
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Credit Limit (Secara Total dalam Rupiah):',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
          prefixIcon: Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Rp',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Metode Pembayaran Pelanggan:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 0,
          children: List.generate(
            NooOptions.paymentMethod.length,
                (index) {
              return ChoiceChip(
                label: Row(
                  children: [
                    Text(
                      NooOptions.paymentMethod[index],
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                selected: false,
                onSelected: (value) {},
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Termin Pembayaran (TOP) dari Tanggal Surat Jalan:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Row(
          children: [
            Expanded(
              child: SpeechToTextField(
                controller: TextEditingController(),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Hari',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Jaminan (Khusus Distributor):',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 0,
          children: List.generate(
            NooOptions.jaminanDistributor.length,
                (index) {
              return ChoiceChip(
                label: Text(
                  NooOptions.jaminanDistributor[index],
                  textAlign: TextAlign.center,
                ),
                selected: false,
                onSelected: (value) {},
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Nilai Jaminan (Rp) : 100% dari Nominal Credit Limit:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
          prefixIcon: Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Rp',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Nama Perusahaan (PT/CV/UD) atau Toko:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'No. ID Pelanggan (Diisi oleh HO PT. UCI):',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'Area Pemasaran:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'Tanggal Bergabung Menjadi Pelanggan PT.UCI:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'Nama Sales:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
        const SizedBox(height: 16),
        Text(
          'Nama ASM PT. UCI:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
        ),
      ],
    );
  }
}
