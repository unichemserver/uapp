import 'package:flutter/material.dart';
import 'package:uapp/modules/marketing/model/noo_model.dart';

class NooTextController {
  final creditLimitCtrl = TextEditingController();
  final topDateCtrl = TextEditingController();
  final jaminanCtrl = TextEditingController();
  final namaPerusahaanCtrl = TextEditingController();
  final idPelangganCtrl = TextEditingController();
  final areaPemasaranCtrl = TextEditingController();
  final tglJoinCtrl = TextEditingController();
  final supervisorNameCtrl = TextEditingController();
  final asmNameCtrl = TextEditingController();
  final namaOwnerCtrl = TextEditingController();
  final idOwnerCtrl = TextEditingController();
  final ageGenderOwnerCtrl = TextEditingController();
  final nohpOwnerCtrl = TextEditingController();
  final emailOwnerCtrl = TextEditingController();

  final namaJabatanKeuanganCtrl = TextEditingController();
  final nohpKeuanganCtrl = TextEditingController();
  final webEmailKeuanganCtrl = TextEditingController();

  final namaJabatanPenjualanCtrl = TextEditingController();
  final nohpPenjualanCtrl = TextEditingController();
  final webEmailPenjualanCtrl = TextEditingController();

  final alamatGudangCtrl = TextEditingController();
  final namaPicCtrl = TextEditingController();
  final noTelpCtrl = TextEditingController();
  final ownershipTokoCtrl = TextEditingController();
  final ownershipGudangCtrl = TextEditingController();
  final ownershipRumahCtrl = TextEditingController();
  final luasTokoCtrl = TextEditingController();
  final luasGudangCtrl = TextEditingController();
  final statusPajakCtrl = TextEditingController();
  final namaNpwpCtrl = TextEditingController();
  final noNpwpCtrl = TextEditingController();
  final alamatNpwpCtrl = TextEditingController();
  final namaBankCtrl = TextEditingController();
  final noRekVaCtrl = TextEditingController();
  final namaRekCtrl = TextEditingController();
  final cabangBankCtrl = TextEditingController();
  final bidangUsahaCtrl = TextEditingController();
  final tglMulaiUsahaCtrl = TextEditingController();
  final produkUtamaCtrl = TextEditingController();
  final produkLainCtrl = TextEditingController();
  final limaCustUtamaCtrl = TextEditingController(
    text: '1. \n2. \n3. \n4. \n5. ',
  );
  final estOmsetMonthCtrl = TextEditingController();

  void clearAll() {
    creditLimitCtrl.clear();
    topDateCtrl.clear();
    jaminanCtrl.clear();
    namaPerusahaanCtrl.clear();
    idPelangganCtrl.clear();
    areaPemasaranCtrl.clear();
    tglJoinCtrl.clear();
    supervisorNameCtrl.clear();
    asmNameCtrl.clear();
    namaOwnerCtrl.clear();
    idOwnerCtrl.clear();
    ageGenderOwnerCtrl.clear();
    nohpOwnerCtrl.clear();
    emailOwnerCtrl.clear();
    namaJabatanKeuanganCtrl.clear();
    nohpKeuanganCtrl.clear();
    webEmailKeuanganCtrl.clear();
    namaJabatanPenjualanCtrl.clear();
    nohpPenjualanCtrl.clear();
    webEmailPenjualanCtrl.clear();
    alamatGudangCtrl.clear();
    ownershipTokoCtrl.clear();
    ownershipGudangCtrl.clear();
    ownershipRumahCtrl.clear();
    luasTokoCtrl.clear();
    luasGudangCtrl.clear();
    statusPajakCtrl.clear();
    namaNpwpCtrl.clear();
    noNpwpCtrl.clear();
    alamatNpwpCtrl.clear();
    namaBankCtrl.clear();
    noRekVaCtrl.clear();
    namaRekCtrl.clear();
    cabangBankCtrl.clear();
    bidangUsahaCtrl.clear();
    tglMulaiUsahaCtrl.clear();
    produkUtamaCtrl.clear();
    produkLainCtrl.clear();
    limaCustUtamaCtrl.clear();
    estOmsetMonthCtrl.clear();
  }

