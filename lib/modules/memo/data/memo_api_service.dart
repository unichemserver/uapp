import 'dart:convert';

import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/memo/data/memo.dart';
import 'package:http/http.dart' as http;
import 'package:uapp/modules/memo/data/model/cust_sybase.dart';
import 'package:uapp/modules/memo/data/model/custprod.dart';
import 'package:uapp/modules/memo/data/model/history_memo.dart';
import 'package:uapp/modules/memo/data/model/memo_target.dart';
import 'package:uapp/modules/memo/data/model/pajak_penghasilan.dart';

Future<String?> saveMemo<T extends Memo>(T memo, String url) async {
  try {
    final response = await http.post(
      Uri.parse(url),
      body: memo.toJson(),
    );

    if (response.statusCode == 200) {
      return null;
    } else {
      return 'Failed to save memo regular';
    }
  } catch (e) {
    return e.toString();
  }
}

Future<HistoryMemo?> getMemo(String url) async {
  const String method = 'getmemo';
  final result = await getDataMemo(url, method);
  return result;
}

Future<HistoryMemo?> getApprMemo(String url) async {
  const String method = 'getapprovalmemo';
  final result = await getDataMemo(url, method);
  return result;
}

Future<HistoryMemo?> getReceivedMemo(String url) async {
  const String method = 'getreceivedmemo';
  final result = await getDataMemo(url, method);
  return result;
}

Future<List<MemoTarget>> getTargetMemo() async {
  try {
    final response = await http.post(
      Uri.parse(Utils.getBaseUrl()),
      body: {
        'action': 'gettargetmemo',
        'user_id': Utils.getUserData().id.toString(),
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<MemoTarget> result = [];
      for (var item in data) {
        result.add(MemoTarget.fromJson(item));
      }
      return result;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

Future<List<CustSybase>> getCustomer() async {
  try {
    String baseUrl = Utils.getSybaseUrl();
    baseUrl += '/customer';
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<CustSybase> result = [];
      for (var item in data) {
        result.add(CustSybase.fromJson(item));
      }
      return result;
    } else {
      return [];
    }
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List<PajakPenghasilan>> getPajaPenghasilan(String url) async {
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {'action': 'getpajakpenghasilan'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<PajakPenghasilan> result = [];
      for (var item in data) {
        result.add(PajakPenghasilan.fromJson(item));
      }
      return result;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

Future<HistoryMemo?> getDataMemo(String url, String method) async {
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {
        'action': method,
        'user_id': Utils.getUserData().id.toString(),
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var result = HistoryMemo.fromJson(data);
      return result;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<Custprod?> getCustprod(String url) async {
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {'action': 'custprod'},
    );

    if (response.statusCode == 200) {
      return Custprod.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<String?> updateMemo(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return null;
    } else {
      return 'Failed to update memo';
    }
  } catch (e) {
    return e.toString();
  }
}
