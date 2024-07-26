class Mobil {
  final String id;
  final String namaMobil;
  final String nomorPolisi;
  final String statusMobil;

  Mobil({
    required this.id,
    required this.namaMobil,
    required this.nomorPolisi,
    required this.statusMobil,
  });

  factory Mobil.fromJson(Map<String, dynamic> json) {
    return Mobil(
      id: json['id'],
      namaMobil: json['nama_alat_berat'],
      nomorPolisi: json['nomor_polisi'],
      statusMobil: json['status_mobil'],
    );
  }

  static List<Mobil> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Mobil.fromJson(json)).toList();
  }
}