  void disposeAll() {
    creditLimitCtrl.dispose();
    topDateCtrl.dispose();
    jaminanCtrl.dispose();
    namaPerusahaanCtrl.dispose();
    idPelangganCtrl.dispose();
    areaPemasaranCtrl.dispose();
    tglJoinCtrl.dispose();
    supervisorNameCtrl.dispose();
    asmNameCtrl.dispose();
    namaOwnerCtrl.dispose();
    idOwnerCtrl.dispose();
    ageGenderOwnerCtrl.dispose();
    nohpOwnerCtrl.dispose();
    emailOwnerCtrl.dispose();
    namaJabatanKeuanganCtrl.dispose();
    nohpKeuanganCtrl.dispose();
    webEmailKeuanganCtrl.dispose();
    namaJabatanPenjualanCtrl.dispose();
    nohpPenjualanCtrl.dispose();
    webEmailPenjualanCtrl.dispose();
    alamatGudangCtrl.dispose();
    ownershipTokoCtrl.dispose();
    ownershipGudangCtrl.dispose();
    ownershipRumahCtrl.dispose();
    luasTokoCtrl.dispose();
    luasGudangCtrl.dispose();
    statusPajakCtrl.dispose();
    namaNpwpCtrl.dispose();
    noNpwpCtrl.dispose();
    alamatNpwpCtrl.dispose();
    namaBankCtrl.dispose();
    noRekVaCtrl.dispose();
    namaRekCtrl.dispose();
    cabangBankCtrl.dispose();
    bidangUsahaCtrl.dispose();
    tglMulaiUsahaCtrl.dispose();
    produkUtamaCtrl.dispose();
    produkLainCtrl.dispose();
    limaCustUtamaCtrl.dispose();
    estOmsetMonthCtrl.dispose();
  }

