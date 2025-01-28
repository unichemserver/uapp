import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uapp/core/hive/hive_service.dart';

class SettingController extends GetxController {
  final String url = 'https://unichem.co.id/EDS/assets/uapp-build-release.apk';
  String idPeralatan = '';

  bool isNotificationEnabled = false;
  int downloadTaskStatus = 0;
  int downloadTaskProgrss = 0;

  void getNotificationStatus() async {
    PermissionStatus status = await Permission.notification.status;
    isNotificationEnabled = status.isGranted;
    update();
  }

  void getIdPeralatanIT() {
    idPeralatan = HiveService.idPeralatanIT();
    update();
  }

  void setIdPeralatanIT(String id) {
    HiveService.setIdPeralatanIT(id);
    getIdPeralatanIT();
  }

  void requestNotificationPermission() async {
    await Permission.notification.request();
    getNotificationStatus();
  }

  void cancelNotificationPermission() async {
    await Permission.notification.request();
    getNotificationStatus();
  }

  @override
  void onInit() {
    super.onInit();
    getNotificationStatus();
    getIdPeralatanIT();
  }

}