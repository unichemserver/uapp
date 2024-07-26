class NomorPtk {
  final String ptk;
  final String tglAwal;
  final String tglAkhir;

  NomorPtk({
    required this.ptk,
    required this.tglAwal,
    required this.tglAkhir,
  });

  factory NomorPtk.fromJson(Map<String, dynamic> json) {
    return NomorPtk(
      ptk: json['nomor_ptk'] ?? json ['nomor_ptkb'],
      tglAwal: json['tgl_awal'],
      tglAkhir: json['tgl_akhir'],
    );
  }
}