import 'package:hive_flutter/hive_flutter.dart';

part 'master_item.g.dart';

@HiveType(typeId: 1)
class MasterItem extends HiveObject {
  @HiveField(0)
  String? itemID;
  @HiveField(1)
  String? description;
  @HiveField(2)
  String? salesUnit;
  @HiveField(3)
  String? salesPrice;
  @HiveField(4)
  String? unitSetID;
  @HiveField(5)
  String? taxGroupID;

  MasterItem({this.itemID, this.description, this.salesUnit, this.salesPrice, this.unitSetID, this.taxGroupID});

  MasterItem.fromJson(Map<String, dynamic> json) {
    itemID = json['ItemID'];
    description = json['Description'];
    salesUnit = json['Sales_Unit'];
    salesPrice = json['Sales_Price'];
    unitSetID = json['UnitSetID'];
    taxGroupID = json['Tax_GroupID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ItemID'] = itemID;
    data['Description'] = description;
    data['Sales_Unit'] = salesUnit;
    data['Sales_Price'] = salesPrice;
    data['UnitSetID'] = unitSetID;
    data['Tax_GroupID'] = taxGroupID;
    return data;
  }
}