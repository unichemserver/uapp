class Skm {
  final String nomorSkm;
  final String nopol;
  final String pembawa;
  final String tujuan;
  final String keperluan;
  final String tglAwal;
  final String tglAkhir;
  final String jamKeluar;
  final String kmKeluar;
  final String jamKembali;
  final String kmKembali;
  final String pengikut;
  final String createdDate;
  final String status;
  final String? approvedBy;
  final String? approvedDate;

  Skm({
    required this.nomorSkm,
    required this.nopol,
    required this.pembawa,
    required this.tujuan,
    required this.keperluan,
    required this.tglAwal,
    required this.tglAkhir,
    required this.jamKeluar,
    required this.kmKeluar,
    required this.jamKembali,
    required this.kmKembali,
    required this.pengikut,
    required this.createdDate,
    required this.status,
    this.approvedBy,
    this.approvedDate,
  });

  factory Skm.fromJson(Map<String, dynamic> json) {
    return Skm(
      nomorSkm: json['nomor_skm'] ?? '',
      nopol: json['nopol'] ?? '',
      pembawa: json['pembawa'] ?? '',
      tujuan: json['tujuan'] ?? '',
      keperluan: json['keperluan'] ?? '',
      tglAwal: json['tgl_awal'] ?? '',
      tglAkhir: json['tgl_akhir'] ?? '',
      jamKeluar: json['jam_keluar'] ?? '',
      kmKeluar: json['km_keluar'] ?? '',
      jamKembali: json['jam_kembali'] ?? '',
      kmKembali: json['km_kembali'] ?? '',
      pengikut: json['pengikut'] ?? '',
      createdDate: json['created_at'] ?? '',
      status: json['status'] ?? '',
      approvedBy: json['approved_by'],
      approvedDate: json['approved_date'],
    );
  }
}