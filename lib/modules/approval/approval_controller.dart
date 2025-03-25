import 'package:get/get.dart';
import 'package:uapp/core/utils/log.dart';
import 'approval_api.dart';
import 'package:uapp/modules/home/home_api.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:hive/hive.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/models/user.dart';
import 'dart:convert';

class ApprovalController extends GetxController {
  final approvalData = <Map<String, dynamic>>[].obs; // Store approval data
  final isLoading = false.obs; // Loading state
  final db = MarketingDatabase(); // Local database instance
  final approvalDetail = {}.obs; 
  final selectedIdNoo = ''.obs;
  final masternoo = Rxn<Map<String, dynamic>>(); // Store masternoo data
  final documents = <Map<String, dynamic>>[].obs; // Store documents from API

  @override
  void onInit() {
    super.onInit();
    fetchAllApprovalData();
     if (selectedIdNoo.isNotEmpty) {
      fetchApprovalDetail(selectedIdNoo.value);
    } 
    // // Dengarkan stream untuk notifikasi approval
    // ApprovalApi.approvalStream.listen((count) {
    //   sendApprovalNotification(count); // Gunakan fungsi dari notification.dart
    // });
  }

  Future<void> fetchAllApprovalData() async {
    isLoading.value = true; // Set loading state to true
    try {
      final users = await ApprovalApi.getUserApproval(); // Fetch user approvals
      if (users == null || users.isEmpty) {
        throw Exception('No user approvals found');
      }

      final box = Hive.box(HiveKeys.appBox);
      final user = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));

      if (users.contains(user.id)) {
        final allData = <Map<String, dynamic>>[];

        final userApprovals = await ApprovalApi.getApprovalData(user.id);
        Log.d('User approvals: $userApprovals');

        // Fetch idNoo from HomeApi
        final apiNooData = await HomeApi.getDataNoo();
        Log.d('API noo data: $apiNooData');
        if (userApprovals != null && apiNooData != null) {
          for (var idNoo in userApprovals) {
            final matchingNoo = apiNooData.firstWhere(
              (noo) => noo['id'] == idNoo,
              orElse: () => <String, dynamic>{}, // Return an empty map if no match is found
            );
            if (matchingNoo.isNotEmpty) {
              allData.add({
                'idNoo': idNoo,
                'userId': user.id,
                'groupPelanggan': matchingNoo['group_cust'] ?? 'Unknown',
                'nama_outlet': matchingNoo['nama_perusahaan'] ?? 'Unknown',
                'date': matchingNoo['tgl_join'] ?? DateTime.now().toString(), // Use current date if not available
              });
            } else {
              Log.d('idNoo $idNoo not found in API data');
            }
          }
        }

        approvalData.assignAll(allData.reversed.toList()); // Reverse the order of the API response
      } else {
        Get.snackbar('Access Denied', 'Kamu tidak punya akses approval'); // Display no access message
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch approval data: $e'); // Handle errors
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }

  void setIdNoo(String idNoo) {
    selectedIdNoo.value = idNoo;
    fetchApprovalDetail(idNoo);
  }

  // Fetch approval details based on idNoo
  Future<void> fetchApprovalDetail(String idNoo) async {
    isLoading.value = true; // Set loading state to true
    try {
      // Fetch data from masternoo
      final masternooData = await db.query(
        'masternoo',
        where: 'id = ?',
        whereArgs: [idNoo],
      );

      // Fetch data from nooaddress
      final addressData = await db.query(
        'nooaddress',
        where: 'id = ?',
        whereArgs: [idNoo],
      );

      // Fetch data from noodocument
      final documentData = await db.query(
        'noodocument',
        where: 'id_noo = ?',
        whereArgs: [idNoo],
      );

      // Fetch data from noospesimen
      final spesimenData = await db.query(
        'noospesimen',
        where: 'id = ?',
        whereArgs: [idNoo],
      );

      // Combine all data into a single map
      approvalDetail.value = {
        'masternoo': masternooData.isNotEmpty ? masternooData.first : null,
        'address': addressData,
        'documents': documentData,
        'spesimen': spesimenData,
      };
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch approval details: $e'); // Handle errors
    } finally {
      isLoading.value = false; // Set loading state to false
    }
  }

  // Fetch masternoo data from API
  Future<void> fetchMasterNooData() async {
    try {
      final apiData = await HomeApi.getDataNoo();
      if (apiData != null) {
        masternoo.value = apiData.firstWhere(
          (noo) => noo['id'] == selectedIdNoo.value,
          orElse: () => <String, dynamic>{}, // Return an empty map instead of null
        );
      }
    } catch (e) {
      Log.d('Error fetching masternoo data: $e');
    }
  }

  Future<void> fetchDocumentNoo() async {
    try {
      final apiDocuments = await HomeApi.getDocumentNoo(selectedIdNoo.value);
      if (apiDocuments != null) {
        documents.assignAll(apiDocuments);
      } else {
        documents.clear();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch documents: $e');
    }
  }
}