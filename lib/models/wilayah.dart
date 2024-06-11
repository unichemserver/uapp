class Wilayah {
  final String id;
  final String name;

  Wilayah({
    required this.id,
    required this.name,
  });

  factory Wilayah.fromJson(Map<String, dynamic> json) {
    return Wilayah(
      id: json['id'],
      name: json['name'],
    );
  }
}