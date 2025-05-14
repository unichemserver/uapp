class CanvasingModel {
  String? idMA;
  String? custID;
  String? namaOutlet;
  String? namaOwner;
  String? noHp;
  double? latitude;
  double? longitude;
  String? alamat;
  String? imagePath;
  String? waktuCo;
  int? pembayaran;
  int? status;

  CanvasingModel({
    this.idMA,
    this.custID,
    this.namaOutlet,
    this.namaOwner,
    this.noHp,
    this.latitude,
    this.longitude,
    this.alamat,
    this.imagePath,
    this.waktuCo,
    this.pembayaran,
    this.status,
  });

  factory CanvasingModel.fromJson(Map<String, dynamic> json) {
    return CanvasingModel(
      idMA: json['id'],
      custID: json['CustID'],
      namaOutlet: json['nama_outlet'],
      namaOwner: json['nama_owner'],
      noHp: json['no_hp'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      alamat: json['alamat'],
      imagePath: json['image_path'],
      waktuCo: json['waktu_co'],
      pembayaran: json['pembayaran'],
      status: json['status_sync'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CustID': custID,
      'nama_outlet': namaOutlet,
      'nama_owner': namaOwner,
      'no_hp': noHp,
      'latitude': latitude,
      'longitude': longitude,
      'alamat': alamat,
      'image_path': imagePath,
      'pembayaran': pembayaran,
    };
  }
}