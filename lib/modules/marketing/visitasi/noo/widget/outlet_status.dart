import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_address_model.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_controller.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_options.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/address_information.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/ownership_choice.dart';

class OutletStatus extends StatefulWidget {
  const OutletStatus({
    super.key,
    required this.luasKantorCtlr,
    required this.luasGudangCtrl,
    required this.namaNPWPCtrl,
    required this.noNPWPCtrl,
    this.npwpAddress,
    required this.onKantorOwnershipSelected,
    required this.onGudangOwnershipSelected,
    required this.onRumahOwnershipSelected,
  });

  final TextEditingController luasKantorCtlr;
  final TextEditingController luasGudangCtrl;
  final TextEditingController namaNPWPCtrl;
  final TextEditingController noNPWPCtrl;
  final NooAddressModel? npwpAddress;
  final Function(String) onKantorOwnershipSelected;
  final Function(String) onGudangOwnershipSelected;
  final Function(String) onRumahOwnershipSelected;

  @override
  State<OutletStatus> createState() => _OutletStatusState();
}

class _OutletStatusState extends State<OutletStatus> {
  String selectedStatusPajak = '';

  setSelectedStatusPajak(String value) {
    setState(() {
      selectedStatusPajak = value;
    });
  }

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
            OwnershipChoice(
              onSelected: widget.onKantorOwnershipSelected,
            ),
            const SizedBox(height: 16),
            Text(
              'Gudang:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            OwnershipChoice(
              onSelected: widget.onGudangOwnershipSelected,
            ),
            const SizedBox(height: 16),
            Text(
              'Rumah:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            OwnershipChoice(
              onSelected: widget.onRumahOwnershipSelected,
            ),
            const SizedBox(height: 16),
          ],
        ),
        ExpansionTile(
          title: const Text('Luas'),
          expandedAlignment: Alignment.topLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kantor/ Toko:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppTextField(controller: widget.luasKantorCtlr, hintText: 'Masukan Luas Kantor/Toko',),
            const SizedBox(height: 16),
            Text(
              'Gudang:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            AppTextField(controller: widget.luasGudangCtrl, hintText: 'Masukan Luas Gudang',),
            const SizedBox(height: 16),
          ],
        ),
        Text(
          'Status Perpajakan:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        GetBuilder<NooController>(
          init: NooController(),
          initState: (_) {},
          builder: (ctx) {
            return Wrap(
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
                    selected: ctx.statusPajak == NooOptions.statusPerpajakan[index],
                    onSelected: (value) {
                      if (value) {
                        ctx.statusPajak = NooOptions.statusPerpajakan[index];
                        ctx.update();
                      }
                    },
                  );
                },
              ),
            );
          }
        ),
        const SizedBox(height: 16),
        Text(
          'Nama (Sesuai Kartu NPWP):',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(controller: widget.namaNPWPCtrl, hintText: 'Masukan Nama Sesuai NPWP',),
        const SizedBox(height: 16),
        Text(
          'Nomor NPWP:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          hintText: 'Masukan Nomor NPWP',
          controller: widget.noNPWPCtrl,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        AddressInformation(
          title: 'Alamat (Sesuai NPWP):',
          addressModel: widget.npwpAddress,
        ),
      ],
    );
  }
}
