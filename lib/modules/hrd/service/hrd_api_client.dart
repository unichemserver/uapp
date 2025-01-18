import 'dart:convert';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/modules/marketing/api/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class HrdApiClient {
  final String action = 'hrd';
  late String baseUrl;

  MarketingApiClient() {
    baseUrl = Hive.box(HiveKeys.appBox).get(HiveKeys.baseURL);
  }

  Future<ApiResponse> postRequest({
    required String method,
    Map<String, dynamic>? additionalData,
  }) async {
    final Map<String, dynamic> body = {
      'action': action,
      'method': method,
    };

    if (additionalData != null) {
      additionalData.forEach((key, value) {
        body[key] = value.toString();
      });
    }
    final Uri url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      body: body,
    );

    if (response.statusCode == 200) {
      final bodyResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(bodyResponse);
    } else {
      return ApiResponse(message: 'Failed to load data');
    }
  }

  Future<ApiResponse> postFileRequest({
    required String method,
    required Map<String, dynamic> additionalData,
    required List<String> fileKeys,
  }) async {
    final Uri url = Uri.parse(baseUrl);
    var request = http.MultipartRequest('POST', url);

    request.fields['action'] = action;
    request.fields['method'] = method;

    additionalData.forEach((key, value) {
      if (fileKeys.contains(key) && value != null) {
        var file = File(value);
        var stream = http.ByteStream(file.openRead());
        var length = file.lengthSync();
        request.files.add(http.MultipartFile(
          key,
          stream,
          length,
          filename: basename(file.path),
          contentType: MediaType('image', basename(file.path).endsWith('.png') ? 'png' : 'jpeg'),
        ));
      } else {
        request.fields[key] = value.toString();
      }
    });

    var response = await request.send();
    if (response.statusCode == 200) {
      final bodyResponse = await response.stream.bytesToString();
      return ApiResponse.fromJson(jsonDecode(bodyResponse));
    } else {
      return ApiResponse(message: 'Failed to load data');
    }
  }
}