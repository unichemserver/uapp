import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/api/api_client.dart';
import 'package:uapp/modules/marketing/model/call_management.dart';
import 'package:uapp/modules/marketing/visitasi/callmanagement/callmanagement_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CallManagementController extends GetxController {
  List<CallManagementModel> callManagement = [];
  List<CallManagementModel> callManagementFiltered = [];
  late MarketingApiClient apiClient = MarketingApiClient();
  CallManagementModel? selectedCustId;
  bool isLoading = true;

  // Track which data type is loaded
  bool isCallDataLoaded = false;
  bool isCanvasingDataLoaded = false;

  @override
  void onInit() {
    super.onInit();
    // initData();
  }

Future<void> updateCustomerActive() async {
  setLoading(true);
  try {
    final box = await Hive.openBox<CallManagement>(HiveKeys.callBox);
    await box.clear();
    var data = await _fetchCustActive();
    if (data.isNotEmpty) {
      callManagement = data.map((e) => CallManagementModel.fromJson(e)).toList();
      callManagementFiltered = callManagement;
      await _storeCustActiveToLocal(box, callManagement);
    }
  } finally {
    setLoading(false); // <- Tambahkan ini agar loading berhenti
  }
}


  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  void setSelectedCustId(CallManagementModel? id) {
    selectedCustId = id;
    update();
  }

  void searchCust(String value) {
    var search = value.toLowerCase();
    final searchResult = callManagement.where((element) => (element.name!.toLowerCase()).contains(search)).toList();
    callManagementFiltered = searchResult;
    update();
  }

  void clearSearch() {
    callManagementFiltered = callManagement;
    update();
  }

  // Clear existing data before fetching new data
  void _clearExistingData() {
    callManagement.clear();
    callManagementFiltered.clear();
    update();
  }

  Future<void> initData({bool loadCanvasing = false}) async {
  setLoading(true);
  final box = await Hive.openBox<CallManagement>(HiveKeys.callBox);
  bool loaded = await _loadLocalDataIfAvailable(box);

  if (!loaded) {
    if (loadCanvasing) {
       getCanvasing();
    } else {
       getCall();
    }
  } else {
    isCallDataLoaded = !loadCanvasing;
    isCanvasingDataLoaded = loadCanvasing;
  }

  setLoading(false);
}

  void getCall() async {
    // Skip if already loaded to prevent duplicate calls
    if (isCallDataLoaded) return;
    
    try {
      setLoading(true);
      // _clearExistingData();

      final box = await Hive.openBox<CallManagement>(HiveKeys.callBox);
      Log.d('Box cust active: ${box.length}');

      var addData = await _fetchAddDataFromAPI();
      if (addData.isNotEmpty) {
        final addCallManagement = addData.map((e) => CallManagementModel.fromJson(e)).toList();
        callManagement.addAll(addCallManagement);
        callManagementFiltered = callManagement;
        await _storeCustActiveToLocal(box, addCallManagement);
      }
      
      isCallDataLoaded = true;
      isCanvasingDataLoaded = false;
      update();
    } finally {
      setLoading(false);
    }
  }

  void getCanvasing() async {
    // Skip if already loaded to prevent duplicate calls
    if (isCanvasingDataLoaded) return;
    
    try {
      setLoading(true);
      // _clearExistingData();

      final box = await Hive.openBox<CallManagement>(HiveKeys.callBox);
      Log.d('Box cust active canvasing: ${box.length}');

      var addData = await _fetchDataFromAPI();
      if (addData.isNotEmpty) {
        final addCallManagement = addData.map((e) => CallManagementModel.fromJson(e)).toList();
        callManagement.addAll(addCallManagement);
        callManagementFiltered = callManagement;
        await _storeCustActiveToLocal(box, addCallManagement);
      }
      
      isCallDataLoaded = false;
      isCanvasingDataLoaded = true;
      update();
    } finally {
      setLoading(false);
    }
  }

  Future<List<dynamic>> _fetchAddDataFromAPI() async {
    try {
      final baseUrl = Uri.parse('https://unichem.co.id/api/');
      final userid = Utils.getUserData().id;
      final bodyRequest = {
        'action': 'noo',
        'method': 'get_data_approvedtop',
        'nik': userid,
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

  Future<List<dynamic>> _fetchDataFromAPI() async {
    try {
      final baseUrl = Uri.parse('https://unichem.co.id/api/');
      final userid = Utils.getUserData().id;
      final bodyRequest = {
        'action': 'noo',
        'method': 'get_data_approved',
        'nik': userid,
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

  Future<bool> _loadLocalDataIfAvailable(Box<CallManagement> box) async {
    if (checkLocalData(box)) {
      callManagement = box.values.map((e) => CallManagementModel.fromJson(e.toJson())).toList();
      callManagementFiltered = callManagement;
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

  Future<void> _storeCustActiveToLocal(Box<CallManagement> box, List<CallManagementModel> custActiveList) async {
      Log.d('Storing customer active data to local storage');

    // for (var element in custActiveList) {
    //   await box.add(CallManagement(
    //     custID: element.id,
    //     custName: element.name,
    //     address: element.address,
    //   ));
    // }
  }

  bool checkLocalData(Box<CallManagement> box) {
    return box.isNotEmpty;
  }
}