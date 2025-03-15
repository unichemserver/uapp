import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/models/user.dart';

class MarketingApiService {
  late String baseUrl;
  late Box box;

  MarketingApiService() {
    box = Hive.box(HiveKeys.appBox);
    baseUrl = box.get(HiveKeys.baseURL);
  }

  Future<dynamic> getIDMarketingActivity(
    String? ruteId,
    String? customerId,
  ) async {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    try {
      final body = {
        'action': 'sync',
        'method': 'getactivityid',
        'rute_id': ruteId ?? '',
        'cust_id': customerId ?? '',
        'user_id': userData.id.toString(),
        'jenis': Call.onroute,
      };
      final response = await http.post(
        Uri.parse(baseUrl),
        body: body,
      );
      print('getIDMarketingActivity: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        return null;
      }
    } catch (e) {
      Log.d('Error getIDMarketingActivity: $e');
      return null;
    }
  }

  Future<List<dynamic>> getTodayActivity(String userId) async {
    try {
      final body = {
        'action': 'sync',
        'method': 'gettodayactivity',
        'user_id': userId,
      };
      final response = await http.post(
        Uri.parse(baseUrl),
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        return [];
      }
    } catch (e) {
      Log.d('Error getTodayActivity: $e');
      return [];
    }
  }

  Future<List<dynamic>> getMasterGroup() async {
    try {
      final body = {
        'action': 'sync',
        'method': 'mastergroup',
      };
      final response = await http.post(
        Uri.parse(baseUrl),
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        return [];
      }
    } catch (e) {
      Log.d('Error getMasterGroup: $e');
      return [];
    }
  }

  Future<dynamic> checkApprovalStatus(String idnoo) async {
    try {
      final body = {
        'action': 'marketing',
        'method': 'approve_noo',
        'idnoo': idnoo,
      };
      final response = await http.post(
        Uri.parse(baseUrl),
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        return null;
      }
    } catch (e) {
      Log.d('Error checkApprovalStatus: $e');
      return null;
    }
  }

  Future<dynamic> getUserApproval(String idnoo) async {
    try {
      final body = {
        'action': 'noo',
        'method': 'get_user_approval',
        'idnoo': idnoo,
      };
      final response = await http.post(
        Uri.parse(baseUrl),
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        return null;
      }
    } catch (e) {
      Log.d('Error getUserApproval: $e');
      return null;
    }
  }
}
