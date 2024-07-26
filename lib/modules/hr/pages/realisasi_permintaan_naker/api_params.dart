class ApiParams {
  final String action = 'hr';
  final String method;
  final String nomorPtk;
  final String noNik;
  final String nik;
  final String barang;
  final String tgl;
  final String jamAwal;
  final String jamAkhir;
  final String keterangan;
  final String alatBerat;
  final String jamAwalAlatBerat;
  final String jamAkhirAlatBerat;
  final String keteranganAlatBerat;
  final bool isBorongan;

  ApiParams({
    required this.method,
    required this.nomorPtk,
    required this.noNik,
    required this.nik,
    required this.barang,
    required this.tgl,
    required this.jamAwal,
    required this.jamAkhir,
    required this.keterangan,
    required this.alatBerat,
    required this.jamAwalAlatBerat,
    required this.jamAkhirAlatBerat,
    required this.keteranganAlatBerat,
    required this.isBorongan,
  });

  Map<String, String> toMap() {
    String keyForNomorPtk = isBorongan ? 'nomor_ptkb' : 'nomor_ptk';

    return {
      'action': action,
      'method': method,
      keyForNomorPtk: nomorPtk,
      'no_nik': noNik,
      'nik': nik,
      'barang': barang,
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
