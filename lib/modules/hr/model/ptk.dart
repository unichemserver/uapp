class Ptk {
  final String nomorPtk;
  final String barang;
  final String gudang;
  final String tglAwal;
  final String tglAkhir;
  final String jamAwal;
  final String jamAkhir;
  final String tugasKerja;
  final String tenagaKerja;
  final String status;
  final String createdAt;
  final String? approvedBy;
  final String? approvedAt;

  Ptk({
    required this.nomorPtk,
    required this.barang,
    required this.gudang,
    required this.tglAwal,
    required this.tglAkhir,
    required this.jamAwal,
    required this.jamAkhir,
    required this.tugasKerja,
    required this.tenagaKerja,
    required this.status,
    required this.createdAt,
    this.approvedBy,
    this.approvedAt,
  });

  factory Ptk.fromJson(Map<String, dynamic> json) {
    return Ptk(
      nomorPtk: json['nomor_ptk'],
      barang: json['barang'],
      gudang: json['gudang'],
      tglAwal: json['tgl_awal'],
      tglAkhir: json['tgl_akhir'],
      jamAwal: json['jam_awal'],
      jamAkhir: json['jam_akhir'],
      tugasKerja: json['tugas_kerja'],
      tenagaKerja: json['tenaga_kerja'],
      status: json['status'],
      createdAt: json['created_at'],
      approvedBy: json['approved_by'],
      approvedAt: json['approved_date'],
    );
  }
}