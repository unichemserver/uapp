import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/production/data/model/balance.dart';
import 'package:uapp/modules/production/data/model/balance_api_response.dart';
import 'package:uapp/modules/production/data/model/barang.dart';
import 'package:uapp/modules/production/data/model/warehouse.dart';

Future<List<Warehouse>> getWarehouse() async {
  try {
    final response = await http.post(
      Uri.parse(Utils.getBaseUrl()),
      body: {
        'action': 'getwarehouse',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return List<Warehouse>.from(body.map((x) => Warehouse.fromJson(x)));
    } else {
      return <Warehouse>[];
    }
  } catch (e) {
    print('Error: $e');
    return <Warehouse>[];
  }
}

Future<List<BarangBalance>> searchBarang(String search) async {
  try {
    final response = await http.post(
      Uri.parse(Utils.getBaseUrl()),
      body: {
        'action': 'searchproduct',
        'query': search,
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return List<BarangBalance>.from(body.map((x) => BarangBalance.fromJson(x)));
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

Future<int> getTotalBalance(String itemid) async {
  try {
    String edsUrl = Utils.getSybaseUrl();
    edsUrl += 'detailitembalance?item=$itemid&page=1&limit=1';
    print(edsUrl);
    var client = createHttpClient();
    final response = await client.get(
      Uri.parse(edsUrl),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['total'];
    } else {
      return 0;
    }
  } catch (e) {
    print('Error: $e');
    return 0;
  }
}

http.Client createHttpClient() {
  final ioClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  return IOClient(ioClient);
}

Future<BalanceApiResponse?> fetchBalance({
  required String itemid,
  required String page,
  required String limit,
  required String warehouse,
  required String startDate,
  required String endDate,
}) async {
  try {
    print('fetchBalance');
    String edsUrl = Utils.getSybaseUrl();
    // edsUrl += 'detailitembalance?item=$itemid&page=$page&limit=$limit';
    edsUrl += 'detailitembalance?item=$itemid&page=$page&limit=$limit&locationid=$warehouse&startdate=$startDate&enddate=$endDate';
    print(edsUrl);
    var client = createHttpClient();
    final response = await client.get(
      Uri.parse(edsUrl),
    );
    print(response.body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print(result['images']);
      var data = result['data'];
      return BalanceApiResponse(
        total: result['total'].toString(),
        data: List<Balance>.from(data.map((x) => Balance.fromJson(x))),
        images: List<Map<String, String>>.from(result['images'].map((x) => Map<String, String>.from(x))),
      );
    } else {
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
