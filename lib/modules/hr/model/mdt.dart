class Mdt {
  final String nomorMdt;
  final String tgl;
  final String jam;
  final String terlambat;
  final String kepentingan;
  final String keperluan;
  final String createdAt;
  final String? approvedBy;
  final String? approvedDate;
  final String status;

  Mdt({
    required this.nomorMdt,
    required this.tgl,
    required this.jam,
    required this.terlambat,
    required this.kepentingan,
    required this.keperluan,
    required this.createdAt,
    this.approvedBy,
    this.approvedDate,
    required this.status,
  });

  factory Mdt.fromJson(Map<String, dynamic> json) {
    return Mdt(
      nomorMdt: json['nomor_mdt'],
      tgl: json['tgl'],
      jam: json['jam'],
      terlambat: json['terlambat'],
      kepentingan: json['kepentingan'],
      keperluan: json['keperluan'],
      createdAt: json['created_at'],
      approvedBy: json['approved_by'],
      approvedDate: json['approved_date'],
      status: json['status'],
    );
  }
}