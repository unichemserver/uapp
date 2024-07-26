import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/model/tdl.dart';
import 'package:uapp/modules/hr/pages/dinas_luar/api_param.dart';

Future<String?> addDinasLuar(ApiParams params) async {
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
    return json.decode(response.body)['message'];
  } catch (e) {
    Log.d('Error: $e');
    return 'Terjadi kesalahan';
  }
}

Future<List<Tdl>> getDinasLuar(String nik) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': 'gettdl',
        'nik': nik,
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      Log.d('Response: $body');
      final data = body as List;
      return data.map((e) => Tdl.fromJson(e)).toList();
    }
    return [];
  } catch (e) {
    Log.d('Error: $e');
    return [];
  }
}

Future<String?> deleteDinasLuar(String nomorTdl) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': HrMethodApi.deleteTugasDinasLuar,
        'nomor_tdl': nomorTdl,
      },
    );

    Log.d('Response: ${response.body}');
    if (response.statusCode == 200) {
      return null;
    }
    return json.decode(response.body)['message'];
  } catch (e) {
    Log.d('Error: $e');
    return 'Terjadi kesalahan';
  }
}