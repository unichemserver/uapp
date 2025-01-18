class StockModel {
  String? idMA;
  String? itemId;
  String? name;
  int? quantity;
  String? unit;
  String? imagePath;

  StockModel({
    this.idMA,
    this.itemId,
    this.name,
    this.quantity,
    this.unit,
    this.imagePath,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
        idMA: json["idMA"],
        itemId: json["item_id"],
        name: json["name"],
        quantity: json["quantity"],
        unit: json["unit"],
        imagePath: json["image_path"],
      );

  Map<String, dynamic> toJson() => {
        "idMA": idMA,
        "item_id": itemId,
        "name": name,
        "quantity": quantity,
        "unit": unit,
        "image_path": imagePath,
      };
}