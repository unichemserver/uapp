import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/firebase/crashlytics_service.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/utils.dart';

class SyncApiService {
  // Method untuk melakukan fetch dengan parameter tambahan
  Future<List<dynamic>> _fetchData(String method,
      {String? salesrepid, String? nik}) async {
    final response = await requestApi(method, salesrepid: salesrepid, nik: nik);
    return response;
  }

  Future<List<dynamic>> fetchRute() async {
    return _fetchData(
      'rute',
      salesrepid: Utils.getUserData().salesrepid,
    );
  }

  Future<List<dynamic>> fetchPriceList() async {
    return _fetchData(
      'price_list',
      nik: Utils.getUserData().id,
    );
  }

  Future<List<dynamic>> fetchItem() async {
    return _fetchData('item');
  }

  Future<List<dynamic>> fetchInvoice() async {
    return _fetchData(
      'invoice',
      salesrepid: Utils.getUserData().salesrepid,
    );
  }

  Future<List<dynamic>> fetchUser() async {
    return _fetchData('user');
  }

  Future<List<dynamic>> fetchCustomer() async {
    return _fetchData(
      'customer',
      salesrepid: Utils.getUserData().salesrepid,
    );
  }

  Future<dynamic> requestApi(String method,
      {String? salesrepid, String? nik}) async {
    try {
      final Box box = Hive.box(HiveKeys.appBox);
      final baseUrl = box.get(HiveKeys.baseURL, defaultValue: '');

      var bodyRequest = {
        'action': 'sync',
        'method': method,
      };

      if (salesrepid != null) {
        bodyRequest['salesrepid'] = salesrepid;
      }
      if (nik != null) {
        bodyRequest['nik'] = nik;
      }

      final response = await http.post(
        Uri.parse(baseUrl!),
        body: bodyRequest,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } on Exception catch (e, s) {
      crashlyticsService.logError(e, s);
    }
  }
}
