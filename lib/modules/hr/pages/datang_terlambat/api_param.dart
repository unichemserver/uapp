class ApiParams {
  final String action = 'hr';
  final String method;
  String? nomorMdt;
  final String nik;
  final String tgl;
  final String jam;
  final String terlambat;
  final String kepentingan;
  final String keperluan;

  ApiParams({
    this.nomorMdt,
    required this.method,
    required this.nik,
    required this.tgl,
    required this.jam,
    required this.terlambat,
    required this.kepentingan,
    required this.keperluan,
  });

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'method': method,
      'nomor_mdt': nomorMdt ?? '',
      'nik': nik,
      'tgl': tgl,
      'jam': jam,
      'terlambat': terlambat,
      'kepentingan': kepentingan,
      'keperluan': keperluan,
    };
  }
}