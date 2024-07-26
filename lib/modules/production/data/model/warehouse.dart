class Warehouse {
  final String locationId;
  final String locationName;

  Warehouse({required this.locationId, required this.locationName});

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      locationId: json['locationid'],
      locationName: json['Description'],
    );
  }


}