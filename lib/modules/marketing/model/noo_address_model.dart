class NooAddressModel {
  int? id;
  int? idNoo;
  String? address;
  String? rtRw;
  String? desaKelurahan;
  String? kecamatan;
  String? kabupatenKota;
  String? provinsi;
  String? kodePos;

  NooAddressModel({
    this.id,
    this.idNoo,
    this.address,
    this.rtRw,
    this.desaKelurahan,
    this.kecamatan,
    this.kabupatenKota,
    this.provinsi,
    this.kodePos,
  });

  factory NooAddressModel.fromJson(Map<String, dynamic> json) {
    return NooAddressModel(
      id: json['id'] as int?,
      idNoo: json['id_noo'] as int?,
      address: json['address'] as String?,
      rtRw: json['rt_rw'] as String?,
      desaKelurahan: json['desa_kelurahan'] as String?,
      kecamatan: json['kecamatan'] as String?,
      kabupatenKota: json['kabupaten_kota'] as String?,
      provinsi: json['provinsi'] as String?,
      kodePos: json['kode_pos'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_noo'] = idNoo;
    data['address'] = address;
    data['rt_rw'] = rtRw;
    data['desa_kelurahan'] = desaKelurahan;
    data['kecamatan'] = kecamatan;
    data['kabupaten_kota'] = kabupatenKota;
    data['provinsi'] = provinsi;
    data['kode_pos'] = kodePos;
    return data;
  }
}