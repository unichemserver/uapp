import 'package:flutter/material.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_address_model.dart';

class AddressInformation extends StatefulWidget {
  final String title;
  final NooAddressModel? addressModel;
  final String? Function(String?)? addressValidator;
  final String? Function(String?)? rtRwValidator;
  final String? Function(String?)? propinsiValidator;
  final String? Function(String?)? kabKotaValidator;
  final String? Function(String?)? kecamatanValidator;
  final String? Function(String?)? desaKelurahanValidator;
  final String? Function(String?)? kodePosValidator;

  const AddressInformation({
    super.key,
    required this.title,
    this.addressModel,
    this.addressValidator,
    this.rtRwValidator,
    this.propinsiValidator,
    this.kabKotaValidator,
    this.kecamatanValidator,
    this.desaKelurahanValidator,
    this.kodePosValidator,
  });

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
          validator: widget.addressValidator,
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
          validator: widget.rtRwValidator,
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
          validator: widget.propinsiValidator,
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
          validator: widget.kabKotaValidator,
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
          validator: widget.kecamatanValidator,
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
          validator: widget.desaKelurahanValidator,
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
          validator: widget.kodePosValidator,
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
