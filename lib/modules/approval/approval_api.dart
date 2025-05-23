import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:uapp/core/utils/log.dart';

class ApprovalApi {
  static final StreamController<int> _approvalStreamController = StreamController<int>.broadcast();

  static Stream<int> get approvalStream => _approvalStreamController.stream;

  static Future<List<String>?> getApprovalData(String userId) async {
    try {
      final baseUrl = Uri.parse('https://unichem.co.id/api/');
      final bodyRequest = {
        'action': 'noo',
        'method': 'get_data_approval',
        'userid': userId,
      };
      final response = await http.post(
        baseUrl,
        body: bodyRequest,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'Data Found') {
          final approvalList = List<String>.from(data['data'].map((item) => item['nonoo']));
          if (approvalList.isNotEmpty) {
            _approvalStreamController.add(approvalList.length); // Emit event
          }
          return approvalList;
        } else {
          return [];
        }
      } else {
        return null;
      }
    } catch (e) {
      Log.d('Error fetching approval data: $e');
      return null;
    }
  }

  static Future<List<String>?> getUserApproval() async {
    try {
      final baseUrl = Uri.parse('https://unichem.co.id/api/');
      final bodyRequest = {
        'action': 'noo',
        'method': 'get_user_approval',
      };
      final response = await http.post(
        baseUrl,
        body: bodyRequest,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'Data Found') {
          return List<String>.from(data['data'].map((item) => item['nik']));
        } else {
          return [];
        }
      } else {
        return null;
      }
    } catch (e) {
      Log.d('Error fetching user approval data: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> getAllApprovalData() async {
    try {
      final userApprovalList = await getUserApproval();
      if (userApprovalList == null || userApprovalList.isEmpty) {
        return null;
      }

      List<Map<String, dynamic>> allApprovalData = [];
      for (String userId in userApprovalList) {
        final approvalData = await getApprovalData(userId);
        if (approvalData != null) {
          allApprovalData.addAll(approvalData.map((item) => {'userId': userId, 'data': item}));
        }
      }
      allApprovalData.sort((a, b) => b['data'].compareTo(a['data'])); // Sort data from newest to oldest

      return allApprovalData;
    } catch (e) {
      Log.d('Error fetching all approval data: $e');
      return null;
    }
  }

  static Future<bool> approveData(String userId, String nonoo, String creditLimit, String paymentMethod) async {
    try {
      final baseUrl = Uri.parse('https://unichem.co.id/api/');
      final bodyRequest = {
        'action': 'noo',
        'method': 'approve',
        'userid': userId,
        'nonoo': nonoo,
        'credit_limit': creditLimit,
        'payment_method': paymentMethod,
      };

      final response = await http.post(
        baseUrl,
        body: bodyRequest, // Mengirimkan body sebagai form-data
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['message'] == 'Data NOO Approved';
      } else {
        return false;
      }
    } catch (e) {
      Log.d('Error approving data: $e');
      return false;
    }
  }

    static Future<bool> rejectData(String userId, String nonoo) async {
    try {
      final baseUrl = Uri.parse('https://unichem.co.id/api/');
      final bodyRequest = {
        'action': 'noo',
        'method': 'reject',
        'userid': userId,
        'nonoo': nonoo,
      };

      final response = await http.post(
        baseUrl,
        body: bodyRequest, // Mengirimkan body sebagai form-data
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['message'] == 'Data NOO Rejected';
      } else {
        return false;
      }
    } catch (e) {
      Log.d('Error approving data: $e');
      return false;
    }
  }

  static Future<void> checkForNewApprovalData(String userId) async {
    try {
      final approvalData = await getApprovalData(userId);
      if (approvalData != null && approvalData.isNotEmpty) {
        Log.d('New approval data found: $approvalData');
      } else {
        Log.d('No new approval data found.');
      }
    } catch (e) {
      Log.d('Error checking for new approval data: $e');
    }
  }

  Future<Map<String, dynamic>> getTopOptions() async {
    try {
      final baseUrl = Uri.parse('https://unichem.co.id/api/');
      final body = {
        'action': 'noo',
        'method': 'get_pxtop',
      };
      final response = await http.post(
        baseUrl,
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load TOP options');
      }
    } catch (e) {
      Log.d('Error fetching TOP options: $e');
      throw Exception('Error fetching TOP options');
    }
  }
}

