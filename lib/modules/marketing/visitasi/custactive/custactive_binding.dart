import 'package:get/get.dart';
import 'package:uapp/modules/marketing/visitasi/custactive/custactive_controller.dart';

class CustactiveBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustactiveController>(() => CustactiveController());
  }
}