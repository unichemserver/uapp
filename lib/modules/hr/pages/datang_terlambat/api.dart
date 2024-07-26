import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/model/mdt.dart';
import 'package:uapp/modules/hr/pages/datang_terlambat/api_param.dart';

Future<String?> addDatangTerlambat(ApiParams params) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: params.toJson(),
    );
    if (response.statusCode == 200) {
      return null;
    }
    return jsonDecode(response.body)['message'];
  } catch (e) {
    return 'Terjadi kesalahan';
  }
}

Future<List<Mdt>> getDatangTerlambat(String nik) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': 'getmdt',
        'nik': nik,
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Mdt.fromJson(e)).toList();
    }
    return [];
  } catch (e) {
    return [];
  }
}

Future<String?> deleteDatangTerlambat(String nomorMdt) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': HrMethodApi.deleteDatangTerlambat,
        'nomor_mdt': nomorMdt,
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return null;
    }
    return jsonDecode(response.body)['message'];
  } catch (e) {
    return 'Terjadi kesalahan';
  }
}