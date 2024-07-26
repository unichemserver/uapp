class ApiParams {
  final String action = 'hr';
  final String method;
  String? nomorOrder;
  final String nik;
  final String jenisAlat;
  final String barang;
  final String mesin;
  final String gudang;
  final String bengkel;
  final String keterangan;
  final String? status;
  final String? approveDate;
  final String? approveBy;

  ApiParams({
    required this.method,
    required this.nik,
    required this.jenisAlat,
    required this.barang,
    required this.mesin,
    required this.gudang,
    required this.bengkel,
    required this.keterangan,
    this.nomorOrder,
    this.status,
    this.approveDate,
    this.approveBy,
  });

  factory ApiParams.fromJson(Map<String, dynamic> json) {
    return ApiParams(
      method: json['method'] ?? '',
      nik: json['no_nik'] ?? '',
      jenisAlat: json['jenis_alat'],
      barang: json['barang'],
      mesin: json['mesin'],
      gudang: json['gudang'],
      bengkel: json['bengkel'],
      keterangan: json['keterangan'],
      nomorOrder: json['nomor_orp'],
      status: json['status'],
      approveDate: json['approved_date'],
      approveBy: json['approved_by'],
    );
  }

  Map<String, dynamic> toJson() {
    var data = {
      'action': action,
      'method': method,
      'nik': nik,
      'jenis_alat': jenisAlat,
      'barang': barang.isEmpty ? '-' : barang,
      'mesin': mesin.isEmpty ? '-' : mesin,
      'gudang': gudang.isEmpty ? '-' : gudang,
      'bengkel': bengkel.isEmpty ? '-' : bengkel,
      'keterangan': keterangan,
    };
    if (nomorOrder != null) {
      data['no_order'] = nomorOrder!;
    }
    return data;
  }
}
