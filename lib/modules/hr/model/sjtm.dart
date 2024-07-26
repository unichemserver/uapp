class Sjtm {
  final String nomorSjtm;
  final String drTgl;
  final String spTgl;
  final String keperluan;
  final String keterangan;
  final String? dokumenIjinPribadi;
  final String createdAt;
  final String? approvedBy;
  final String? approvedDate;
  final String status;

  Sjtm({
    required this.nomorSjtm,
    required this.drTgl,
    required this.spTgl,
    required this.keperluan,
    required this.keterangan,
    this.dokumenIjinPribadi,
    required this.createdAt,
    this.approvedBy,
    this.approvedDate,
    required this.status,
  });

  factory Sjtm.fromJson(Map<String, dynamic> json) {
    return Sjtm(
      nomorSjtm: json['nomor_sjtm'],
      drTgl: json['dr_tgl'],
      spTgl: json['sp_tgl'],
      keperluan: json['keperluan'],
      keterangan: json['keterangan'],
      dokumenIjinPribadi: json['dokumen_ijin_pribadi'],
      createdAt: json['created_at'],
      approvedBy: json['approved_by'],
      approvedDate: json['approved_date'],
      status: json['status'],
    );
  }
}