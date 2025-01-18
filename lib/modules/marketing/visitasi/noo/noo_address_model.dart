class NooAddressModel {
  String? id;
  String? idNoo;
  String? address;
  String? rtRw;
  String? desaKelurahan;
  String? kecamatan;
  String? kabKota;
  String? propinsi;
  String? kodePos;

  NooAddressModel({
    this.id,
    this.idNoo,
    this.address,
    this.rtRw,
    this.desaKelurahan,
    this.kecamatan,
    this.kabKota,
    this.propinsi,
    this.kodePos,
  });

  bool isNotEmpty() {
    return (address != null || address != '') &&
        (rtRw != null || rtRw != '') &&
        (desaKelurahan != null || desaKelurahan != '') &&
        (kecamatan != null || kecamatan != '') &&
        (kabKota != null || kabKota != '') &&
        (propinsi != null || propinsi != '') &&
        (kodePos != null || kodePos != '');
  }

  factory NooAddressModel.fromJson(Map<String, dynamic> json) {
    return NooAddressModel(
      id: json['id'],
      idNoo: json['id_noo'],
      address: json['address'],
      rtRw: json['rt_rw'],
      desaKelurahan: json['desa_kelurahan'],
      kecamatan: json['kecamatan'],
      kabKota: json['kabupaten_kota'],
      propinsi: json['provinsi'],
      kodePos: json['kode_pos'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_noo'] = idNoo;
    data['address'] = address;
    data['rt_rw'] = rtRw;
    data['desa_kelurahan'] = desaKelurahan;
    data['kecamatan'] = kecamatan;
    data['kabupaten_kota'] = kabKota;
    data['provinsi'] = propinsi;
    data['kode_pos'] = kodePos;
    return data;
  }

}
