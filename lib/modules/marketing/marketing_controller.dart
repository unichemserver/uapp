import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/date_utils.dart' as du;
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/models/customer.dart';
import 'package:uapp/models/route.dart' as rt;
import 'package:uapp/modules/marketing/api/api_client.dart';
import 'package:uapp/modules/marketing/marketing_api.dart';
import 'package:uapp/modules/marketing/model/collection_model.dart';
import 'package:uapp/modules/marketing/model/competitor_model.dart';
import 'package:uapp/modules/marketing/model/cust_top.dart';
import 'package:uapp/modules/marketing/model/invoice_model.dart';
import 'package:uapp/modules/marketing/model/master_item.dart';
import 'package:uapp/modules/marketing/model/stock_model.dart';
import 'package:uapp/modules/marketing/model/to_model.dart';

class MarketingController extends GetxController {
  final db = MarketingDatabase();
  final api = MarketingApiService();
  final box = Hive.box(HiveKeys.appBox);
  List<rt.Route> listRute = [];
  List<Customer> existingCustomer = [];
  List<StockModel> products = [];
  List<MasterItem> items = [];
  List<CompetitorModel> competitors = [];
  List<String> displayList = [];
  List<ToModel> takingOrders = [];
  List<CollectionModel> listCollection = [];
  List<BelumInvoice> listInvoice = [];
  List<String> paymentMethod = ['Cash', 'Transfer Bank', 'Giro'];
  List<String> statusPayment = [
    'Collected',
    'Partial Collected',
    'Not Collected'
  ];
  List<String> finishFotoCi = [];
  List<CustTop> listCustTop = [];

  CustTop? selectedCustTop;
  Position? userPosition;
  double latitude = 0.0;
  double longitude = 0.0;
  BelumInvoice? selectedInvoice;

  String jenisCall = '';
  String? customerId = '';
  String? customerName = '';
  String? userAddress = '*';
  String? ruteId;
  String? selectedPaymentMethod;
  String? buktiTransfer;
  String imagePath = '';
  String ttdPath = '';

  int currentIndex = 0;
  int currentReportIndex = 0;
  int jenisRute = -1;
  int selectedOnRoute = -1;
  int selectedOffRoute = -1;
  String? idMarketingActivity;
  int selectedStatusPayment = -1;

  final MarketingApiClient apiClient = MarketingApiClient();

  void setCustTop(CustTop? value) async {
    await db.update(
      'marketing_activity',
      {'top_id': value!.topID},
      'id = ?',
      [idMarketingActivity],
    );
  }

  void getCustTop() async {
    final data = await db.query(
      'marketing_activity',
      where: 'id = ?',
      whereArgs: [idMarketingActivity],
    );
    if (data.isNotEmpty) {
      final topId = data[0]['top_id'] as String?;
      if (topId != null) {
        selectedCustTop = listCustTop.firstWhere((element) => element.topID == topId);
      }
    }
    update();
  }

  void selectStatusPayment(int? value) {
    selectedStatusPayment = value!;
    update();
  }

  void selectPaymentMethod(String? value) {
    selectedPaymentMethod = value;
    update();
  }

  void selectInvoice(BelumInvoice? value) {
    selectedInvoice = value;
    update();
  }

  void setCustomerId(String id, String name) {
    customerId = id;
    customerName = name;
    update();
  }

