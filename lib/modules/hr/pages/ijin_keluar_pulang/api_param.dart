class ApiParams {
  final String action = 'hr';
  final String method;
  final String nik;
  String? nomorSik;
  final String tujuan;
  final String kepentingan;
  final String alasan;
  final String jamKeluar;
  final String jamMasuk;

  ApiParams({
    this.nomorSik,
    required this.nik,
    required this.method,
    required this.tujuan,
    required this.kepentingan,
    required this.alasan,
    required this.jamKeluar,
    required this.jamMasuk,
  });

  Map<String, String> toJson() {
    var map = <String, String>{
      'nik': nik,
      'action': action,
      'method': method,
      'tujuan': tujuan,
      'kepentingan': kepentingan,
      'alasan': alasan,
      'jam_keluar': jamKeluar,
      'jam_masuk': jamMasuk,
    };
    if (nomorSik != null) {
      map['nomor_sik'] = nomorSik!;
    }
    return map;
  }
}