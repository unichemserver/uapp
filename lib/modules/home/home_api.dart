import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/models/user.dart';

import '../../core/hive/hive_keys.dart';

class HomeApi {
  static Future<bool> logout(String url, String token) async {
    try {
      final baseUrl = Uri.parse(url);
      final bodyRequest = {
        'action': 'logout',
        'token': token,
      };
      final response = await http.post(
        baseUrl,
        body: bodyRequest,
      );
      print('Logout response: ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error logout: $e');
      return false;
    }
  }

  static Future<bool> changePassword(String password) async {
    final box = Hive.box(HiveKeys.appBox);
    final user = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final baseUrl = Uri.parse(box.get(HiveKeys.baseURL));
    final bodyRequest = {
      'action': 'changepassword',
      'user_id': user.id,
      'password': password,
    };
    try {
      final response = await http.post(
        baseUrl,
        body: bodyRequest,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getListMenu(
    String url,
    String department,
    String bagian,
    String role,
  ) async {
    try {
      final baseUrl = Uri.parse(url);
      final bodyRequest = {
        'action': 'menu',
        'department': department,
        'bagian': bagian,
        'role': role,
      };
      final response = await http.post(
        baseUrl,
        body: bodyRequest,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> uploadReport(
      String idMa,
      Map<String, dynamic> dataActivity,
      List<Map<String, dynamic>> stockItems,
      List<Map<String, dynamic>> competitorItems,
      List<Map<String, dynamic>> collectionItems,
      List<Map<String, dynamic>> imageItems,
      List<Map<String, dynamic>> toItems,
      String baseUrl,
      ) async {
    try {
      print('Uploading report...');
      if (dataActivity['jenis'] != Call.onroute) {
        var idma = await getIDMarketingActivity(
          dataActivity['rute_id'].toString(),
          dataActivity['cust_id'].toString(),
        );
        idMa = idma.toString();
      }
      await uploadMarketingActivity(idMa, dataActivity, baseUrl);

      for (var stock in stockItems) {
        print('Uploading stock report...');
        print(stock);
        await uploadStockReport(idMa, stock, baseUrl);
      }
      for (var competitor in competitorItems) {
        print('Uploading competitor report...');
        print(competitor);
        await uploadCompetitorReport(idMa, competitor, baseUrl);
      }
      for (var collection in collectionItems) {
        print('Uploading collection report...');
        print(collection);
        await uploadCollectionReport(idMa, collection, baseUrl);
      }
      for (var image in imageItems) {
        print('Uploading image report...');
        print(image);
        await uploadImageReport(idMa, image, baseUrl);
      }
      for (var to in toItems) {
        print('Uploading to report...');
        print(to);
        await uploadToReport(idMa, to, baseUrl);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Uint8List> compressImage(File file) async {
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Could not decode image');
    }
    final compressedBytes = img.encodeJpg(image, quality: 70);
    return Uint8List.fromList(compressedBytes);
  }

  Future<int> uploadMarketingActivity(String idMa, Map<String, dynamic> dataActivity, String baseUrl) async {
    try {
      final body = {
        'action': 'sync',
        'method': 'upload',
        'table': 'activity',
        'id': idMa,
        'user_id': dataActivity['user_id']?.toString() ?? '',
        'cust_id': dataActivity['cust_id']?.toString() ?? '',
        'rute_id': dataActivity['rute_id']?.toString() ?? '',
        'lat_ci': dataActivity['lat_ci']?.toString() ?? '',
        'lon_ci': dataActivity['lon_ci']?.toString() ?? '',
        'lat_co': dataActivity['lat_co']?.toString() ?? '',
        'lon_co': dataActivity['lon_co']?.toString() ?? '',
        'waktu_ci': dataActivity['waktu_ci']?.toString() ?? '',
        'waktu_co': dataActivity['waktu_co']?.toString() ?? '',
        'status_call': dataActivity['status_call']?.toString() ?? '',
        'jenis': dataActivity['jenis']?.toString() ?? '',
      };

      final ttd = File(dataActivity['ttd']);
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.fields.addAll(body);

      if (dataActivity['jenis'] != Call.canvasing) {
        final fotoCi = File(dataActivity['foto_ci']);
        final compressedFotoCi = await compressImage(fotoCi);
        request.files.add(http.MultipartFile.fromBytes(
          'foto_ci',
          compressedFotoCi,
          filename: fotoCi.path.split('/').last,
        ));
      }

      request.files.add(await http.MultipartFile.fromPath(
        'ttd',
        ttd.path,
        filename: ttd.path.split('/').last,
      ));

      var response = await request.send();
      print('Upload marketing activity response: ${response.statusCode}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(await response.stream.bytesToString());
        return int.parse(jsonData['data']);
      } else {
        return 0;
      }
    } catch (e) {
      print('Exception: $e');
      return 0;
    }
  }

  Future<void> uploadStockReport(
      String idMA,
      Map<String, dynamic> stockItems,
      String baseUrl,
      ) async {
    try {
      final body = {
        'action': 'sync',
        'method': 'upload',
        'table': 'stock',
        'idMA': idMA,
        'item_id': stockItems['item_id'].toString(),
        'name': stockItems['name'].toString(),
        'quantity': stockItems['quantity'].toString(),
        'unit': stockItems['unit'].toString(),
      };
      final foto = File(stockItems['image_path']);
      final compressedFoto = await compressImage(foto);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(baseUrl),
      );
      request.fields.addAll(body);
      var photoMultipartFile = http.MultipartFile.fromBytes(
        'image',
        compressedFoto,
        filename: 'image.jpg',
      );
      request.files.add(photoMultipartFile);
      var response = await request.send();
      print('Upload stock report response: ${response.statusCode}');
      print('Upload stock report response: ${response.reasonPhrase}');
      print(
          'Upload stock report response: ${await response.stream.bytesToString()}');
      if (response.statusCode == 200) {
        debugPrint('Upload stock report success');
      } else {
        debugPrint('Upload stock report failed');
      }
    } catch (e) {
      print('Exception Stock: $e');
      debugPrint(e.toString());
    }
  }

  Future<int> uploadNooReport(
      Map<String, dynamic> nooItems,
      String baseUrl
      ) async {
    try {
      var body = {
        'action': 'sync',
        'method': 'upload',
        'table': 'noo',
        'group_pelanggan': nooItems['group_pelanggan'].toString(),
        'metode_pembayaran': nooItems['metode_pembayaran'].toString(),
        'termin': nooItems['termin'].toString(),
        'jaminan': nooItems['jaminan'].toString(),
        'nama_perusahaan': nooItems['nama_perusahaan'].toString(),
        'area_pemasaran': nooItems['area_pemasaran'].toString(),
        'nama_owner': nooItems['nama_owner'].toString(),
        'no_ktp': nooItems['no_ktp'].toString(),
        'umur': nooItems['umur'].toString(),
        'jekel': nooItems['jekel'].toString(),
        'no_telepon': nooItems['no_telepon'].toString(),
        'email': nooItems['email'].toString(),
        'address': nooItems['address'].toString(),
        'desa': nooItems['desa'].toString(),
        'kec': nooItems['kec'].toString(),
        'kab': nooItems['kab'].toString(),
        'prov': nooItems['prov'].toString(),
        'kode_pos': nooItems['kode_pos'].toString(),
      };
      final response = await http.post(
        Uri.parse(baseUrl),
        body: body,
      );
      print('Upload noo report response: ${response.statusCode}');
      print('Upload noo report response: ${response.reasonPhrase}');
      print('Upload noo report response: ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return int.parse(jsonData['data']);
      } else {
        print('Upload noo report failed');
        return 0;
      }
    } catch (e) {
      print('Exception Noo: $e');
      return 0;
    }
  }

  Future<int> uploadCanvasingReport(
      Map<String, dynamic> canvasingItems,
      String baseUrl
      ) async {
    try {
      var body = {
        'action': 'sync',
        'method': 'upload',
        'table': 'canvasing',
        'CustID': canvasingItems['CustID'].toString(),
        'nama_outlet': canvasingItems['nama_outlet'].toString(),
        'nama_owner': canvasingItems['nama_owner'].toString(),
        'no_hp': canvasingItems['no_hp'].toString(),
        'alamat': canvasingItems['alamat'].toString(),
        'latitude': canvasingItems['latitude'].toString(),
        'longitude': canvasingItems['longitude'].toString(),
      };
      final image = File(canvasingItems['image_path']);
      final compressedImage = await compressImage(image);
      print('Compressed image length: ${compressedImage.length}');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(baseUrl),
      );
      request.fields.addAll(body);
      var imageMultipartFile = http.MultipartFile.fromBytes(
        'image_path',
        compressedImage,
        filename: 'image.jpg',
      );
      request.files.add(imageMultipartFile);
      var response = await request.send();
      print('Upload canvasing report response: ${response.statusCode}');
      print('Upload canvasing report response: ${response.reasonPhrase}');
      if (response.statusCode == 200) {
        var bodyResponse = await response.stream.bytesToString();
        print('Upload canvasing report response: $bodyResponse');
        final jsonData = json.decode(bodyResponse);
        return int.parse(jsonData['data']);
      } else {
        print('Upload canvasing report failed');
        return 0;
      }
    } catch (e) {
      print('Exception Canvasing: $e');
      return 0;
    }
  }

  Future<void> uploadCompetitorReport(
      String idMA,
      Map<String, dynamic> competitorItems,
      String baseUrl
      ) async {
    try {
      final body = {
        'action': 'sync',
        'method': 'upload',
        'table': 'competitor',
        'idMA': idMA,
        'name': competitorItems['name'].toString(),
        'price': competitorItems['price'].toString(),
        'program': competitorItems['program'].toString(),
        'support': competitorItems['support'].toString(),
      };
      final response = await http.post(
        Uri.parse(baseUrl),
        body: body,
      );
      print('Upload competitor report response: ${response.statusCode}');
      print('Upload competitor report response: ${response.reasonPhrase}');
      print('Upload competitor report response: ${response.body}');
      if (response.statusCode == 200) {
        debugPrint('Upload competitor report success');
      } else {
        debugPrint('Upload competitor report failed');
      }
    } catch (e) {
      print('Exception Competitor: $e');
      debugPrint(e.toString());
    }
  }

  Future<void> uploadImageReport(
      String idMA,
      Map<String, dynamic> imageItems,
      String baseUrl
      ) async {
    try {
      final body = {
        'action': 'sync',
        'method': 'upload',
        'table': 'image',
        'idMA': idMA,
        'type': imageItems['type'].toString(),
      };
      final foto = File(imageItems['image']);
      final compressedFoto = await compressImage(foto);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(baseUrl),
      );
      request.fields.addAll(body);
      var photoMultipartFile = http.MultipartFile.fromBytes(
        'image',
        compressedFoto,
        filename: 'image.jpg',
      );
      request.files.add(photoMultipartFile);
      var response = await request.send();
      print('Upload image report response: ${response.statusCode}');
      print('Upload image report response: ${response.reasonPhrase}');
      print(
          'Upload image report response: ${await response.stream.bytesToString()}');
      if (response.statusCode == 200) {
        debugPrint('Upload image report success');
      } else {
        debugPrint('Upload image report failed');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> uploadCollectionReport(
      String idMA,
      Map<String, dynamic> collectionItems,
      String baseUrl
      ) async {
    try {
      final body = {
        'action': 'sync',
        'method': 'upload',
        'table': 'collection',
        'idMA': idMA,
        'noinvoice': collectionItems['noinvoice'].toString(),
        'nocollect': collectionItems['nocollect'].toString(),
        'amount': collectionItems['amount'].toString(),
        'type': collectionItems['type'].toString(),
        'status': collectionItems['status'].toString(),
      };
      final response = await http.post(
        Uri.parse(baseUrl),
        body: body,
      );
      print('Upload collection report response: ${response.statusCode}');
      print('Upload collection report response: ${response.reasonPhrase}');
      print('Upload collection report response: ${response.body}');
      if (response.statusCode == 200) {
        debugPrint('Upload collection report success');
      } else {
        debugPrint('Upload collection report failed');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> uploadToReport(
      String idMA,
      Map<String, dynamic> toItems,
      String baseUrl
      ) async {
    try {
      final body = {
        'action': 'sync',
        'method': 'upload',
        'table': 'to',
        'idMA': idMA,
        'itemid': toItems['itemid'].toString(),
        'description': toItems['description'].toString(),
        'quantity': toItems['quantity'].toString(),
        'unit': toItems['unit'].toString(),
        'price': toItems['price'].toString(),
      };
      final response = await http.post(
        Uri.parse(baseUrl),
        body: body,
      );
      print('Upload to report response: ${response.statusCode}');
      print('Upload to report response: ${response.reasonPhrase}');
      print('Upload to report response: ${response.body}');
      if (response.statusCode == 200) {
        debugPrint('Upload to report success');
      } else {
        debugPrint('Upload to report failed');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> getIDMarketingActivity(
      String? ruteId,
      String? customerId,
      ) async {
    final box = Hive.box(HiveKeys.appBox);
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    try {
      final body = {
        'action': 'sync',
        'method': 'getactivityid',
        'rute_id': ruteId,
        'cust_id': customerId ?? '',
        'user_id': userData.id.toString(),
      };
      final response = await http.post(
        Uri.parse(box.get(HiveKeys.baseURL)),
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
}
