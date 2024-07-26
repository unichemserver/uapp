class ApiParams {
  final String action = 'hr';
  final String method;
  final String noNik;
  final String tujuan;
  String? nomorSik;
  final String kepentingan;
  final String alasan;
  final String jamKeluar;
  final String jamMasuk;
  final String nik;

  ApiParams({
    this.nomorSik,
    required this.noNik,
    required this.method,
    required this.tujuan,
    required this.kepentingan,
    required this.alasan,
    required this.jamKeluar,
    required this.jamMasuk,
    required this.nik,
  });

  Map<String, String> toJson() {
    var map = <String, String>{
      'no_nik': noNik,
      'action': action,
      'method': method,
      'tujuan': tujuan,
      'kepentingan': kepentingan,
      'alasan': alasan,
      'jam_keluar': jamKeluar,
      'jam_masuk': jamMasuk,
      'nik': nik,
    };
    if (nomorSik != null) {
      map['nomor_sik'] = nomorSik!;
    }
    return map;
  }
}