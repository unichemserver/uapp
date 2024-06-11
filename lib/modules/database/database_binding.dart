import 'package:get/get.dart';
import 'package:uapp/modules/database/database_controller.dart';

class DatabaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatabaseController>(() => DatabaseController());
  }
}
