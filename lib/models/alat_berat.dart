class AlatBerat {
  final String id;
  final String namaJenisAlatBerat;

  AlatBerat({required this.id, required this.namaJenisAlatBerat});

  factory AlatBerat.fromJson(Map<String, dynamic> json) {
    return AlatBerat(
      id: json['id'] as String,
      namaJenisAlatBerat: json['nama_jenis_alat_berat'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_jenis_alat_berat': namaJenisAlatBerat,
    };
  }
}
