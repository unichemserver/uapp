class Gudang {
  final String id;
  final String namaGudang;
  final String entityId;
  final String lokasiGudang;
  final String lokasiKantor;

  Gudang({
    required this.id,
    required this.namaGudang,
    required this.entityId,
    required this.lokasiGudang,
    required this.lokasiKantor,
  });

  factory Gudang.fromJson(Map<String, dynamic> json) {
    return Gudang(
      id: json['id'] as String,
      namaGudang: json['nama_gudang'] as String,
      entityId: json['entity_id'] as String,
      lokasiGudang: json['lokasi_gudang'] as String,
      lokasiKantor: json['lokasi_kantor'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_gudang': namaGudang,
      'entity_id': entityId,
      'lokasi_gudang': lokasiGudang,
      'lokasi_kantor': lokasiKantor,
    };
  }
}
