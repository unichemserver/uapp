class Noo {
  final int? id;
  final String? groupPelanggan;
  final String? metodePembayaran;
  final String? termin;
  final String? jaminan;
  final String? namaPerusahaan;
  final String? areaPemasaran;
  final String? namaOwner;
  final String? noKtp;
  final int? umur;
  final String? jekel;
  final String? noTelepon;
  final String? email;
  final String? address;
  final String? desa;
  final String? kec;
  final String? kab;
  final String? prov;
  final String? kodePos;

  Noo({
    this.id,
    this.groupPelanggan,
    this.metodePembayaran,
    this.termin,
    this.jaminan,
    this.namaPerusahaan,
    this.areaPemasaran,
    this.namaOwner,
    this.noKtp,
    this.umur,
    this.jekel,
    this.noTelepon,
    this.email,
    this.address,
    this.desa,
    this.kec,
    this.kab,
    this.prov,
    this.kodePos,
  });

  factory Noo.fromJson(Map<String, dynamic> json) {
    return Noo(
      id: json['id'],
      groupPelanggan: json['group_pelanggan'],
      metodePembayaran: json['metode_pembayaran'],
      termin: json['termin'],
      jaminan: json['jaminan'],
      namaPerusahaan: json['nama_perusahaan'],
      areaPemasaran: json['area_pemasaran'],
      namaOwner: json['nama_owner'],
      noKtp: json['no_ktp'],
      umur: json['umur'],
      jekel: json['jekel'],
      noTelepon: json['no_telepon'],
      email: json['email'],
      address: json['address'],
      desa: json['desa'],
      kec: json['kec'],
      kab: json['kab'],
      prov: json['prov'],
      kodePos: json['kode_pos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_pelanggan': groupPelanggan,
      'metode_pembayaran': metodePembayaran,
      'termin': termin,
      'jaminan': jaminan,
      'nama_perusahaan': namaPerusahaan,
      'area_pemasaran': areaPemasaran,
      'nama_owner': namaOwner,
      'no_ktp': noKtp,
      'umur': umur,
      'jekel': jekel,
      'no_telepon': noTelepon,
      'email': email,
      'address': address,
      'desa': desa,
      'kec': kec,
      'kab': kab,
      'prov': prov,
      'kode_pos': kodePos,
    };
  }
}
