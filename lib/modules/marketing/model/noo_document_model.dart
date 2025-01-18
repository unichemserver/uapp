class NooDocumentModel {
  int? id;
  int? idNoo;
  String? ktp;
  String? npwp;
  String? ownerPic;
  String? outlet;
  String? warehouse;
  String? siup;
  String? tdp;
  String? suratKerjasama;
  String? suratPenunjukanDistributor;
  String? suratDomisiliUsaha;
  String? suratPenerbitanBank;
  String? suratBankGaransi;
  String? aktaPendirian;
  String? companyProfile;

  NooDocumentModel({
    this.id,
    this.idNoo,
    this.ktp,
    this.npwp,
    this.ownerPic,
    this.outlet,
    this.warehouse,
    this.siup,
    this.tdp,
    this.suratKerjasama,
    this.suratPenunjukanDistributor,
    this.suratDomisiliUsaha,
    this.suratPenerbitanBank,
    this.suratBankGaransi,
    this.aktaPendirian,
    this.companyProfile,
  });

  factory NooDocumentModel.fromJson(Map<String, dynamic> json) {
    return NooDocumentModel(
      id: json['id'] as int?,
      idNoo: json['id_noo'] as int?,
      ktp: json['ktp'] as String?,
      npwp: json['npwp'] as String?,
      ownerPic: json['owner_pic'] as String?,
      outlet: json['outlet'] as String?,
      warehouse: json['warehouse'] as String?,
      siup: json['siup'] as String?,
      tdp: json['tdp'] as String?,
      suratKerjasama: json['surat_kerjasama'] as String?,
      suratPenunjukanDistributor: json['surat_penunjukan_distributor'] as String?,
      suratDomisiliUsaha: json['surat_domisili_usaha'] as String?,
      suratPenerbitanBank: json['surat_penerbitan_bank'] as String?,
      suratBankGaransi: json['surat_bank_garansi'] as String?,
      aktaPendirian: json['akta_pendirian'] as String?,
      companyProfile: json['company_profile'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_noo'] = idNoo;
    data['ktp'] = ktp;
    data['npwp'] = npwp;
    data['owner_pic'] = ownerPic;
    data['outlet'] = outlet;
    data['warehouse'] = warehouse;
    data['siup'] = siup;
    data['tdp'] = tdp;
    data['surat_kerjasama'] = suratKerjasama;
    data['surat_penunjukan_distributor'] = suratPenunjukanDistributor;
    data['surat_domisili_usaha'] = suratDomisiliUsaha;
    data['surat_penerbitan_bank'] = suratPenerbitanBank;
    data['surat_bank_garansi'] = suratBankGaransi;
    data['akta_pendirian'] = aktaPendirian;
    data['company_profile'] = companyProfile;
    return data;
  }

}

// id INTEGER PRIMARY KEY AUTOINCREMENT,
// id_noo INTEGER,
//     ktp TEXT,
// npwp TEXT,
//     owner_pic TEXT,
// outlet TEXT,
//     warehouse TEXT,
// siup TEXT,
//     tdp TEXT,
// surat_kerjasama TEXT,
//     surat_penunjukan_distributor TEXT,
// surat_domisili_usaha TEXT,
//     surat_penerbitan_bank TEXT,
// surat_bank_garansi TEXT,
//     akta_pendirian TEXT,
// company_profile TEXT