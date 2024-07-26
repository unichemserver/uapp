import 'package:flutter/material.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_options.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/address_information.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/ownership_choice.dart';

class OutletStatus extends StatelessWidget {
  const OutletStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Informasi Outlet'),
      leading: const Icon(Icons.local_convenience_store_rounded),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          title: const Text('Status Kepemilikan'),
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kantor/ Toko:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const OwnershipChoice(),
            const SizedBox(height: 16),
            Text(
              'Gudang:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const OwnershipChoice(),
            const SizedBox(height: 16),
            Text(
              'Rumah:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const OwnershipChoice(),
            const SizedBox(height: 16),
          ],
        ),
        ExpansionTile(
          title: Text('Luas'),
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kantor/ Toko:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SpeechToTextField(controller: TextEditingController()),
            const SizedBox(height: 16),
            Text(
              'Gudang:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SpeechToTextField(controller: TextEditingController()),
            const SizedBox(height: 16),
          ],
        ),
        Text(
          'Status Perpajakan:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 0,
          children: List.generate(
            NooOptions.statusPerpajakan.length,
            (index) {
              return ChoiceChip(
                label: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    NooOptions.statusPerpajakan[index],
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
          'Nama (Sesuai Kartu NPWP):',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(controller: TextEditingController()),
        const SizedBox(height: 16),
        Text(
          'Nomor NPWP:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SpeechToTextField(
          controller: TextEditingController(),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        AddressInformation(title: 'Alamat (Sesuai NPWP):'),
      ],
    );
  }
}
