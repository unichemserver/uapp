import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/api/api_client.dart';
import 'package:uapp/modules/marketing/model/cust_active.dart';
import 'package:uapp/modules/marketing/visitasi/custactive/custactive_model.dart';

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
    box.clear();
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
      if (await _loadLocalDataIfAvailable(box)) return;

      var data = await _fetchCustActive();
      if (data.isNotEmpty) {
        custActive = data.map((e) => CustactiveModel.fromJson(e)).toList();
        custActiveFiltered = custActive;
        await _storeCustActiveToLocal(box, custActive);
        update();
      }

    } finally {
      setLoading(false);
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
    final bodyRequest = {'salesrepid': Utils.getUserData().salesrepid};

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