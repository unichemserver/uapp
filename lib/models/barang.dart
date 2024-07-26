class Barang {
  final String id;
  final String namaBarang;

  Barang({required this.id, required this.namaBarang});

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id'] as String,
      namaBarang: json['nama_barang'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': namaBarang,
    };
  }
}
