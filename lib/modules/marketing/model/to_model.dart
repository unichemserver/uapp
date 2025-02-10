class ToModel {
  String? idMA;
  String? itemid;
  String? description;
  int? quantity;
  String? unit;
  int? price;
  String? topID;
  String? unitID;

  ToModel({
    this.idMA,
    this.itemid,
    this.description,
    this.quantity,
    this.unit,
    this.price,
    this.topID,
    this.unitID,
  });

  factory ToModel.fromJson(Map<String, dynamic> json) {
    return ToModel(
      idMA: json['idMA'],
      itemid: json['itemid'],
      description: json['description'],
      quantity: json['quantity'],
      unit: json['unit'],
      price: json['price'],
      topID: json['top'],
      unitID: json['unit_id'],
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
    data['top'] = topID;
    data['unit_id'] = unitID;
    return data;
  }
}