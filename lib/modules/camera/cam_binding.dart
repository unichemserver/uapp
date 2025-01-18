import 'package:get/get.dart';
import 'package:uapp/modules/camera/cam_controller.dart';

class CamBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CamController>(() => CamController());
  }
}
