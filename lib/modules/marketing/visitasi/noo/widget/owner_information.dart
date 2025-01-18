import 'package:flutter/material.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_address_model.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/address_information.dart';

class OwnerInformation extends StatelessWidget {
  OwnerInformation({
    super.key,
    required this.ownerNameCtrl,
    required this.idNoCtrl,
    required this.ageGenderCtrl,
    required this.phoneCtrl,
    required this.emailCtrl,
    this.ownerAddress,
  });

  final TextEditingController ownerNameCtrl;
  final TextEditingController idNoCtrl;
  final TextEditingController ageGenderCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController emailCtrl;
  NooAddressModel? ownerAddress;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Data Pemilik Perusahaan/ Toko'),
      leading: const Icon(Icons.person),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nama Pemilik Usaha:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          controller: ownerNameCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          'No. KTP/SIM:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          controller: idNoCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          'Umur/ Jenis Kelamin:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          controller: ageGenderCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          'No. Telepon/ Handphone:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          controller: phoneCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          'Email:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          controller: emailCtrl,
        ),
        const SizedBox(height: 16),
        AddressInformation(
          title: 'Alamat Rumah Pemilik',
          addressModel: ownerAddress,
        ),
      ],
    );
  }
}
