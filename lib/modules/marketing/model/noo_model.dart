class NooModel {
  String? id;
  String? groupCust;
  String? creditLimit;
  String? paymentMethod;
  String? termin;
  String? jaminan;
  String? nilaiJaminan;
  String? namaPerusahaan;
  String? idCust;
  String? areaMarketing;
  String? tglJoin;
  String? spvUci;
  String? asmUci;
  String? namaOwner;
  String? idOwner;
  String? ageGenderOwner;
  String? nohpOwner;
  String? emailOwner;
  String? alamatOwner;
  String? alamatKantor;
  String? namaJabatanKeuangan;
  String? nohpKeuangan;
  String? webEmailKeuangan;
  String? namaJabatanPenjualan;
  String? nohpPenjualan;
  String? webEmailPenjualan;
  String? alamatGudang;
  String? namaPICJabatan;
  String? nohpPIC;
  String? ownershipToko;
  String? ownershipGudang;
  String? ownershipRumah;
  String? luasToko;
  String? luasGudang;
  String? statusPajak;
  String? namaNpwp;
  String? noNpwp;
  String? alamatNpwp;
  String? namaBank;
  String? noRekVa;
  String? namaRek;
  String? cabangBank;
  String? bidangUsaha;
  String? tglMulaiUsaha;
  String? produkUtama;
  String? produkLain;
  String? limaCustUtama;
  String? estOmsetMonth;

  NooModel({
    this.id,
    this.groupCust,
    this.creditLimit,
    this.paymentMethod,
    this.termin,
    this.jaminan,
    this.nilaiJaminan,
    this.namaPerusahaan,
    this.idCust,
    this.areaMarketing,
    this.tglJoin,
    this.spvUci,
    this.asmUci,
    this.namaOwner,
    this.idOwner,
    this.ageGenderOwner,
    this.nohpOwner,
    this.emailOwner,
    this.alamatOwner,
    this.alamatKantor,
    this.namaJabatanKeuangan,
    this.nohpKeuangan,
    this.webEmailKeuangan,
    this.namaJabatanPenjualan,
    this.nohpPenjualan,
    this.webEmailPenjualan,
    this.alamatGudang,
    this.namaPICJabatan,
    this.nohpPIC,
    this.ownershipToko,
    this.ownershipGudang,
    this.ownershipRumah,
    this.luasToko,
    this.luasGudang,
    this.statusPajak,
    this.namaNpwp,
    this.noNpwp,
    this.alamatNpwp,
    this.namaBank,
    this.noRekVa,
    this.namaRek,
    this.cabangBank,
    this.bidangUsaha,
    this.tglMulaiUsaha,
    this.produkUtama,
    this.produkLain,
    this.limaCustUtama,
    this.estOmsetMonth,
  });

  // Factory method to create an instance from JSON
  factory NooModel.fromJson(Map<String, dynamic> json) {
    return NooModel(
      id: json['id'],
      groupCust: json['group_cust'],
      creditLimit: json['credit_limit'],
      paymentMethod: json['payment_method'],
      termin: json['termin'],
      jaminan: json['jaminan'],
      nilaiJaminan: json['nilai_jaminan'],
      namaPerusahaan: json['nama_perusahaan'],
      idCust: json['id_cust'],
      areaMarketing: json['area_marketing'],
      tglJoin: json['tgl_join'],
      spvUci: json['spv_uci'],
      asmUci: json['asm_uci'],
      namaOwner: json['nama_owner'],
      idOwner: json['id_owner'],
      ageGenderOwner: json['age_gender_owner'],
      nohpOwner: json['nohp_owner'],
      emailOwner: json['email_owner'],
      alamatOwner: json['alamat_owner'].toString(),
      alamatKantor: json['alamat_kantor'].toString(),
      namaJabatanKeuangan: json['nama_jabatan_keuangan'],
      nohpKeuangan: json['nohp_keuangan'],
      webEmailKeuangan: json['web_email_keuangan'],
      namaJabatanPenjualan: json['nama_jabatan_penjualan'],
      nohpPenjualan: json['nohp_penjualan'],
      webEmailPenjualan: json['web_email_penjualan'],
      alamatGudang: json['alamat_gudang'].toString(),
      namaPICJabatan: json['nama_pic_jabatan'],
      nohpPIC: json['nohp_pic'],
      ownershipToko: json['ownership_toko'],
      ownershipGudang: json['ownership_gudang'],
      ownershipRumah: json['ownership_rumah'],
      luasToko: json['luas_toko'],
      luasGudang: json['luas_gudang'],
      statusPajak: json['status_pajak'],
      namaNpwp: json['nama_npwp'],
      noNpwp: json['no_npwp'],
      alamatNpwp: json['alamat_npwp'].toString(),
      namaBank: json['nama_bank'],
      noRekVa: json['no_rek_va'],
      namaRek: json['nama_rek'],
      cabangBank: json['cabang_bank'],
      bidangUsaha: json['bidang_usaha'],
      tglMulaiUsaha: json['tgl_mulai_usaha'],
      produkUtama: json['produk_utama'],
      produkLain: json['produk_lain'],
      limaCustUtama: json['lima_cust_utama'],
      estOmsetMonth: json['est_omset_month'],
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'group_cust': groupCust,
      'credit_limit': creditLimit,
      'payment_method': paymentMethod,
      'termin': termin,
      'jaminan': jaminan,
      'nilai_jaminan': nilaiJaminan,
      'nama_perusahaan': namaPerusahaan,
      'id_cust': idCust,
      'area_marketing': areaMarketing,
      'tgl_join': tglJoin,
      'spv_uci': spvUci,
      'asm_uci': asmUci,
      'nama_owner': namaOwner,
      'id_owner': idOwner,
      'age_gender_owner': ageGenderOwner,
      'nohp_owner': nohpOwner,
      'email_owner': emailOwner,
      'alamat_owner': alamatOwner,
      'alamat_kantor': alamatKantor,
      'nama_jabatan_keuangan': namaJabatanKeuangan,
      'nohp_keuangan': nohpKeuangan,
      'web_email_keuangan': webEmailKeuangan,
      'nama_jabatan_penjualan': namaJabatanPenjualan,
      'nohp_penjualan': nohpPenjualan,
      'web_email_penjualan': webEmailPenjualan,
      'alamat_gudang': alamatGudang,
      'nama_pic_jabatan': namaPICJabatan,
      'nohp_pic': nohpPIC,
      'ownership_toko': ownershipToko,
      'ownership_gudang': ownershipGudang,
      'ownership_rumah': ownershipRumah,
      'luas_toko': luasToko,
      'luas_gudang': luasGudang,
      'status_pajak': statusPajak,
      'nama_npwp': namaNpwp,
      'no_npwp': noNpwp,
      'alamat_npwp': alamatNpwp,
      'nama_bank': namaBank,
      'no_rek_va': noRekVa,
      'nama_rek': namaRek,
      'cabang_bank': cabangBank,
      'bidang_usaha': bidangUsaha,
      'tgl_mulai_usaha': tglMulaiUsaha,
      'produk_utama': produkUtama,
      'produk_lain': produkLain,
      'lima_cust_utama': limaCustUtama,
      'est_omset_month': estOmsetMonth,
    };
  }
}
