import 'package:flutter/material.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_address_model.dart';

class AddressInformation extends StatefulWidget {
  final String title;
  final NooAddressModel? addressModel;

  const AddressInformation({super.key, required this.title, this.addressModel});

  @override
  _AddressInformationState createState() => _AddressInformationState();
}

class _AddressInformationState extends State<AddressInformation> {
  late TextEditingController addressController;
  late TextEditingController rtRwController;
  late TextEditingController propinsiController;
  late TextEditingController kabKotaController;
  late TextEditingController kecamatanController;
  late TextEditingController desaKelurahanController;
  late TextEditingController kodePosController;

  @override
  void initState() {
    super.initState();
    addressController =
        TextEditingController(text: widget.addressModel?.address ?? '');
    rtRwController =
        TextEditingController(text: widget.addressModel?.rtRw ?? '');
    propinsiController =
        TextEditingController(text: widget.addressModel?.propinsi ?? '');
    kabKotaController =
        TextEditingController(text: widget.addressModel?.kabKota ?? '');
    kecamatanController =
        TextEditingController(text: widget.addressModel?.kecamatan ?? '');
    desaKelurahanController =
        TextEditingController(text: widget.addressModel?.desaKelurahan ?? '');
    kodePosController =
        TextEditingController(text: widget.addressModel?.kodePos ?? '');
  }

  @override
  void dispose() {
    addressController.dispose();
    rtRwController.dispose();
    propinsiController.dispose();
    kabKotaController.dispose();
    kecamatanController.dispose();
    desaKelurahanController.dispose();
    kodePosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.title),
      leading: const Icon(Icons.location_on),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: addressController,
          hintText: 'Nama Jalan',
          onChanged: (value) {
            setState(() {
              widget.addressModel?.address = value;
            });
          },
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: rtRwController,
          hintText: 'RT/RW',
          onChanged: (value) {
            setState(() {
              widget.addressModel?.rtRw = value;
            });
          },
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: propinsiController,
          hintText: 'Provinsi',
          onChanged: (value) {
            setState(() {
              widget.addressModel?.propinsi = value;
            });
          },
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: kabKotaController,
          hintText: 'Kabupaten',
          onChanged: (value) {
            setState(() {
              widget.addressModel?.kabKota = value;
            });
          },
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: kecamatanController,
          hintText: 'Kecamatan',
          onChanged: (value) {
            setState(() {
              widget.addressModel?.kecamatan = value;
            });
          },
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: desaKelurahanController,
          hintText: 'Desa/Kelurahan',
          onChanged: (value) {
            setState(() {
              widget.addressModel?.desaKelurahan = value;
            });
          },
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: kodePosController,
          hintText: 'Kode Pos',
          onChanged: (value) {
            setState(() {
              widget.addressModel?.kodePos = value;
            });
          },
        ),
      ],
    );
  }
}
