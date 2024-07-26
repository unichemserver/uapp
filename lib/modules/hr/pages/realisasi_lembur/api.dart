import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/pages/realisasi_lembur/api_params.dart';
import 'package:uapp/modules/hr/pages/realisasi_lembur/nomor_rencan_lembur.dart';

Future<String?> addRealisasiLembur(ApiParams params) async {
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
  } on Exception catch (e) {
    return e.toString();
  }
}

Future<List<NomorRencanLembur>> getNomorRC() async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': 'getnomorrc',
        'nik': userData.id,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)
          .map<NomorRencanLembur>(
            (item) => NomorRencanLembur.fromJson(item),
          )
          .toList();
    }
    return [];
  } on Exception catch (_) {
    return [];
  }
}
