import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/api/api_client.dart';
import 'package:uapp/modules/marketing/model/cust_active.dart';
import 'package:uapp/modules/marketing/visitasi/custactive/custactive_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustactiveController extends GetxController {
  List<CustactiveModel> custActive = [];
  List<CustactiveModel> custActiveFiltered = [];
  late MarketingApiClient apiClient = MarketingApiClient();
  CustactiveModel? selectedCustId;
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    getCustActive(); 
  }

  Future<void> updateCustomerActive() async {
    final box = await Hive.openBox<CustActive>(HiveKeys.custActiveBox);
    await box.clear();
    var data = await _fetchCustActive();
    if (data.isNotEmpty) {
      custActive = data.map((e) => CustactiveModel.fromJson(e)).toList();
      custActiveFiltered = custActive;
      await _storeCustActiveToLocal(box, custActive);
      update();
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  void setSelectedCustId(CustactiveModel? id) {
    selectedCustId = id;
    update();
  }

  void searchCust(String value) {
    var search = value.toLowerCase();
    final searchResult = custActive.where((element) => (element.name!.toLowerCase()).contains(search)).toList();
    custActiveFiltered = searchResult;
    update();
  }

  void clearSearch() {
    custActiveFiltered = custActive;
    update();
  }

  void getCustActive() async {
    try {
      setLoading(true);

      final box = await Hive.openBox<CustActive>(HiveKeys.custActiveBox);
      Log.d('Box cust active: ${box.length}');
      // if (await _loadLocalDataIfAvailable(box)) return;

      var data = await _fetchCustActive();
      if (data.isNotEmpty) {
        custActive = data.map((e) => CustactiveModel.fromJson(e)).toList();
        custActiveFiltered = custActive;
        await _storeCustActiveToLocal(box, custActive);
      }

      var addData = await _fetchAddDataFromAPI();
      if (addData.isNotEmpty) {
        final addCustActive = addData.map((e) => CustactiveModel.fromJson(e)).toList();
        custActive.addAll(addCustActive);
        custActiveFiltered = custActive;
        await _storeCustActiveToLocal(box, addCustActive);
      }
      update();
    } finally {
      setLoading(false);
    }
  }

  Future<List<dynamic>> _fetchAddDataFromAPI() async {
    try {
      final baseUrl = Uri.parse('https://unichem.co.id/api/');
      final bodyRequest = {
        'action': 'noo',
        'method': 'get_data_approved',
      };
      final response = await http.post(
        baseUrl,
        body: bodyRequest,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'Data Found') {
          return data['data'].map((item) {
            // Combine address fields into a single string
            final combinedAddress = [
              item['address'] ?? '',
              item['rt_rw'] ?? '',
              item['desa_kelurahan'] ?? '',
              item['kecamatan'] ?? '',
              item['kabupaten_kota'] ?? '',
              item['provinsi'] ?? '',
              item['kode_pos'] ?? ''
            ].where((field) => field.isNotEmpty).join(', ');
            return {
              'CustID': item['id'] ?? '',
              'CustName': item['nama_perusahaan'] ?? '',
              'Address': combinedAddress,
            };
          }).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      // Log.d('Error fetching user approval data: $e');
      return [];
    }
  }

  Future<bool> _loadLocalDataIfAvailable(Box<CustActive> box) async {
    if (checkLocalData(box)) {
      custActive = box.values.map((e) => CustactiveModel.fromJson(e.toJson())).toList();
      custActiveFiltered = custActive;
      update();
      return true;
    }
    return false;
  }

  Future<List<dynamic>> _fetchCustActive() async {
    final bodyRequest = {'collectorid': Utils.getUserData().colectorid};

    final response = await apiClient.postRequest(
      method: 'get_cust_active',
      additionalData: bodyRequest,
    );

    if (response.success) {
      return response.data;
    } else {
      return [];
    }
  }

  Future<void> _storeCustActiveToLocal(Box<CustActive> box, List<CustactiveModel> custActiveList) async {
    for (var element in custActiveList) {
      await box.add(CustActive(
        custID: element.id,
        custName: element.name,
        address: element.address,
      ));
    }
  }

  bool checkLocalData(Box<CustActive> box) {
    return box.isNotEmpty;
  }
}