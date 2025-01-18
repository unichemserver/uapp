import 'package:hive_flutter/hive_flutter.dart';

part 'price_list.g.dart';

@HiveType(typeId: 4)
class PriceList extends HiveObject {
  @HiveField(0)
  String? itemID;
  @HiveField(1)
  String? unitID;
  @HiveField(2)
  String? qty;
  @HiveField(3)
  String? unitPrice;
  @HiveField(4)
  String? topID;

  PriceList({required this.itemID, required this.unitID, required this.qty, required this.unitPrice, required this.topID});

  PriceList.fromJson(Map<String, dynamic> json) {
    itemID = json['ItemID'];
    unitID = json['UnitID'];
    qty = json['Qty'];
    unitPrice = json['UnitPrice'];
    topID = json['TOP_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ItemID'] = itemID;
    data['UnitID'] = unitID;
    data['Qty'] = qty;
    data['UnitPrice'] = unitPrice;
    data['TOP_ID'] = topID;
    return data;
  }
}