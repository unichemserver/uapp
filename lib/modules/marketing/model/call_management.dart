import 'package:hive_flutter/hive_flutter.dart';
// CustID, CustName, Address
part 'call_management.g.dart';

@HiveType(typeId: 0)
class CallManagement extends HiveObject {
  @HiveField(0)
  String? custID;
  @HiveField(1)
  String? custName;
  @HiveField(2)
  String? address;
  @HiveField(3)
  double? latitude;
  @HiveField(4)
  double? longitude;

  CallManagement({this.custID, this.custName, this.address});

  CallManagement.fromJson(Map<String, dynamic> json) {
    custID = json['CustID'];
    custName = json['CustName'];
    address = json['Address'];
    latitude = double.tryParse(json['GpsLatitude'].toString());
    longitude = double.tryParse(json['GpsLongitude'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CustID'] = custID;
    data['CustName'] = custName;
    data['Address'] = address;
    data['GpsLatitude'] = latitude;
    data['GpsLongitude'] = longitude;
    return data;
  }
}