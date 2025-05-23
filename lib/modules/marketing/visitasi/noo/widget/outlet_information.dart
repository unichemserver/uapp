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
      initiallyExpanded: true,
      children: [
        AddressInformation(
          title: 'Alamat Usaha',
          addressModel: officeAddress,
          isOpen: "true",
          addressValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nama Jalan tidak boleh kosong';
            }
            return null;
          },
          rtRwValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'RT/RW tidak boleh kosong';
            }
            return null;
          },
          propinsiValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kelurahan tidak boleh kosong';
            }
            return null;
          },
          kabKotaValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kabupaten/Kota tidak boleh kosong';
            }
            return null;
          },
          kecamatanValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kecamatan tidak boleh kosong';
            }
            return null;
          },
          desaKelurahanValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Desa/Kelurahan tidak boleh kosong';
            }
            return null;
          },
          kodePosValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kode Pos tidak boleh kosong';
            }
            return null;
          },
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
          isOpen: "false",
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
