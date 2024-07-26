class ApiParams {
  final String action = 'hr';
  String? nomorSkm;
  final String method;
  final String nik;
  final String idMobil;
  final String tujuan;
  final String keperluan;
  final String tglAwal;
  final String tglAkhir;
  final String jamKeluar;
  final String kmKeluar;
  final String jamKembali;
  final String kmKembali;
  final String pengikut;

  ApiParams({
    this.nomorSkm,
    required this.method,
    required this.nik,
    required this.idMobil,
    required this.tujuan,
    required this.keperluan,
    required this.tglAwal,
    required this.tglAkhir,
    required this.jamKeluar,
    required this.kmKeluar,
    required this.jamKembali,
    required this.kmKembali,
    required this.pengikut,
  });

  Map<String, String> toJson() {
    final map = <String, String>{
      'action': action,
      'method': method,
      'nik': nik,
      'nopol': idMobil,
      'tujuan': tujuan,
      'keperluan': keperluan,
      'tgl_awal': tglAwal,
      'tgl_akhir': tglAkhir,
      'jam_keluar': jamKeluar,
      'km_keluar': kmKeluar,
      'jam_kembali': jamKembali,
      'km_kembali': kmKembali,
      'pengikut': pengikut,
    };
    if (nomorSkm != null) {
      map['nomor_skm'] = nomorSkm!;
    }
    return map;
  }
}