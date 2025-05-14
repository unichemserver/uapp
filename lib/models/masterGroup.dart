class Mastergroup {
  int id;
  String clusterKelompok;
  String type;
  String kode;
  String namaDesc;
  String singkatan;
  String definisi;
  int active;

  Mastergroup({
    required this.id,
    required this.clusterKelompok,
    required this.type,
    required this.kode,
    required this.namaDesc,
    required this.singkatan,
    required this.definisi,
    required this.active,
  });

  factory Mastergroup.fromJson(Map<String, dynamic> json) {
    return Mastergroup(
      id: json['id'],
      clusterKelompok: json['cluster_kelompok'],
      type: json['type'],
      kode: json['kode'],
      namaDesc: json['nama_desc'],
      singkatan: json['singkatan'],
      definisi: json['definisi'],
      active: json['active'],
    );
  }
}