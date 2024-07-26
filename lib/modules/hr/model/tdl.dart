class Tdl {
  final String nomorTdl;
  final String tujuanDinas;
  final String keperluan;
  final String tglBerangkat;
  final String jamBerangkat;
  final String tglKembali;
  final String jamKembali;
  final String createdAt;
  final String? approvedBy;
  final String? approvedDate;
  final String status;

  Tdl({
    required this.nomorTdl,
    required this.tujuanDinas,
    required this.keperluan,
    required this.tglBerangkat,
    required this.jamBerangkat,
    required this.tglKembali,
    required this.jamKembali,
    required this.createdAt,
    this.approvedBy,
    this.approvedDate,
    required this.status,
  });

  factory Tdl.fromJson(Map<String, dynamic> json) {
    return Tdl(
      nomorTdl: json['nomor_tdl'],
      tujuanDinas: json['dinas_ke'],
      keperluan: json['keperluan'],
      tglBerangkat: json['tgl_berangkat'],
      jamBerangkat: json['jam_berangkat'],
      tglKembali: json['tgl_kembali'],
      jamKembali: json['jam_kembali'],
      createdAt: json['created_at'],
      approvedBy: json['approved_by'],
      approvedDate: json['approved_date'],
      status: json['status'],
    );
  }
}