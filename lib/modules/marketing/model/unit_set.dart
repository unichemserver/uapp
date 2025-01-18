import 'package:hive_flutter/hive_flutter.dart';

part 'unit_set.g.dart';

@HiveType(typeId: 2)
class UnitSet extends HiveObject {
  @HiveField(0)
  String? unitSetID;
  @HiveField(1)
  String? unitID;
  @HiveField(2)
  String? conversion;

  UnitSet({this.unitSetID, this.unitID, this.conversion});

  UnitSet.fromJson(Map<String, dynamic> json) {
    unitSetID = json['UnitSetID'];
    unitID = json['UnitID'];
    conversion = json['Conversion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UnitSetID'] = unitSetID;
    data['UnitID'] = unitID;
    data['Conversion'] = conversion;
    return data;
  }
}