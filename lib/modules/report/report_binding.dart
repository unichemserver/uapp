import 'package:get/get.dart';
import 'package:uapp/modules/report/report_controller.dart';

class ReportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(() => ReportController());
  }
}
