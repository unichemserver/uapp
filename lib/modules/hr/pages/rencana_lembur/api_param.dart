class ApiParams {
  final String action = 'hr';
  final String method;
  String? nomorRc;
  final String nik;
  final String gudang;
  final String barang;
  final String tanggal;
  final String jamAwal;
  final String jamAkhir;
  final String tugasKerja;
  final String tenagaKerja;
  final String bantuanAlatBerat;

  ApiParams({
    this.nomorRc,
    required this.nik,
    required this.gudang,
    required this.barang,
    required this.method,
    required this.tanggal,
    required this.jamAwal,
    required this.jamAkhir,
    required this.tugasKerja,
    required this.tenagaKerja,
    required this.bantuanAlatBerat,
  });

  Map<String, String> toJson() {
    return {
      'action': action,
      'method': method,
      'nik': nik,
      'nomor_rc': nomorRc ?? '',
      'gudang': gudang,
      'barang': barang,
      'tgl': tanggal,
      'jam_awal': jamAwal,
      'jam_akhir': jamAkhir,
      'tugas_kerja': tugasKerja,
      'tenaga_kerja': tenagaKerja,
      'bantuan_alat_berat': bantuanAlatBerat
    };
  }
}