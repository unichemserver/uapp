class SalesCust {
  final String nik;
  final String nama;
  final String telp;
  final String pic;
  final String area;
  final String alamat;

  SalesCust(
      {required this.nik,
      required this.nama,
      required this.telp,
      required this.pic,
      required this.area,
      required this.alamat});

  factory SalesCust.fromJson(Map<String, dynamic> json) {
    return SalesCust(
      nik: json['nik'],
      nama: json['nama'],
      telp: json['telp'],
      pic: json['pic'],
      area: json['area'],
      alamat: json['alamat'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nik'] = nik;
    data['nama'] = nama;
    data['telp'] = telp;
    data['pic'] = pic;
    data['area'] = area;
    data['alamat'] = alamat;
    return data;
  }
}

List<SalesCust> listCustomer = [
  SalesCust(
    nik: '1562',
    nama: 'Toko Ari Sayur',
    telp: '',
    pic: '',
    area: 'Sedati',
    alamat: 'Ps. Betro Blok B. 16',
  ),
  SalesCust(
    nik: '1562',
    nama: 'Toko Agung',
    telp: '',
    pic: '',
    area: 'Sedati',
    alamat: 'Ps. Betro Blok B. 68',
  ),
  SalesCust(
    nik: '1562',
    nama: 'Toko Rejeki',
    telp: '',
    pic: '',
    area: 'Sedati',
    alamat: 'Ps. Betro Blok C.8',
  ),
  SalesCust(
    nik: '1562',
    nama: 'Toko Lilik',
    telp: '',
    pic: '',
    area: 'Sedati',
    alamat: 'Ps. Betro Blok B. 55',
  ),
  SalesCust(
    nik: '1562',
    nama: 'Toko Bu Yanti',
    telp: '',
    pic: '',
    area: 'Sedati',
    alamat: 'Ps. Betro Blok B. 29',
  ),
  SalesCust(
    nik: '1562',
    nama: 'Toko A. 38',
    telp: '',
    pic: '',
    area: 'Sedati',
    alamat: 'Ps. Betro Blok A.38/ 37',
  ),
  SalesCust(
    nik: '1562',
    nama: 'Bu Selep',
    telp: '',
    pic: '',
    area: 'Sedati',
    alamat: 'Ps. Betro Blok A. 85',
  ),
  SalesCust(
    nik: '1562',
    nama: 'Toko Rosul',
    telp: '',
    pic: '',
    area: 'Sedati',
    alamat: 'Ps. Betro A. 42',
  ),
  SalesCust(
    nik: '1562',
    nama: 'Toko Calestu',
    telp: '083856128387',
    pic: '',
    area: 'Sedati',
    alamat: 'Jl. Sedati area R1',
  ),
  SalesCust(
    nik: '1562',
    nama: 'Toko Rama',
    telp: '08817184907',
    pic: '',
    area: 'Sedati',
    alamat: 'Jl. Kalanganyar',
  ),
  SalesCust(
    nik: '1562',
    nama: 'Toko Hanura',
    telp: '083830712141',
    pic: '',
    area: 'Sedati',
    alamat: 'Jl. Kalanganyar',
  ),
  SalesCust(
    nik: '1562',
    nama: 'Toko Lestari',
    telp: '082141301217',
    pic: '',
    area: 'Sedati',
    alamat: 'Jl. Buncitan No.101',
  ),
];
