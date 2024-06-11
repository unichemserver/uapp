import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/date_utils.dart' as du;
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/models/collection.dart';
import 'package:uapp/models/competitor.dart';
import 'package:uapp/models/customer.dart';
import 'package:uapp/models/item.dart';
import 'package:uapp/models/noo.dart';
import 'package:uapp/models/route.dart' as rt;
import 'package:uapp/models/stock.dart';
import 'package:uapp/models/sudah_invoice.dart';
import 'package:uapp/models/to.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/marketing/marketing_api.dart';

class MarketingController extends GetxController {
  final db = DatabaseHelper();
  final api = MarketingApiService();
  final box = Hive.box(HiveKeys.appBox);
  List<rt.Route> listRute = [];
  List<Customer> existingCustomer = [];
  List<Stock> products = [];
  List<Item> items = [];
  List<Competitor> competitors = [];
  List<String> displayList = [];
  List<To> takingOrders = [];
  List<Collection> listCollection = [];
  List<SudahInvoice> listInvoice = [];
  List<String> paymentMethod = ['Cash', 'Transfer Bank', 'Giro'];
  List<String> statusPayment = [
    'Collected',
    'Partial Collected',
    'Not Collected'
  ];
  List<String> finishFotoCi = [];

  Position? userPosition;
  SudahInvoice? selectedInvoice;

  String jenisCall = '';
  String? customerId = '';
  String? userAddress;
  String? ruteId;
  String? selectedPaymentMethod;

  int currentIndex = 0;
  int currentReportIndex = 0;
  int jenisRute = -1;
  int selectedOnRoute = -1;
  int selectedOffRoute = -1;
  int? idMarketingActivity;
  int selectedStatusPayment = -1;

  void selectStatusPayment(int? value) {
    selectedStatusPayment = value!;
    update();
  }

  void selectPaymentMethod(String? value) {
    selectedPaymentMethod = value;
    update();
  }

  void selectInvoice(SudahInvoice? value) {
    selectedInvoice = value;
    update();
  }

  void setCustomerId(String id) {
    customerId = id;
    update();
  }

  void changeJenisCall(String jenis) {
    box.put(HiveKeys.jenisCall, jenis);
    jenisCall = jenis;
    update();
  }

  void changeSelectedOnRoute(int index) {
    selectedOnRoute = index;
    update();
  }

  void changeSelectedOffRoute(int index) {
    selectedOffRoute = index;
    update();
  }

  void changeJenisRute(int index) {
    jenisRute = index;
    update();
  }

  void changeIndex(int index) {
    currentIndex = index;
    update();
  }

  void changeReportIndex(int index) {
    currentReportIndex = index;
    update();
  }

  void getExistingCustomer() async {
    existingCustomer.clear();
    var customers = await db.getExistingCustomer();
    existingCustomer.addAll(customers);
    update();
  }

  void getRuteToday() async {
    String tanggal = du.DateUtils.getCurrentDate();
    int hari = du.DateUtils.getDayOfWeek(tanggal);
    int week = du.DateUtils.getWeekOfMonth(tanggal);
    print('Hari: ${String.fromCharCode(hari + 64)}, Week: $week');
    var rute = await db.getRute(
      week,
      String.fromCharCode(hari + 64),
    );
    listRute = rute.map((e) => rt.Route.fromJson(e)).toList();
    uploadDataMarketingActivity();
    update();
  }

  uploadDataMarketingActivity() async {
    if (await checkMADataUploaded()) {
      print('Data MA sudah diupload');
      return;
    }
    if (listRute.isEmpty) {
      print('Data rute kosong');
      return;
    }
    Get.snackbar('Info', 'Sedang mengupload data marketing activity');
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    var userId = userData.id;
    for (var route in listRute) {
      var idMA = await api.getIDMarketingActivity(
        route.idRute,
        route.custID,
      );
      await db.insertMarketingActivity(
        idMA,
        route.idRute,
        userId,
        route.custID!,
      );
    }
    Get.snackbar('Info', 'Data marketing activity berhasil diupload');
    box.put(du.DateUtils.getCurrentDate(), true);
  }

  Future<bool> checkMADataUploaded() async {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    List<dynamic> todayActivity = await api.getTodayActivity(
      userData.id.toString(),
    );
    List<dynamic> localActivity = await db.getTodayActivity(
      userData.id.toString(),
    );
    return todayActivity.length == localActivity.length;
  }

  Future<void> getUserPosition() async {
    userPosition = await Geolocator.getCurrentPosition();
    if (userPosition!.isMocked) {
      Utils.showDialogNotAllowed(Get.context!);
    }
    List<Placemark> placemarks = await placemarkFromCoordinates(
      userPosition!.latitude,
      userPosition!.longitude,
    );
    String street = placemarks[0].street ?? '';
    String subLocality = placemarks[0].subLocality ?? '';
    String locality = placemarks[0].locality ?? '';
    userAddress = '$street*$subLocality,$locality';
    update();
  }

