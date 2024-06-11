class To {
  final int id;
  final int idMarketingActivity;
  final String itemid;
  final String description;
  final int quantity;
  final String unit;
  final int price;

  To({
    required this.id,
    required this.idMarketingActivity,
    required this.itemid,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.price,
  });

  factory To.fromMap(Map<String, dynamic> map) {
    return To(
      id: map['id'],
      idMarketingActivity: map['id_marketing_activity'],
      itemid: map['itemid'],
      description: map['description'],
      quantity: map['quantity'],
      unit: map['unit'],
      price: map['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_marketing_activity': idMarketingActivity,
      'itemid': itemid,
      'description': description,
      'quantity': quantity,
      'unit': unit,
      'price': price,
    };
  }
}