import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/sync/sync_api_service.dart';
import 'package:uapp/core/sync/sync_manager.dart';
import 'package:uapp/core/utils/alarm_manager.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/models/marketing_activity.dart';
import 'package:uapp/models/menu.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/home/home_api.dart';

class HomeController extends GetxController {
  final Box box = Hive.box(HiveKeys.appBox);
  final syncManager = SyncManager(SyncApiService(), DatabaseHelper());
  final db = DatabaseHelper();
  String foto = '';
  final List<MenuData> menus = [];
  final List<String> listServices = [
    'MASTER',
    'TRANSACTION',
    'REPORT',
  ];
  final List<MarketingActivity> listMarketingActivity = [];
  int selectedService = 1;
  MenuData? masterServices;
  MenuData? transactionService;
  MenuData? reportService;
  String nama = '';
  User? userData;
  bool showPassword = false;
  bool showConfirmPassword = false;
  Timer? timer;

  void togglePasswordVisibility() {
    showPassword = !showPassword;
    update();
  }

  void toggleConfirmPasswordVisibility() {
    showConfirmPassword = !showConfirmPassword;
    update();
  }

  void changePassword(String password) async {
    final isSuccess = await HomeApi.changePassword(password);
    if (Get.isDialogOpen!) {
      Get.back();
    }
    if (isSuccess) {
      var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
      Map<String, dynamic> user = {
        'id': userData.id,
        'nama': userData.nama,
        'namapanggilan': userData.namaPanggilan,
        'role': userData.role,
        'department': userData.department,
        'bagian': userData.bagian,
        'jabatan': userData.jabatan,
        'posisi': userData.posisi,
        'jenis': userData.jenis,
        'colectorid': userData.colectorid,
        'salesrepid': userData.salesrepid,
        'idupline': userData.idupline,
        'token': userData.token,
        'foto': userData.foto,
        'password_status': '1',
      };
      box.put(HiveKeys.userData, json.encode(user));
      Get.snackbar('Success', 'Password Berhasil Diubah');
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar('Error', 'Password Gagal Diubah');
    }
  }

  getListMarketingActivity() async {
    if (!Utils.isMarketing()) return;
    final data = await db.getMarketingActivityList();
    listMarketingActivity.clear();
    listMarketingActivity.addAll(data);
    update();
  }

  void getFotoNamaUrl() {
    String baseUrl = box.get(HiveKeys.baseURL);
    userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    baseUrl = baseUrl.replaceAll('api/index.php', '');
    nama = userData!.namaPanggilan!;
    foto = userData!.foto;
    foto = '${baseUrl}EDS/upload/dokumenkaryawan/Foto_Karyawan/$foto';
    update();
  }

  void firstSync() async {
    bool isSync = box.get(HiveKeys.isSync, defaultValue: false);
    if (!isSync) {
      await performSyncOperation();
      box.put(HiveKeys.isSync, true);
    }
  }

  Future<void> performSyncOperation() async {
    final sync = SyncManager(SyncApiService(), db);
    showPersistentSnackbar('Sedang melakukan sinkronisasi data...');
    try {
      await sync.syncAll(onStatus: (status) {});
    } finally {
      showPersistentSnackbar('Sinkronisasi data selesai');
      await Future.delayed(const Duration(seconds: 3));
      dismissSnackbar();
    }
  }

  void showPersistentSnackbar(String message) {
    dismissSnackbar();
    Get.snackbar(
      'Sync Data',
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(days: 1),
      isDismissible: false,
    );
  }

  void dismissSnackbar() {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
  }

  @override
  void onInit() {
    super.onInit();
    firstSync();
    getAvailableMenus();
    getFotoNamaUrl();
    checkPasswordStatus();
    getListMarketingActivity();
    scheduleUploadDataPeriodicly();
  }

