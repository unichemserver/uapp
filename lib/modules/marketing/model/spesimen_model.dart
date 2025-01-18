class SpesimenModel {
  String? id;
  String? idNoo;
  String? nama;
  String? jabatan;
  String? noHp;
  String? ttd;
  String? stempel;

  SpesimenModel({
    this.id,
    this.idNoo,
    this.nama,
    this.jabatan,
    this.noHp,
    this.ttd,
    this.stempel,
  });

  factory SpesimenModel.fromJson(Map<String, dynamic> json) {
    return SpesimenModel(
      id: json['id'] as String?,
      idNoo: json['id_noo'] as String?,
      nama: json['nama'] as String?,
      jabatan: json['jabatan'] as String?,
      noHp: json['nohp'] as String?,
      ttd: json['ttd'] as String?,
      stempel: json['stempel'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_noo'] = idNoo;
    data['nama'] = nama;
    data['jabatan'] = jabatan;
    data['nohp'] = noHp;
    data['ttd'] = ttd;
    data['stempel'] = stempel;
    return data;
  }
}