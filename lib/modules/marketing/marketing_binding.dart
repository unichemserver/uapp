import 'package:get/get.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';

class MarketingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketingController>(() => MarketingController());
  }
}
