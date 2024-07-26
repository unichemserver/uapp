import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/peralatan_reparasi.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/api_param.dart';

Future<ResponseData?> getItAlatBerat() async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': 'peralatan_reparasi',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return ResponseData.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<String?> addOrderReparasi(ApiParams params) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: params.toJson(),
    );
    print('response: ${response.body}');
    print('status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      return null;
    } else {
      return 'Gagal menambahkan order reparasi';
    }
  } catch (e) {
    return e.toString();
  }
}

Future<List<ApiParams>> getORP() async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': 'getor',
        'nik': Utils.getUserData().id,
      },
    );
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<ApiParams> data = [];
      for (var item in body) {
        data.add(ApiParams.fromJson(item));
      }
      return data;
    } else {
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

Future<String?> deleteORP(String nomorOrder) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': 'delete_order_reparasi',
        'nomor_or': nomorOrder,
      },
    );
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      return null;
    } else {
      return 'Gagal menghapus order reparasi';
    }
  } catch (e) {
    print('Error: $e');
    return e.toString();
  }
}