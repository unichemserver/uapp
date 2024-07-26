class PajakPenghasilan {
  final String nilaiAwal;
  final String nilaiAkhir;
  final String tarif;

  PajakPenghasilan({
    required this.nilaiAwal,
    required this.nilaiAkhir,
    required this.tarif,
  });

  factory PajakPenghasilan.fromJson(Map<String, dynamic> json) {
    return PajakPenghasilan(
      nilaiAwal: json['nilai_awal'],
      nilaiAkhir: json['nilai_akhir'],
      tarif: json['tarif'],
    );
  }
}