  Map<String, dynamic> toJson() {
    return {
      'credit_limit': creditLimitCtrl.text.isEmpty ? null : creditLimitCtrl.text,
      'termin': topDateCtrl.text.isEmpty ? null : topDateCtrl.text,
      'nilai_jaminan': jaminanCtrl.text.isEmpty ? null : jaminanCtrl.text,
      'nama_perusahaan': namaPerusahaanCtrl.text.isEmpty ? null : namaPerusahaanCtrl.text,
      'id_cust': idPelangganCtrl.text.isEmpty ? null : idPelangganCtrl.text,
      'area_marketing': areaPemasaranCtrl.text.isEmpty ? null : areaPemasaranCtrl.text,
      'tgl_join': tglJoinCtrl.text.isEmpty ? null : tglJoinCtrl.text,
      'spv_uci': supervisorNameCtrl.text.isEmpty ? null : supervisorNameCtrl.text,
      'asm_uci': asmNameCtrl.text.isEmpty ? null : asmNameCtrl.text,
      'nama_owner': namaOwnerCtrl.text.isEmpty ? null : namaOwnerCtrl.text,
      'id_owner': idOwnerCtrl.text.isEmpty ? null : idOwnerCtrl.text,
      'age_gender_owner': ageGenderOwnerCtrl.text.isEmpty ? null : ageGenderOwnerCtrl.text,
      'nohp_owner': nohpOwnerCtrl.text.isEmpty ? null : nohpOwnerCtrl.text,
      'email_owner': emailOwnerCtrl.text.isEmpty ? null : emailOwnerCtrl.text,
      'nama_jabatan_keuangan': namaJabatanKeuanganCtrl.text.isEmpty ? null : namaJabatanKeuanganCtrl.text,
      'nohp_keuangan': nohpKeuanganCtrl.text.isEmpty ? null : nohpKeuanganCtrl.text,
      'web_email_keuangan': webEmailKeuanganCtrl.text.isEmpty ? null : webEmailKeuanganCtrl.text,
      'nama_jabatan_penjualan': namaJabatanPenjualanCtrl.text.isEmpty ? null : namaJabatanPenjualanCtrl.text,
      'nohp_penjualan': nohpPenjualanCtrl.text.isEmpty ? null : nohpPenjualanCtrl.text,
      'web_email_penjualan': webEmailPenjualanCtrl.text.isEmpty ? null : webEmailPenjualanCtrl.text,
      'nama_pic_jabatan': namaPicCtrl.text.isEmpty ? null : namaPicCtrl.text,
      'nohp_pic': noTelpCtrl.text.isEmpty ? null : noTelpCtrl.text,
      'luas_toko': luasTokoCtrl.text.isEmpty ? null : luasTokoCtrl.text,
      'luas_gudang': luasGudangCtrl.text.isEmpty ? null : luasGudangCtrl.text,
      'nama_npwp': namaNpwpCtrl.text.isEmpty ? null : namaNpwpCtrl.text,
      'no_npwp': noNpwpCtrl.text.isEmpty ? null : noNpwpCtrl.text,
      'nama_bank': namaBankCtrl.text.isEmpty ? null : namaBankCtrl.text,
      'no_rek_va': noRekVaCtrl.text.isEmpty ? null : noRekVaCtrl.text,
      'nama_rek': namaRekCtrl.text.isEmpty ? null : namaRekCtrl.text,
      'cabang_bank': cabangBankCtrl.text.isEmpty ? null : cabangBankCtrl.text,
      'bidang_usaha': bidangUsahaCtrl.text.isEmpty ? null : bidangUsahaCtrl.text,
      'tgl_mulai_usaha': tglMulaiUsahaCtrl.text.isEmpty ? null : tglMulaiUsahaCtrl.text,
      'produk_utama': produkUtamaCtrl.text.isEmpty ? null : produkUtamaCtrl.text,
      'produk_lain': produkLainCtrl.text.isEmpty ? null : produkLainCtrl.text,
      'lima_cust_utama': limaCustUtamaCtrl.text.isEmpty ? null : limaCustUtamaCtrl.text,
      'est_omset_month': estOmsetMonthCtrl.text.isEmpty ? null : estOmsetMonthCtrl.text,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  void mapModelToCtrl(NooModel data) {
    String sanitize(String? value) {
      return (value == null || value == "null") ? '' : value;
    }

    creditLimitCtrl.text = sanitize(data.creditLimit);
    topDateCtrl.text = sanitize(data.termin);
    jaminanCtrl.text = sanitize(data.nilaiJaminan);
    namaPerusahaanCtrl.text = sanitize(data.namaPerusahaan);
    idPelangganCtrl.text = sanitize(data.idCust);
    areaPemasaranCtrl.text = sanitize(data.areaMarketing);
    tglJoinCtrl.text = sanitize(data.tglJoin);
    supervisorNameCtrl.text = sanitize(data.spvUci);
    asmNameCtrl.text = sanitize(data.asmUci);
    namaOwnerCtrl.text = sanitize(data.namaOwner);
    idOwnerCtrl.text = sanitize(data.idOwner);
    ageGenderOwnerCtrl.text = sanitize(data.ageGenderOwner);
    nohpOwnerCtrl.text = sanitize(data.nohpOwner);
    emailOwnerCtrl.text = sanitize(data.emailOwner);
    namaJabatanKeuanganCtrl.text = sanitize(data.namaJabatanKeuangan);
    nohpKeuanganCtrl.text = sanitize(data.nohpKeuangan);
    webEmailKeuanganCtrl.text = sanitize(data.webEmailKeuangan);
    namaJabatanPenjualanCtrl.text = sanitize(data.namaJabatanPenjualan);
    nohpPenjualanCtrl.text = sanitize(data.nohpPenjualan);
    webEmailPenjualanCtrl.text = sanitize(data.webEmailPenjualan);
    namaPicCtrl.text = sanitize(data.namaPICJabatan);
    noTelpCtrl.text = sanitize(data.nohpPIC);
    luasTokoCtrl.text = sanitize(data.luasToko);
    luasGudangCtrl.text = sanitize(data.luasGudang);
    namaNpwpCtrl.text = sanitize(data.namaNpwp);
    noNpwpCtrl.text = sanitize(data.noNpwp);
    namaBankCtrl.text = sanitize(data.namaBank);
    noRekVaCtrl.text = sanitize(data.noRekVa);
    namaRekCtrl.text = sanitize(data.namaRek);
    cabangBankCtrl.text = sanitize(data.cabangBank);
    bidangUsahaCtrl.text = sanitize(data.bidangUsaha);
    tglMulaiUsahaCtrl.text = sanitize(data.tglMulaiUsaha);
    produkUtamaCtrl.text = sanitize(data.produkUtama);
    produkLainCtrl.text = sanitize(data.produkLain);
    limaCustUtamaCtrl.text = sanitize(data.limaCustUtama);
    estOmsetMonthCtrl.text = sanitize(data.estOmsetMonth);
  }
}