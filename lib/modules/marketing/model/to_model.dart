class ToModel {
  String? idMA;
  String? itemid;
  String? description;
  int? quantity;
  String? unit;
  int? price;

  ToModel({
    this.idMA,
    this.itemid,
    this.description,
    this.quantity,
    this.unit,
    this.price,
  });

  factory ToModel.fromJson(Map<String, dynamic> json) {
    return ToModel(
      idMA: json['idMA'],
      itemid: json['itemid'],
      description: json['description'],
      quantity: json['quantity'],
      unit: json['unit'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idMA'] = idMA;
    data['itemid'] = itemid;
    data['description'] = description;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['price'] = price;
    return data;
  }
}

// idMA INTEGER,
//     itemid TEXT,
// description TEXT,
//     quantity DECIMAL(10, 2),
// unit TEXT,
// price DECIMAL(10, 2)