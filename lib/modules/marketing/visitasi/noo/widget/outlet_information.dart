import 'package:flutter/material.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_address_model.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/address_information.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/department_information.dart';

class OutletInformation extends StatelessWidget {
  const OutletInformation({
    super.key,
    required this.namaPicCtrl,
    required this.noTelpCtrl,
    required this.namaDeptKeuanganCtrl,
    required this.noTelpDeptKeuanganCtrl,
    required this.emailDeptKeuanganCtrl,
    required this.namaDeptPenjualanCtrl,
    required this.noTelpDeptPenjualanCtrl,
    required this.emailDeptPenjualanCtrl,
    this.officeAddress,
    this.warehouseAddress,
  });

  final TextEditingController namaPicCtrl;
  final TextEditingController noTelpCtrl;
  final TextEditingController namaDeptKeuanganCtrl;
  final TextEditingController noTelpDeptKeuanganCtrl;
  final TextEditingController emailDeptKeuanganCtrl;
  final TextEditingController namaDeptPenjualanCtrl;
  final TextEditingController noTelpDeptPenjualanCtrl;
  final TextEditingController emailDeptPenjualanCtrl;
  final NooAddressModel? officeAddress;
  final NooAddressModel? warehouseAddress;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Domisili Perusahaan/Toko'),
      leading: const Icon(Icons.store),
      expandedAlignment: Alignment.topLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressInformation(
          title: 'Alamat Kantor',
          addressModel: officeAddress,
        ),
        DepartmentInformation(
          title: 'Departemen Keuangan',
          namaCtrl: namaDeptKeuanganCtrl,
          noTelpCtrl: noTelpDeptKeuanganCtrl,
          emailCtrl: emailDeptKeuanganCtrl,
        ),
        DepartmentInformation(
          title: 'Departemen Penjualan',
          namaCtrl: namaDeptPenjualanCtrl,
          noTelpCtrl: noTelpDeptPenjualanCtrl,
          emailCtrl: emailDeptPenjualanCtrl,
        ),
        AddressInformation(
          title: 'Alamat Gudang',
          addressModel: warehouseAddress,
        ),
        Text(
          'Nama PIC/ Jabatan:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          hintText: 'Masukan nama PIC',
          controller: namaPicCtrl,
        ),
        const SizedBox(height: 16),
        Text(
          'No. Telp./ Handphone:',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        AppTextField(
          hintText: 'Masukan nomor telepon',
          controller: noTelpCtrl,
        ),
      ],
    );
  }
}
