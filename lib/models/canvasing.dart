class Canvasing {
  final String customerId;
  final String? namaOutlet;
  final String? namaOwner;
  final String? noTelp;
  final String? alamat;
  final double? latitude;
  final double? longitude;
  final String? imagePath;

  Canvasing({
    required this.customerId,
    required this.namaOutlet,
    required this.namaOwner,
    required this.noTelp,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    this.imagePath,
  });

  factory Canvasing.fromJson(Map<String, dynamic> json) {
    return Canvasing(
      customerId: json['CustID'],
      namaOutlet: json['nama_outlet'],
      namaOwner: json['nama_owner'],
      noTelp: json['no_hp'],
      alamat: json['alamat'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      imagePath: json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CustID': customerId,
      'nama_outlet': namaOutlet,
      'nama_owner': namaOwner,
      'no_hp': noTelp,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'image_path': imagePath,
    };
  }
}
