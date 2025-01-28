import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/background_service/alarm_manager.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/models/profile.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/profile/profile_api.dart';

class ProfileController extends GetxController {
  final box = Hive.box(HiveKeys.appBox);
  Profile? profile;
  User? userData;
  String? profilePicture;

  @override
  void onInit() {
    super.onInit();
    _getUserData();
  }

  _getUserData() async {
    var baseUrl = box.get(HiveKeys.baseURL);
    baseUrl = baseUrl.replaceAll('api/index.php', '');
    userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    profilePicture =
        '${baseUrl}EDS/upload/dokumenkaryawan/Foto_Karyawan/${userData!.foto}';
    profile = await ProfileApi.getProfile();
    update();
  }

  Future<void> logout() async {
    if (Utils.isMarketing()) {
      await AlarmManager.uploadDataMA();
      await MarketingDatabase().deleteAllData();
    }
    await ProfileApi.logout();
    await box.clear();
    Get.offAllNamed(Routes.AUTH);
  }

  Future<Uint8List?> downloadProfilePicture(String url) async {
    var response = await ProfileApi.downloadProfilePicture(url);
    return response?.bodyBytes;
  }
}
