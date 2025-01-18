import 'package:hive/hive.dart';

part 'cust_top.g.dart';

@HiveType(typeId: 3)
class CustTop extends HiveObject {
  @HiveField(0)
  String topID;

  @HiveField(1)
  String custID;

  CustTop({required this.topID, required this.custID});

  CustTop.fromJson(Map<String, dynamic> json)
      : topID = json['TOP_ID'],
        custID = json['CustID'];

  Map<String, dynamic> toJson() {
    return {
      'TOP_ID': topID,
      'CustID': custID,
    };
  }
}
