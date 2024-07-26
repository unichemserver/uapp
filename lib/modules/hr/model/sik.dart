class Sik {
  final String nomorSik;
  final String tujuan;
  final String kepentingan;
  final String alasan;
  final String jamKeluar;
  final String jamMasuk;
  final String status;
  final String createdDate;
  final String? approvedBy;
  final String? approvedAt;
  final String? keterangan;
  final String? nik;

  Sik({
    required this.nomorSik,
    required this.tujuan,
    required this.kepentingan,
    required this.alasan,
    required this.jamKeluar,
    required this.jamMasuk,
    required this.status,
    required this.createdDate,
    this.approvedBy,
    this.approvedAt,
    this.keterangan,
    this.nik,
  });

  factory Sik.fromJson(Map<String, dynamic> json) {
    return Sik(
      nomorSik: json['nomor_sik'],
      tujuan: json['tujuan'],
      kepentingan: json['kepentingan'],
      alasan: json['alasan'],
      jamKeluar: json['jam_keluar'],
      jamMasuk: json['jam_masuk'],
      status: json['status'],
      createdDate: json['created_at'],
      approvedBy: json['approved_by'],
      approvedAt: json['approved_date'],
      keterangan: json['keterangan'],
      nik: json['nik'],
    );
  }
}