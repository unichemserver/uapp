class NomorRencanLembur {
  final String nomorRc;
  final String tgl;

  NomorRencanLembur({
    required this.nomorRc,
    required this.tgl,
  });

  factory NomorRencanLembur.fromJson(Map<String, dynamic> json) {
    return NomorRencanLembur(
      nomorRc: json['nomor_rc'],
      tgl: json['tgl'],
    );
  }
}