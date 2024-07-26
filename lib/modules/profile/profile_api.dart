import 'dart:convert';
import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/models/profile.dart';

class ProfileApi {
  static Future<bool> logout() async {
    final box = Hive.box(HiveKeys.appBox);
    try {
      var userData = Utils.getUserData();
      final response = await http.post(
        Uri.parse(box.get(HiveKeys.baseURL)),
        body: {
          'action': 'logout',
          'mobile_token': userData.token,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Profile?> getProfile() async {
    final box = Hive.box(HiveKeys.appBox);
    var userData = Utils.getUserData();
    try {
      final response = await http.post(
        Uri.parse(box.get(HiveKeys.baseURL)),
        body: {
          'action': 'profile',
          'user_id': userData.id,
        },
      );
      if (response.statusCode == 200) {
        return Profile.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<http.Response?> downloadProfilePicture(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