  Future<void> checkIn(String imagePath) async {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    var userId = userData.id;
    if (userPosition == null) {
      await getUserPosition();
    }
    var lat = userPosition!.latitude;
    var lon = userPosition!.longitude;
    var data = {
      'user_id': userId,
      'cust_id': customerId,
      'rute_id': ruteId,
      'foto_ci': imagePath,
      'lat_ci': lat,
      'lon_ci': lon,
      'jenis': jenisCall,
      'waktu_ci': DateTime.now().toIso8601String(),
    };
    int idMA;
    if (ruteId != null) {
      idMA = await db.checkInOnRoute(ruteId!, userId, imagePath, lat, lon);
    } else {
      idMA = await db.insertMarketingActivityData(data);
    }
    setDataCheckIn(idMA);
  }

  void setDataCheckIn(int id) {
    idMarketingActivity = id;
    box.put(HiveKeys.jenisCall, jenisCall);
    box.put(HiveKeys.isCheckIn, true);
    box.put(HiveKeys.selectedCustID, customerId);
    box.put(HiveKeys.selectedRuteID, ruteId);
    box.put(HiveKeys.idMa, id);
    update();
  }

  void isCheckIn() {
    var isUserCheckIn = box.get(HiveKeys.isCheckIn, defaultValue: false);
    if (isUserCheckIn) {
      jenisCall = box.get(HiveKeys.jenisCall);
      customerId = box.get(HiveKeys.selectedCustID, defaultValue: '');
      ruteId = box.get(HiveKeys.selectedRuteID);
      idMarketingActivity = box.get(HiveKeys.idMa);
      update();
      getStocks();
      if (jenisCall != Call.canvasing) {
        currentIndex = 2;
        update();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.toNamed(Routes.CANVASING);
        });
      }
    }
  }

  // Start CRUD Stock
  void getStocks() async {
    var stocks = await db.getStockReports(idMarketingActivity!);
    products = stocks;
    update();
  }

  void addStockToDatabase(Stock stocks) async {
    await db.insertStockReport(stocks.toJson());
    getStocks();
  }

  void removeStockFromDatabase(Stock stocks) async {
    await db.removeStockReport(stocks.id);
    getStocks();
  }

  void updateStockToDatabase(Stock stocks) async {
    await db.updateStockReport(stocks.toJson());
    getStocks();
  }

  // End CRUD Stock

  // Start CRUD Competitor
  void getCompetitors() async {
    var competitors = await db.getCompetitors(idMarketingActivity!);
    this.competitors = competitors;
    update();
  }

  void addCompetitorToDatabase(Competitor competitor) async {
    await db.insertCompetitor(competitor.toJson());
    getCompetitors();
  }

  void removeCompetitorFromDatabase(Competitor competitor) async {
    await db.removeCompetitor(competitor.id);
    getCompetitors();
  }

  void updateCompetitorToDatabase(Competitor competitor) async {
    await db.updateCompetitor(competitor.toJson());
    getCompetitors();
  }

  // End CRUD Competitor

  // Start CRUD Taking Order
  void getTakingOrders() async {
    takingOrders = await db.getTakingOrder(idMarketingActivity!);
    update();
  }

  addTakingOrderToDatabase(
    String itemID,
    String description,
    int quantity,
    String unit,
    int price,
  ) async {
    await db.insertTakingOrder(
      idMarketingActivity!,
      itemID,
      description,
      quantity,
      unit,
      price,
    );
    getTakingOrders();
  }

  void removeTakingOrderFromDatabase(String takingOrder) async {
    await db.deleteTakingOrder(idMarketingActivity!, takingOrder);
    getTakingOrders();
  }

  // End CRUD Taking Order

  // Start CRUD Collection
  void getCollections() async {
    var collections = await db.getCollections(idMarketingActivity!);
    listCollection = collections;
    update();
  }

  void addCollectionToDatabase(Map<String, Object?> collection) async {
    await db.insertCollection(collection);
    getCollections();
  }

  void removeCollectionFromDatabase(int id) async {
    await db.deleteCollection(id);
    getCollections();
  }

  // End CRUD Collection

  // Start CRUD Display
  void getDisplay() async {
    displayList = await db.getDisplay(idMarketingActivity!);
    update();
  }

  void addDisplay(String imagePath) async {
    await db.insertDisplay(idMarketingActivity!, imagePath);
    getDisplay();
  }

  void removeDisplay(String imagePath) async {
    await db.deleteDisplay(idMarketingActivity!, imagePath);
    getDisplay();
  }

  // End CRUD Display

  void getListItem() async {
    var itemsDb = await db.getListItem();
    items = itemsDb;
    update();
  }

  void getInvoice() async {
    var invoices = await db.getData('invoice');
    listInvoice = invoices.map((e) => SudahInvoice.fromJson(e)).toList();
    listInvoice =
        listInvoice.where((element) => element.custID == customerId).toList();
    update();
  }

  void insertTtd(String imagePath) async {
    await db.updateTtd(idMarketingActivity!, imagePath);
    update();
  }

  Future<int> saveDataNooToDB(Noo data) async {
    return await db.addNoo(data.toJson());
  }

  void getListFinishFotoCi() async {
    finishFotoCi = await db.getFinishFotoCi();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getListFinishFotoCi();
    getRuteToday();
    getUserPosition();
    isCheckIn();
    getListItem();
  }
}
