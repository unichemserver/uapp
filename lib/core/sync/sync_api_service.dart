import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/models/user.dart';

class SyncApiService {

  Future<List<dynamic>> fetchRute() async {
    final Box box = Hive.box(HiveKeys.appBox);
    final userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final salesrepid = userData.salesrepid;
    const String method = 'rute';
    final response = await requestApi(
      method,
      salesrepid: salesrepid,
    );
    return response;
  }

  Future<List<dynamic>> fetchItem() async {
    const String method = 'item';
    final response = await requestApi(method);
    return response;
  }

  Future<List<dynamic>> fetchInvoice() async {
    final Box box = Hive.box(HiveKeys.appBox);
    final userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final salesrepid = userData.salesrepid;
    const String method = 'invoice';
    final response = await requestApi(
      method,
      salesrepid: salesrepid,
    );
    return response;
  }

  Future<List<dynamic>> fetchUser() async {
    const String method = 'user';
    final response = await requestApi(method);
    return response;
  }

  Future<List<dynamic>> fetchCustomer() async {
    final Box box = Hive.box(HiveKeys.appBox);
    final userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final salesrepid = userData.salesrepid;
    const String method = 'customer';
    final response = await requestApi(
      method,
      salesrepid: salesrepid,
    );
    return response;
  }

  Future<dynamic> requestApi(String method, {String? salesrepid}) async {
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
      print('Request: $bodyRequest');
      final response = await http.post(
        Uri.parse(baseUrl!),
        body: bodyRequest,
      );
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
