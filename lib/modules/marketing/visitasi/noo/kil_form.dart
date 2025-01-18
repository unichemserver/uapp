import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_controller.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_text_controller.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/company_profile_information.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/general_information.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/outlet_information.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/outlet_status.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/owner_information.dart';
import 'package:uapp/modules/marketing/visitasi/noo/widget/va_bank_account.dart';

class KilForm extends StatelessWidget {
  KilForm({
    super.key,
    required this.nooCtrl,
  });

  final NooTextController nooCtrl;
  final NooController ctx = Get.find<NooController>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GeneralInformation(
          creditLimitCtrl: nooCtrl.creditLimitCtrl,
          topDateCtrl: nooCtrl.topDateCtrl,
          jaminanCtrl: nooCtrl.jaminanCtrl,
          namaPerusahaanCtrl: nooCtrl.namaPerusahaanCtrl,
          idPelangganCtrl: nooCtrl.idPelangganCtrl,
          areaPemasaranCtrl: nooCtrl.areaPemasaranCtrl,
          tglJoinCtrl: nooCtrl.tglJoinCtrl,
          supervisorNameCtrl: nooCtrl.supervisorNameCtrl,
          asmNameCtrl: nooCtrl.asmNameCtrl,
        ),
        OwnerInformation(
          ownerNameCtrl: nooCtrl.namaOwnerCtrl,
          idNoCtrl: nooCtrl.idOwnerCtrl,
          ageGenderCtrl: nooCtrl.ageGenderOwnerCtrl,
          phoneCtrl: nooCtrl.nohpOwnerCtrl,
          emailCtrl: nooCtrl.emailOwnerCtrl,
          ownerAddress: ctx.ownerAddress,
        ),
        OutletInformation(
          namaPicCtrl: nooCtrl.namaPicCtrl,
          noTelpCtrl: nooCtrl.noTelpCtrl,
          namaDeptKeuanganCtrl: nooCtrl.namaJabatanKeuanganCtrl,
          noTelpDeptKeuanganCtrl: nooCtrl.nohpKeuanganCtrl,
          emailDeptKeuanganCtrl: nooCtrl.webEmailKeuanganCtrl,
          namaDeptPenjualanCtrl: nooCtrl.namaJabatanPenjualanCtrl,
          noTelpDeptPenjualanCtrl: nooCtrl.nohpPenjualanCtrl,
          emailDeptPenjualanCtrl: nooCtrl.webEmailPenjualanCtrl,
        ),
        OutletStatus(
          luasKantorCtlr: nooCtrl.luasTokoCtrl,
          luasGudangCtrl: nooCtrl.luasGudangCtrl,
          namaNPWPCtrl: nooCtrl.namaNpwpCtrl,
          noNPWPCtrl: nooCtrl.noNpwpCtrl,
          npwpAddress: ctx.billingAddress,
          onKantorOwnershipSelected: (value) => ctx.kantorOwnership = value,
          onGudangOwnershipSelected: (value) => ctx.gudangOwnership = value,
          onRumahOwnershipSelected: (value) => ctx.rumahOwnership = value,
        ),
        VaBankAccount(
          namaBankCtrl: nooCtrl.namaBankCtrl,
          nomorVaCtrl: nooCtrl.noRekVaCtrl,
          namaPemilikCtrl: nooCtrl.namaRekCtrl,
          cabangBankCtrl: nooCtrl.cabangBankCtrl,
        ),
        CompanyProfileInformation(
          bidangUsahaCtrl: nooCtrl.bidangUsahaCtrl,
          tglMulaiUsahaCtrl: nooCtrl.tglMulaiUsahaCtrl,
          produkUtamaCtrl: nooCtrl.produkUtamaCtrl,
          produkLainCtrl: nooCtrl.produkLainCtrl,
          limaCustUtamaCtrl: nooCtrl.limaCustUtamaCtrl,
          estOmsetMonthCtrl: nooCtrl.estOmsetMonthCtrl,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}