  void changeJenisCall(String jenis) {
    jenisCall = jenis;
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

  Future<void> getUserPosition() async {
    userPosition = await Geolocator.getCurrentPosition();
    if (userPosition!.isMocked) {
      Utils.showDialogNotAllowed(Get.context!);
    }
    latitude = userPosition!.latitude;
    longitude = userPosition!.longitude;
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

  Future<void> checkIn() async {
    var arg = Get.arguments as Map<String, dynamic>;
    var type = arg['type'];
    var custId = arg['id'];
    var custName = arg['name'];
    var userId = Utils.getUserData().id;
    if (userPosition == null) {
      await getUserPosition();
    }
    var lat = userPosition!.latitude;
    var lon = userPosition!.longitude;
    var now = DateTime.now();
    var waktuCi = now.toIso8601String().replaceAll('T', ' ').split('.').first;
    idMarketingActivity = await generateMarketingActivityID();
    var data = {
      'id': idMarketingActivity,
      'user_id': userId,
      'cust_id': custId,
      'cust_name': custName,
      'rute_id': ruteId,
      'foto_ci': imagePath,
      'lat_ci': lat,
      'lon_ci': lon,
      'jenis': type,
      'waktu_ci': waktuCi,
    };
    setCustomerId(custId.toString(), custName.toString());
    await db.insert('marketing_activity', data);
    box.put(HiveKeys.idMa, idMarketingActivity);
    changeIndex(1);
    getListInvoice();
    getListItem();
    getListTop();
  }

  Future<String> generateMarketingActivityID() async {
    var dateToday = du.DateUtils.getFormatDate();
    var userId = Utils.getUserData().id;
    String pattern = 'CM$userId$dateToday';
    String query = '''
    SELECT id FROM marketing_activity
      WHERE id LIKE '$pattern%'
      ORDER BY created_at DESC
      LIMIT 1
    ''';
    List<Map> result = await db.rawQuery(query);
    int newIncrement = 1;
    if (result.isNotEmpty) {
      String lastId = result.first['id'];
      int lastIncrement = int.parse(lastId.substring(lastId.length - 3));
      newIncrement = lastIncrement + 1;
    }
    return '$pattern${newIncrement.toString().padLeft(3, '0')}';
  }

  Future<void> checkOut() async {
    await getUserPosition();
    Map<String, dynamic> data = {
      'waktu_co': DateTime.now()
          .toIso8601String()
          .replaceAll('T', ' ')
          .split('.')
          .first,
      'lat_co': userPosition!.latitude,
      'lon_co': userPosition!.longitude,
      'status_call': takingOrders.isEmpty ? 'vno' : 'vwo',
    };
    await db.update(
      'marketing_activity',
      data,
      'id = ?',
      [idMarketingActivity],
    );
  }

  Future<void> getListItem() async {
    final box = await Hive.openBox<MasterItem>(HiveKeys.masterItemBox);
    if (box.isNotEmpty) {
      items = box.values.map((e) => MasterItem.fromJson(e.toJson())).toList();
      update();
      return;
    }
    final response = await apiClient.postRequest(method: 'get_list_item');
    if (response.success) {
      items =
          (response.data as List).map((e) => MasterItem.fromJson(e)).toList();
      for (var element in items) {
        box.add(MasterItem(
          itemID: element.itemID,
          description: element.description,
          salesUnit: element.salesUnit,
          salesPrice: element.salesPrice,
        ));
      }
      update();
    }
  }

  Future<void> getListTop() async {
    final box = await Hive.openBox<CustTop>(HiveKeys.custTopBox);
    bool isLocalDataAvailable = box.isNotEmpty;
    if (isLocalDataAvailable) {
      listCustTop =
          box.values.map((e) => CustTop.fromJson(e.toJson())).toList();
      update();
      return;
    }
    final response = await apiClient.postRequest(method: 'get_cust_top');
    if (response.success) {
      listCustTop =
          (response.data as List).map((e) => CustTop.fromJson(e)).toList();
      for (var element in listCustTop) {
        box.add(CustTop(
          topID: element.topID,
          custID: element.custID,
        ));
      }
      update();
    }
  }

  Future<void> getListInvoice() async {
    final localData = await db.query('invoice');
    if (localData.isEmpty) {
      final response =
          await apiClient.postRequest(method: 'get_unbilled_invoice');
      if (response.success) {
        var invoiceList = (response.data as List)
            .map((e) => BelumInvoice.fromJson(e))
            .toList();
        update();
        for (var element in invoiceList) {
          db.insert('invoice', element.toJson());
        }
      } else {
        Utils.showErrorSnackBar(
          Get.context!,
          'Gagal mengambil data invoice',
        );
      }
    }
    listInvoice = await db.query(
      'invoice',
      where: 'Kode_Customer = ?',
      whereArgs: [customerId!],
    ).then(
      (value) {
        return value.map((e) => BelumInvoice.fromJson(e)).toList();
      },
    );
    print(listInvoice.length);
    update();
  }

  getStockFromDatabase() async {
    products = await db.query(
      'stock',
      where: 'idMA = ?',
      whereArgs: [idMarketingActivity],
    ).then((value) {
      return value.map((e) => StockModel.fromJson(e)).toList();
    });
    update();
  }

  addStockToDatabase(StockModel stock) async {
    await db.insert('stock', stock.toJson());
    getStockFromDatabase();
  }

  deleteStockFromDatabase(StockModel stock) async {
    await db.delete(
      'stock',
      'idMA = ? AND item_id = ?',
      [stock.idMA, stock.itemId],
    );
    getStockFromDatabase();
  }

  updateStockToDatabase(StockModel stock) async {
    await db.update(
      'stock',
      stock.toJson(),
      'idMA = ? AND item_id = ?',
      [stock.idMA, stock.itemId],
    );
    getStockFromDatabase();
  }

  getCompetitorFromDatabase() async {
    competitors = await db.query(
      'competitor',
      where: 'idMA = ?',
      whereArgs: [idMarketingActivity],
    ).then((value) {
      return value.map((e) => CompetitorModel.fromJson(e)).toList();
    });
    update();
  }

  addCompetitorToDatabase(CompetitorModel competitor) async {
    await db.insert('competitor', competitor.toJson());
    getCompetitorFromDatabase();
  }

  deleteCompetitorFromDatabase(CompetitorModel competitor) async {
    await db.delete(
      'competitor',
      'idMA = ? AND name = ?',
      [competitor.idMA, competitor.name],
    );
    getCompetitorFromDatabase();
  }

  getDisplayFromDatabase() async {
    displayList = await db.query(
      'display',
      where: 'idMA = ?',
      whereArgs: [idMarketingActivity],
    ).then((value) {
      return value.map((e) => e['image'] as String).toList();
    });
    update();
  }

  addDisplayToDatabase(String image) async {
    await db.insert('display', {
      'idMA': idMarketingActivity,
      'image': image,
      'type': 'display',
    });
    getDisplayFromDatabase();
  }

  deleteDisplayFromDatabase(String image) async {
    await db.delete(
      'display',
      'idMA = ? AND image = ?',
      [idMarketingActivity, image],
    );
    getDisplayFromDatabase();
  }

  addTakingOrderToDatabase(ToModel data) async {
    await db.insert('taking_order', data.toJson());
    getTakingOrderFromDatabase();
  }

  getTakingOrderFromDatabase() async {
    takingOrders = await db.query(
      'taking_order',
      where: 'idMA = ?',
      whereArgs: [idMarketingActivity],
    ).then((value) {
      return value.map((e) => ToModel.fromJson(e)).toList();
    });
    update();
  }

  deleteTakingOrderFromDatabase(ToModel data) async {
    await db.delete(
      'taking_order',
      'idMA = ? AND itemid = ?',
      [idMarketingActivity!, data.itemid],
    );
    getTakingOrderFromDatabase();
  }

  getSignatureFromDatabase() async {
    final data = await db.query(
      'marketing_activity',
      where: 'id = ?',
      whereArgs: [idMarketingActivity],
    );
    if (data.isNotEmpty) {
      final ttd = data[0]['ttd'] as String?;
      if (ttd != null) {
        ttdPath = ttd;
      }
    }
    update();
  }

  void updateSignature(String image) async {
    await db.update(
      'marketing_activity',
      {'ttd': image.isEmpty ? null : image},
      'id = ?',
      [idMarketingActivity],
    );
  }

  getCollectionFromDatabase() async {
    listCollection = await db.query(
      'collection',
      where: 'idMA = ?',
      whereArgs: [idMarketingActivity],
    ).then((value) {
      return value.map((e) => CollectionModel.fromMap(e)).toList();
    });
    update();
  }

  addCollectionToDatabase(CollectionModel data) async {
    await db.insert('collection', data.toMap());
    getCollectionFromDatabase();
  }

  deleteCollectionFromDatabase(CollectionModel data) async {
    await db.delete(
      'collection',
      'idMA = ? AND noinvoice = ? AND nocollect = ? AND amount = ? AND type = ? AND status = ?',
      [
        idMarketingActivity,
        data.noInvoice,
        data.noCollect,
        data.amount,
        data.type,
        data.status
      ],
    );
    getCollectionFromDatabase();
  }

  void rotateScreen(bool toPortrait) {
    if (toPortrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  Future<void> isUserCheckedIn() async {
    final arg = Get.arguments as Map<String, dynamic>;
    final custId = arg['id'];
    final name = arg['name'];
    final type = arg['type'];
    changeJenisCall(type);
    final idMA = arg['ma'];
    if (idMA != null) {
      idMarketingActivity = idMA;
      setCustomerId(custId, name);
      changeIndex(1);
      getListInvoice();
      getListItem();
      getListTop();
      getStockFromDatabase();
      getCompetitorFromDatabase();
      getDisplayFromDatabase();
      getTakingOrderFromDatabase();
      getSignatureFromDatabase();
      getCollectionFromDatabase();
      getCustTop();
    } else {
      await getUserPosition();
    }
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Utils.showLoadingDialog(Get.context!);
      Future.wait([
        isUserCheckedIn(),
      ]).then((value) {
        // Get.back();
      });
    });
  }
}
