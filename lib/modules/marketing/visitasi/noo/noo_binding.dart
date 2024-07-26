import 'package:get/get.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_controller.dart';

class NooBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NooController>(() => NooController());
  }
}