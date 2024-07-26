class TempData {
  final int primaryKey;
  final String id;
  final String nama;
  String? barang;
  String? namaBarang;
  final String jamMasuk;
  final String jamPulang;
  final String keterangan;
  final bool isKaryawan;

  TempData({
    required this.primaryKey,
    required this.id,
    required this.nama,
    this.barang,
    this.namaBarang,
    required this.jamMasuk,
    required this.jamPulang,
    required this.keterangan,
    required this.isKaryawan,
  });
}