import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/pages/tidak_masuk/api_param.dart';
import 'package:uapp/modules/hr/model/sjtm.dart';

Future<String?> addTidakMasuk(Map<String, String> params, {String? doc}) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    if (doc != null) {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.fields.addAll(params);
      request.files.add(await http.MultipartFile.fromPath('dokumen_ijin_pribadi', doc));
      var response = await request.send();
      Log.d('Response: ${response.statusCode}');
      Log.d('Response: ${response.reasonPhrase}');
      var res = await response.stream.bytesToString();
      Log.d('Response: $res');
      var bodyRes = json.decode(res);
      if (response.statusCode == 200) {
        return null;
      }
      return bodyRes['message'];
    }
    final response = await http.post(
      Uri.parse(baseUrl),
      body: params,
    );

    // Log.d('Request: ${params}');
    // Log.d('Response: ${response.body}');
    if (response.statusCode == 200) {
      return null;
    }
    return json.decode(response.body)['message'];
  } catch (e) {
    Log.d('Error: $e');
    return 'Terjadi kesalahan';
  }
}

Future<List<Sjtm>> getTidakMasuk(String nik) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': 'getsjtm',
        'nik': nik,
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      // Log.d('Response: $body');
      final data = body as List;
      return data.map((e) => Sjtm.fromJson(e)).toList();
    }
    return [];
  } catch (e) {
    Log.d('Error: $e');
    return [];
  }
}

Future<String?> deleteTidakMasuk(String nomorSjtm) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': HrMethodApi.deleteSuratIjinTidakMasuk,
        'nomor_sjtm': nomorSjtm,
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