class ApiParams {
  final String action = 'hr';
  final String method;
  final String nomorRc;
  final String noNik;
  final String nik; // list daftar nik
  final String tgl;
  final String jamAwal; // list daftar jam masuk
  final String jamAkhir; // list daftar jam pulang
  final String keterangan; // list daftar tugas kerja
  final String alatBerat; // list daftar bantuan alat berat
  final String jamAwalAlatBerat; // list daftar jam awal alat berat
  final String jamAkhirAlatBerat; // list daftar jam akhir alat berat
  final String keteranganAlatBerat; // list daftar keterangan alat berat

  ApiParams({
    required this.nomorRc,
    required this.noNik,
    required this.nik,
    required this.method,
    required this.tgl,
    required this.jamAwal,
    required this.jamAkhir,
    required this.keterangan,
    required this.alatBerat,
    required this.jamAwalAlatBerat,
    required this.jamAkhirAlatBerat,
    required this.keteranganAlatBerat,
  });

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'method': method,
      'nomor_rc': nomorRc,
      'no_nik': noNik,
      'nik': nik,
      'tgl': tgl,
      'jam_awal': jamAwal,
      'jam_akhir': jamAkhir,
      'keterangan': keterangan,
      'alat_berat': alatBerat,
      'jam_awal_alat_berat': jamAwalAlatBerat,
      'jam_akhir_alat_berat': jamAkhirAlatBerat,
      'keterangan_alat_berat': keteranganAlatBerat,
    };
  }
}