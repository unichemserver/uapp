import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/hr/hr_method_api.dart';
import 'package:uapp/modules/hr/model/skm.dart';
import 'package:uapp/modules/hr/pages/keluar_mobil/api_param.dart';
import 'package:uapp/modules/hr/pages/keluar_mobil/mobil.dart';

Future<List<Mobil>> getAvailableCars() async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': 'mobil_tersedia',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final List<Mobil> cars = [];
      for (final car in responseBody) {
        cars.add(Mobil.fromJson(car));
      }
      return cars;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

Future<String?> addKeluarMobil(ApiParams params) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'action': 'hr',
        'method': params.method,
        'nik': params.nik,
        'nopol': params.idMobil,
        'tujuan': params.tujuan,
        'keperluan': params.keperluan,
        'tgl_awal': params.tglAwal,
        'tgl_akhir': params.tglAkhir,
        'jam_keluar': params.jamKeluar,
        'km_keluar': params.kmKeluar,
        'jam_kembali': params.jamKembali,
        'km_kembali': params.kmKembali,
        'pengikut': params.pengikut,
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return null;
    } else {
      final responseBody = jsonDecode(response.body);
      return responseBody['message'];
    }
  } catch (e) {
    print(e);
    return 'Terjadi kesalahan saat mengirim data. Silahkan coba lagi.';
  }
}

Future<List<Skm>> getKeluarMobil() async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final nik = User.fromJson(jsonDecode(box.get(HiveKeys.userData))).id;
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': 'getskm',
        'nik': nik,
      },
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final List<Skm> skmList = [];
      for (final skm in responseBody) {
        skmList.add(Skm.fromJson(skm));
      }
      return skmList;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

Future<String?> deleteKeluarMobil(String nomorSkm) async {
  try {
    final box = Hive.box(HiveKeys.appBox);
    final baseUrl = box.get(HiveKeys.baseURL);
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'action': 'hr',
        'method': HrMethodApi.deleteSuratKeluarMobil,
        'nomor_skm': nomorSkm,
      },
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['message'];
    } else {
      return 'Terjadi kesalahan saat menghapus data. Silahkan coba lagi.';
    }
  } catch (e) {
    return 'Terjadi kesalahan saat menghapus data. Silahkan coba lagi.';
  }
}
