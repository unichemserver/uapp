class NooSpesimenModel {
  int? id;
  int? idNoo;
  String? nama;
  String? jabatan;
  String? nohp;
  String? ttd;
  String? stempel;

  NooSpesimenModel({
    this.id,
    this.idNoo,
    this.nama,
    this.jabatan,
    this.nohp,
    this.ttd,
    this.stempel,
  });

  factory NooSpesimenModel.fromJson(Map<String, dynamic> json) {
    return NooSpesimenModel(
      id: json['id'] as int?,
      idNoo: json['id_noo'] as int?,
      nama: json['nama'] as String?,
      jabatan: json['jabatan'] as String?,
      nohp: json['nohp'] as String?,
      ttd: json['ttd'] as String?,
      stempel: json['stempel'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_noo'] = idNoo;
    data['nama'] = nama;
    data['jabatan'] = jabatan;
    data['nohp'] = nohp;
    data['ttd'] = ttd;
    data['stempel'] = stempel;
    return data;
  }

}