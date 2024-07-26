import 'package:uapp/modules/production/data/model/balance.dart';

class BalanceApiResponse {
  final String total;
  final List<Balance> data;
  final List<Map<String, String>> images;

  BalanceApiResponse({
    required this.total,
    required this.data,
    required this.images,
  });

  factory BalanceApiResponse.fromJson(Map<String, dynamic> json) {
    return BalanceApiResponse(
      total: json['total'],
      data: List<Balance>.from(json['data'].map((x) => Balance.fromJson(x))),
      images: List<Map<String, String>>.from(json['images'].map((x) => Map<String, String>.from(x))),
    );
  }
}