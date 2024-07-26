import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/model/sik.dart';
import 'package:uapp/modules/hr/pages/ijin_keluar_pulang/api_param.dart';

Future<String?> addSuratIjinKeluar(Map<String,String> params) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: params,
    );
    if (response.statusCode == 200) {
      return null;
    } else {
      return jsonDecode(response.body)['message'].toString();
    }
  } catch (e) {
    Log.d('Error: $e');
    return 'Error: $e';
  }
}

Future<String?> deleteSuratIjinKeluar(String nomorSik) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': HrMethodApi.deleteSuratIjinKeluarPulang,
        'nomor_sik': nomorSik,
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return null;
    } else {
      var body = jsonDecode(response.body);
      return body['message'].toString();
    }
  } catch (e) {
    Log.d('Error: $e');
    return 'Error: $e';
  }
}

Future<List<Sik>> getSuratIjinKeluar() async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final user = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': 'getsik',
        'nik': user.id,
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Sik.fromJson(e)).toList();
    } else {
      return [];
    }
  } catch (e) {
    Log.d('Error: $e');
    return [];
  }
}