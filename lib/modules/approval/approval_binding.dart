import 'package:get/get.dart';
import 'package:uapp/modules/approval/approval_controller.dart';


class ApprovalBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApprovalController>(() => ApprovalController());
  }
}