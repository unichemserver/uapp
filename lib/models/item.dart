class Item {
  final String itemid;
  final String description;
  final String unitsetid;
  final String inventoryUnit;

  Item({
    required this.itemid,
    required this.description,
    required this.unitsetid,
    required this.inventoryUnit,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemid: json['itemid'],
      description: json['description'],
      unitsetid: json['unitsetid'],
      inventoryUnit: json['Inventory_Unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemid': itemid,
      'description': description,
      'unitsetid': unitsetid,
      'Inventory_Unit': inventoryUnit,
    };
  }
}
