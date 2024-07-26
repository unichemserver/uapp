import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/pages/realisasi_permintaan_naker/api_params.dart';
import 'package:uapp/modules/hr/pages/realisasi_permintaan_naker/nomor_ptk.dart';

Future<List<NomorPtk>> getNomorPtk(bool isBorongan) async {
  List<NomorPtk> nomorPtk = [];
  try {
    final box = Hive.box(HiveKeys.appBox);
    final userData = User.fromJson(json.decode(box.get(HiveKeys.userData)));
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': isBorongan ? 'getnomorptk' : 'getnomorptkb',
        'id_user': userData.id,
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      nomorPtk = data.map((e) => NomorPtk.fromJson(e)).toList();
    }
  } catch (e) {
    Log.d('Error getNomorPtk: $e');
  }
  return nomorPtk;
}

Future<String?> addRealisasiNaker(ApiParams params) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: params.toMap(),
    );
    if (response.statusCode == 200) {
      return null;
    }
    var data = json.decode(response.body);
    return data['message'];
  } catch (e) {
    Log.d('Error addRealisasiNaker: $e');
    return 'Terjadi kesalahan';
  }
}