class Route {
  final int? id;
  final String idRute;
  final String idCustomer;
  final String jadwalRute;
  final String keterangan;
  final String? createdAt;
  final String? updatedAt;
  final String? custID;
  final String? custname;
  final String? address;
  final String? phones;
  final String? personalName;

  Route({
    this.id,
    required this.idRute,
    required this.idCustomer,
    required this.jadwalRute,
    required this.keterangan,
    this.createdAt,
    this.updatedAt,
    this.custID,
    this.custname,
    this.address,
    this.phones,
    this.personalName,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'],
      idRute: json['id_rute'],
      idCustomer: json['id_customer'],
      jadwalRute: json['jadwal_rute'],
      keterangan: json['keterangan'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      custID: json['CustID'],
      custname: json['custname'],
      address: json['address'],
      phones: json['phones'],
      personalName: json['PersonalName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_rute': idRute,
      'id_customer': idCustomer,
      'jadwal_rute': jadwalRute,
      'keterangan': keterangan,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
