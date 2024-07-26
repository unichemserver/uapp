import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/model/rc.dart';
import 'package:uapp/modules/hr/pages/rencana_lembur/api_param.dart';

Future<Map<String, dynamic>> getDataUtils() async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': 'gudang_alatberat_barang',
      }
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return {};
  } catch (e) {
    return {};
  }
}

Future<String?> addRencanaLembur(ApiParams params) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    print(params.toJson());
    final response = await http.post(
      Uri.parse(baseUrl),
      body: params.toJson(),
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return null;
    }
    return json.decode(response.body)['message'];
  } catch (e) {
    print(e);
    return 'Terjadi kesalahan';
  }
}

Future<List<Rc>> getRencanaLembur() async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final userData = User.fromJson(json.decode(box.get(HiveKeys.userData)));
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': 'getrc',
        'nik': userData.id,
      }
    );
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Rc> result = [];
      for (var item in data) {
        result.add(Rc.fromJson(item));
      }
      return result;
    }
    return [];
  } catch (e) {
    print(e);
    return [];
  }
}

Future<String?> deleteRencanaLembur(String nomorRc) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': HrMethodApi.deleteRencanaLembur,
        'nomor_rc': nomorRc,
      }
    );
    if (response.statusCode == 200) {
      return null;
    }
    return json.decode(response.body)['message'];
  } catch (e) {
    return 'Terjadi kesalahan';
  }
}
