class CallManagementModel {
  final String? id;
  final String? name;
  final String? address;
  final double? latitude;
  final double? longitude;

  CallManagementModel({
    required this.id,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
  });

  factory CallManagementModel.fromJson(Map<String, dynamic> json) {
    return CallManagementModel(
      id: json['CustID'],
      name: json['CustName'],
      address: json['Address'],
      latitude: double.tryParse(json['Latitude'] ?? ''),
      longitude: double.tryParse(json['Longitude'] ?? ''),
    );
  }
}