  void scheduleUploadDataPeriodicly() {
    var user = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    if (user.department == 'MKT') {
      print('Schedule Upload Data');
      scheduleUploadDataPeriodic();
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  checkPasswordStatus() async {
    final user = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final passwdStatus = user.passwdStatus;
    final baseUrl = box.get(HiveKeys.baseURL);
    Future.delayed(const Duration(seconds: 1), () {
      if (baseUrl.contains('unifood')) {
        return;
      }
      if (passwdStatus == '0') {
        Get.toNamed(Routes.CHANGE_PASSWORD);
      }
    });
  }

  Future<void> logout() async {
    final baseUrl = box.get(HiveKeys.baseURL);
    final user = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final token = user.token;
    bool isLogout = await HomeApi.logout(baseUrl, token);
    if (isLogout) {
      clearDatabase();
      box.delete(HiveKeys.userData);
      box.delete(HiveKeys.baseURL);
      box.delete(HiveKeys.menu);
      box.delete(HiveKeys.isSync);
      box.delete(HiveKeys.isCheckIn);
      box.delete(HiveKeys.selectedCustID);
      box.delete(HiveKeys.selectedRuteID);
      box.delete(HiveKeys.idMa);
      box.delete(HiveKeys.jenisCall);
      Get.offAllNamed(Routes.AUTH);
    } else {
      Get.snackbar('Error', 'Logout Gagal, Silahkan Coba Lagi');
    }
  }

  Future<void> clearDatabase() async {
    try {
      final db = DatabaseHelper();
      await db.deleteSyncData();
    } catch (e) {
      print('Error: $e');
    }
  }

  void onSelectedService(int index) {
    selectedService = index;
    update();
  }

  int getSelectedServiceLength() {
    if (selectedService == 1) {
      return masterServices != null ? masterServices!.submenu.length : 0;
    } else if (selectedService == 2) {
      return transactionService != null
          ? transactionService!.submenu.length
          : 0;
    } else if (selectedService == 3) {
      return reportService != null ? reportService!.submenu.length : 0;
    } else {
      return 0;
    }
  }

  bool showMarketingMenu() {
    final box = Hive.box(HiveKeys.appBox);
    final userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final salesrepid = userData.salesrepid;
    if (salesrepid.isEmpty || salesrepid == '0') {
      return false;
    }
    return true;
  }

  void getAvailableMenus() {
    String listMenu = box.get('menu', defaultValue: '');
    if (listMenu.isEmpty) {
      requestMenu();
    } else {
      setupMenu(listMenu);
    }
  }

  void requestMenu() async {
    final url = box.get(HiveKeys.baseURL);
    final user = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final department = user.department;
    final bagian = user.bagian;
    final role = user.role;

    String? listMenu = await HomeApi.getListMenu(url, department, bagian, role);
    if (listMenu != null) {
      var res = jsonDecode(listMenu);
      var menus = res['menus'];
      box.put(HiveKeys.menu, jsonEncode(menus));
      getAvailableMenus();
    }
  }

  void setupMenu(String listMenu) {
    menus.clear();
    var savedMenus = jsonDecode(listMenu);
    for (var menu in savedMenus) {
      menus.add(MenuData.fromJson(menu));
    }
    for (var menu in menus) {
      if (menu.namaMenu.toLowerCase() == 'master') {
        masterServices = menu;
      } else if (menu.namaMenu.toLowerCase() == 'transaction') {
        transactionService = menu;
      } else if (menu.namaMenu.toLowerCase() == 'report') {
        reportService = menu;
      }
    }
    update();
  }

  String titleAppbar() {
    final user = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    final now = DateTime.now();
    final hour = now.hour;
    final nama = user.namaPanggilan;
    const greeting = 'Selamat';

    if (hour >= 5 && hour < 12) {
      return '$greeting Pagi, $nama';
    } else if (hour >= 12 && hour < 15) {
      return '$greeting Siang, $nama';
    } else if (hour >= 15 && hour < 18) {
      return '$greeting Sore, $nama';
    } else {
      return '$greeting Malam, $nama';
    }
  }

  Future<void> checkOut(String statusCall, int idMarketingActivity) async {
    print('CheckOut');
    var userPosition = await Geolocator.getCurrentPosition();
    var lat = userPosition.latitude;
    var lon = userPosition.longitude;
    print('Save CheckOut to Database');
    print('Status Call: $statusCall');
    await db.checkOut(
      idMarketingActivity,
      lat,
      lon,
      statusCall,
      box.get(HiveKeys.jenisCall),
    );
    bool isConnect = await Utils.isInternetAvailable();
    print('Check Internet Connection: $isConnect');
    if (isConnect) {
      print('Upload Report Data');
      await uploadReportData(idMarketingActivity);
    }
    print('Set Checkin to False');
    setDataCheckIn();
    Get.back();
    Get.snackbar('Success', 'Checkout Success');
  }

  void setDataCheckIn() {
    box.put(HiveKeys.jenisCall, null);
    box.put(HiveKeys.isCheckIn, false);
    box.put(HiveKeys.selectedCustID, null);
    box.put(HiveKeys.selectedRuteID, null);
    box.put(HiveKeys.idMa, null);
    update();
  }

  syncMarketingActivity() async {
    for (var item in listMarketingActivity) {
      if (item.statusSync == 0) {
        await uploadReportData(item.id!);
      }
    }
  }

  Future<void> uploadReportData(int idMarketingActivity) async {
    var dataActivity = await db.getMarketingActivity(idMarketingActivity);
    print('Data Activity: $dataActivity');
    var stockItemsDb = await db.getStockReports(idMarketingActivity);
    var stockItems = stockItemsDb.map((e) => e.toJson()).toList();
    print('Stock Items: $stockItems');
    var competitorItemsDb = await db.getCompetitors(idMarketingActivity);
    var competitorItems = competitorItemsDb.map((e) => e.toJson()).toList();
    print('Competitor Items: $competitorItems');
    var collectionItemsDb = await db.getCollections(idMarketingActivity);
    var collectionItems = collectionItemsDb.map((e) => e.toJson()).toList();
    print('Collection Items: $collectionItems');
    var imageItems = await db.getImageItems(idMarketingActivity);
    print('Image Items: $imageItems');
    var toItems = await db.getTakingOrder(idMarketingActivity);
    print('Taking Order Items: ${toItems.map((e) => e.toMap()).toList()}');

    var jenisCall = dataActivity['jenis'];
    print('Jenis Call: $jenisCall');
    Map<String, dynamic> reportData = dataActivity;
    if (jenisCall == Call.noo) {
      var customerId = box.get(HiveKeys.selectedCustID);
      var nooItem = await db.getNooById(int.parse(customerId));
      var custId = await HomeApi().uploadNooReport(
        nooItem.toJson(),
        box.get(HiveKeys.baseURL),
      );
      if (custId == 0) return;
      await db.updateNooStatus(int.parse(customerId));
      reportData = {
        'id': dataActivity['id'],
        'user_id': dataActivity['user_id'],
        'rute_id': dataActivity['rute_id'],
        'cust_id': custId.toString(),
        'foto_ci': dataActivity['foto_ci'],
        'foto_co': dataActivity['foto_co'],
        'waktu_ci': dataActivity['waktu_ci'],
        'waktu_co': dataActivity['waktu_co'],
        'lat_ci': dataActivity['lat_ci'],
        'lon_ci': dataActivity['lon_ci'],
        'lat_co': dataActivity['lat_co'],
        'lon_co': dataActivity['lon_co'],
        'status_sync': dataActivity['status_sync'],
        'status_call': dataActivity['status_call'],
        'jenis': dataActivity['jenis'],
        'ttd': dataActivity['ttd'],
      };
    } else if (jenisCall == Call.canvasing) {
      var customerId = dataActivity['cust_id'];
      var canvasingItem = await db.getCanvasingById(customerId);
      print('Test: ${canvasingItem.toJson()}');
      var custId = await HomeApi().uploadCanvasingReport(
        canvasingItem.toJson(),
        box.get(HiveKeys.baseURL),
      );
      if (custId == 0) return;
      await db.updateCanvasingStatus(int.parse(customerId));
      reportData = {
        'id': dataActivity['id'],
        'user_id': dataActivity['user_id'],
        'rute_id': dataActivity['rute_id'],
        'cust_id': custId.toString(),
        'foto_ci': dataActivity['foto_ci'],
        'foto_co': dataActivity['foto_co'],
        'waktu_ci': dataActivity['waktu_ci'],
        'waktu_co': dataActivity['waktu_co'],
        'lat_ci': dataActivity['lat_ci'],
        'lon_ci': dataActivity['lon_ci'],
        'lat_co': dataActivity['lat_co'],
        'lon_co': dataActivity['lon_co'],
        'status_sync': dataActivity['status_sync'],
        'status_call': dataActivity['status_call'],
        'jenis': dataActivity['jenis'],
        'ttd': dataActivity['ttd'],
      };
    }
    await HomeApi().uploadReport(
      idMarketingActivity.toString(),
      reportData,
      stockItems,
      competitorItems,
      collectionItems,
      imageItems,
      toItems.map((e) => e.toMap()).toList(),
      box.get(HiveKeys.baseURL),
    );
    await db.updateMarketingActivityStatus(idMarketingActivity);
  }
}
