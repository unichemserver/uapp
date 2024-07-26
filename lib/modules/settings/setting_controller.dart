import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingController extends GetxController {
  final String url = 'https://unichem.co.id/EDS/assets/uapp-build-release.apk';

  bool isNotificationEnabled = false;
  int downloadTaskStatus = 0;
  int downloadTaskProgrss = 0;

  void getNotificationStatus() async {
    PermissionStatus status = await Permission.notification.status;
    isNotificationEnabled = status.isGranted;
    update();
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
  }

}