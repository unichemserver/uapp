class Price {
  final String itemid;
  final String unit_price;
  final int min_qty;
  final String unitid;
  final int version;
  final String description;

  Price({
    required this.itemid,
    required this.unit_price,
    required this.min_qty,
    required this.unitid,
    required this.version,
    required this.description,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      itemid: json['itemid'],
      unit_price: json['unit_price'],
      min_qty: json['min_qty'],
      unitid: json['unitid'],
      version: json['version'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemid': itemid,
      'unit_price': unit_price,
      'min_qty': min_qty,
      'unitid': unitid,
      'version': version,
      'description': description,
    };
  }
}