import 'package:get/get.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/canvasing_controller.dart';

class CanvasingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CanvasingController>(() => CanvasingController());
  }
}
