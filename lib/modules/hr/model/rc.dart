class Rc {
  final String nomorRc;
  final String? gudang;
  final String? barang;
  final String tgl;
  final String jamAwal;
  final String jamAkhir;
  final String tugasKerja;
  final String tenagaKerja;
  final String? bantuanAlat;
  final String createdDate;
  final String status;
  final String? approvedBy;
  final String? approvedDate;

  Rc({
    required this.nomorRc,
    this.gudang,
    this.barang,
    required this.tgl,
    required this.jamAwal,
    required this.jamAkhir,
    required this.tugasKerja,
    required this.tenagaKerja,
    this.bantuanAlat,
    required this.createdDate,
    required this.status,
    this.approvedBy,
    this.approvedDate,
  });

  factory Rc.fromJson(Map<String, dynamic> json) {
    return Rc(
      nomorRc: json['nomor_rc'] ?? '',
      gudang: json['gudang'],
      barang: json['barang'],
      tgl: json['tgl'] ?? '',
      jamAwal: json['jam_awal'] ?? '',
      jamAkhir: json['jam_akhir'] ?? '',
      tugasKerja: json['tugas_kerja'] ?? '',
      tenagaKerja: json['tenaga_kerja'] ?? '',
      bantuanAlat: json['bantuan_alat_berat'],
      createdDate: json['created_at'] ?? '',
      status: json['status'] ?? '',
      approvedBy: json['approved_by'],
      approvedDate: json['approved_date'],
    );
  }
}