class Stock {
  final int id;
  final int idMA;
  final String itemID;
  final String name;
  final double quantity;
  final String unit;
  final String imagePath;

  Stock({
    required this.id,
    required this.idMA,
    required this.itemID,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.imagePath,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'],
      idMA: json['id_marketing_activity'],
      itemID: json['item_id'],
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
      imagePath: json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_marketing_activity': idMA,
      'item_id': itemID,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'image_path': imagePath,
    };
  }
}