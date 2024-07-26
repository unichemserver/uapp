import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uapp/models/user.dart';

class AuthApi {
  static Future<User?> login(
    String url,
    String username,
    String password,
  ) async {
    try {
      final bodyRequest = {
        'action': 'login',
        'username': username,
        'password': password,
      };
      final response = await http.post(
        Uri.parse(url),
        body: bodyRequest,
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final bodyResponse = json.decode(response.body);
        return User.fromJson(bodyResponse['user']);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
