class Balance {
  final String description;
  final String trDate;
  final String trNo;
  final String trTime;
  final String descEng;
  final String beginQty;
  final String inventoryUnit;
  final String qty;
  final String endQty;

  Balance({
    required this.description,
    required this.trDate,
    required this.trNo,
    required this.trTime,
    required this.descEng,
    required this.beginQty,
    required this.inventoryUnit,
    required this.qty,
    required this.endQty,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      description: json['Description'] ?? '',
      trDate: json['TrDate'] ?? '',
      trNo: json['TrNo'] ?? '',
      trTime: json['TrTime'] ?? '',
      descEng: json['Desc_Eng'] ?? '',
      beginQty: json['BeginQty'] ?? '',
      inventoryUnit: json['Inventory_Unit'] ?? '',
      qty: json['Qty'] ?? '',
      endQty: json['endqty'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Description': description,
      'TrDate': trDate,
      'TrNo': trNo,
      'TrTime': trTime,
      'Desc_Eng': descEng,
      'BeginQty': beginQty,
      'Inventory_Unit': inventoryUnit,
      'Qty': qty,
      'endqty': endQty,
    };
  }
}