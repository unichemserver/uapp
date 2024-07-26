class ApiParams {
  final String action = 'hr';
  final String method;
  String? nomorSjtm;
  final String nik;
  final String drTgl;
  final String smpTgl;
  final String keperluan;
  final String keterangan;

  ApiParams({
    required this.method,
    this.nomorSjtm,
    required this.nik,
    required this.drTgl,
    required this.smpTgl,
    required this.keperluan,
    required this.keterangan,
  });

  Map<String, String> toJson() {
    return {
      'action': action,
      'method': method,
      'nomor_sjtm': nomorSjtm ?? '',
      'nik': nik,
      'dr_tgl': drTgl,
      'sp_tgl': smpTgl,
      'keperluan': keperluan,
      'keterangan': keterangan,
    };
  }
}
