class ApiParams {
  final String action = 'hr';
  final String method;
  String? nomorTdl;
  final String nik;
  final String tujuanDinas;
  final String keperluan;
  final String tglBerangkat;
  final String jamBerangkat;
  final String tglKembali;
  final String jamKembali;

  ApiParams({
    required this.method,
    this.nomorTdl,
    required this.nik,
    required this.tujuanDinas,
    required this.keperluan,
    required this.tglBerangkat,
    required this.jamBerangkat,
    required this.tglKembali,
    required this.jamKembali,
  });

  Map<String, String> toJson() {
    return {
      'action': action,
      'method': method,
      'nomor_tdl': nomorTdl ?? '',
      'nik': nik,
      'dinas_ke': tujuanDinas,
      'keperluan': keperluan,
      'tgl_berangkat': tglBerangkat,
      'jam_berangkat': jamBerangkat,
      'tgl_kembali': tglKembali,
      'jam_kembali': jamKembali,
    };
  }
}