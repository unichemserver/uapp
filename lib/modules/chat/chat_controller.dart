import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/models/contact.dart';
import 'package:uapp/models/user.dart';

class ChatController extends GetxController {
  final db = DatabaseHelper();
  final box = Hive.box(HiveKeys.appBox);
  List<Contact> contactList = [];
  bool showCloseButton = false;

  void setShowCloseButton(bool value) {
    showCloseButton = value;
    update();
  }

  void getContact() async {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    contactList = await db.getContact(userData.id);
    update();
  }

  void searchContact(String query) async {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    contactList = await db.searchContact(query, userData.id);
    update();
  }

  String getFotoNamaUrl(String foto) {
    String baseUrl = box.get(HiveKeys.baseURL);
    baseUrl = baseUrl.replaceAll('api/index.php', '');
    return '${baseUrl}EDS/upload/dokumenkaryawan/Foto_Karyawan/$foto';
  }

  @override
  void onInit() {
    super.onInit();
    getContact();
  }
}