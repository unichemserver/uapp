import 'package:uapp/modules/approval/approval_api.dart';
import 'package:uapp/core/notification/notification.dart';
import 'package:hive/hive.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/core/utils/log.dart';
import 'dart:convert';

class ApprovalWorker {

  static Future<void> checkApprovalData() async {
    Log.d('ApprovalWorker: Task started');
    try {
      final box = await Hive.openBox(HiveKeys.appBox);
      final userData = box.get(HiveKeys.userData);
      Log.d('ApprovalWorker: Retrieved userData from Hive: $userData');

      if (userData == null) {
        Log.d('ApprovalWorker: No user data found in Hive');
        return;
      }

      final user = User.fromJson(jsonDecode(userData));
      final userId = user.id;
      Log.d('ApprovalWorker: Parsed userId: $userId');

      if (userId.isNotEmpty) {
        final approvalData = await ApprovalApi.getApprovalData(userId);
        Log.d('ApprovalWorker: API response: $approvalData');

        if (approvalData != null && approvalData.isNotEmpty) {
          Log.d('ApprovalWorker: New approval data found (${approvalData.length} items)');
          sendApprovalNotification(approvalData.length);
        } else {
          Log.d('ApprovalWorker: No new approval data found');
        }
      } else {
        Log.d('ApprovalWorker: User ID is empty');
      }
    } catch (e, stackTrace) {
      Log.d('ApprovalWorker: Error occurred - $e');
      Log.d('ApprovalWorker: StackTrace - $stackTrace');
    }
    Log.d('ApprovalWorker: Task completed');
  }
}