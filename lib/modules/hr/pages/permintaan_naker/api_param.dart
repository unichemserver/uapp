class ApiParams {
  final String action  = 'hr';
  final String method;
  final String nik;
  String? nomorPtk;
  final String barang;
  final String gudang;
  final String tglAwal;
  final String tglAkhir;
  final String jamAwal;
  final String jamAkhir;
  final String tugasKerja;
  final String tenagaKerja;

  ApiParams({
    required this.method,
    required this.nik,
    this.nomorPtk,
    required this.barang,
    required this.gudang,
    required this.tglAwal,
    required this.tglAkhir,
    required this.jamAwal,
    required this.jamAkhir,
    required this.tugasKerja,
    required this.tenagaKerja,
  });

  Map<String, String> toJson() {
     var map = <String, String>{
      'action': action,
      'method': method,
      'nik': nik,
      'barang': barang,
      'gudang': gudang,
      'tgl_awal': tglAwal,
      'tgl_akhir': tglAkhir,
      'jam_awal': jamAwal,
      'jam_akhir': jamAkhir,
      'tugas_kerja': tugasKerja,
      'tenaga_kerja': tenagaKerja,
    };
    if (nomorPtk != null) {
      map['nomor_ptk'] = nomorPtk!;
    }
    return map;
  }
}