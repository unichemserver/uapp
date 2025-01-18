class CustactiveModel {
  final String? id;
  final String? name;
  final String? address;
  final double? latitude;
  final double? longitude;

  CustactiveModel({
    required this.id,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
  });

  factory CustactiveModel.fromJson(Map<String, dynamic> json) {
    return CustactiveModel(
      id: json['CustID'],
      name: json['CustName'],
      address: json['Address'],
      latitude: double.tryParse(json['Latitude'] ?? ''),
      longitude: double.tryParse(json['Longitude'] ?? ''),
    );
  }
}