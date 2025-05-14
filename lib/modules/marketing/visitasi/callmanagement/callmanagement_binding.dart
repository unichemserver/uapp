import 'package:get/get.dart';
import 'package:uapp/modules/marketing/visitasi/callmanagement/callmanagement_controller.dart';

class CallManagementBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallManagementController>(() => CallManagementController());
  }
}