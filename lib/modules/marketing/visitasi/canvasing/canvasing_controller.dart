import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/hive/hive_service.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/utils/print_resi.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/models/canvasing.dart';
import 'package:uapp/models/collection.dart';
import 'package:uapp/models/resi.dart';
import 'package:uapp/core/utils/date_utils.dart' as du;
import 'package:uapp/modules/marketing/model/master_item.dart';
import 'package:uapp/modules/marketing/model/price_list.dart';
import 'package:uapp/modules/marketing/model/to_model.dart';
import 'package:uapp/modules/marketing/utils/mkt_utils.dart';

class CanvasingController extends GetxController with WidgetsBindingObserver {
  final db = MarketingDatabase();
  final box = Hive.box(HiveKeys.appBox);
  final GlobalKey<FormState> addFormKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController pemilikController = TextEditingController();
  final TextEditingController telpController = TextEditingController();
  final TextEditingController lokasiController= TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  Canvasing? canvasing;
  Canvasing? selectedCustomerId;
  List<ToModel> takingOrders = [];
  List<MasterItem> items = [];
  List<PriceList> priceList = [];
  List<String> unitItem = [];
  List<String> jenisPembayaran = ['Cash'];
  List<String> statusCollection = ['Collected', 'Partial', 'Not Collected'];
  List<Collection> listCollection = [];
  int selectedStatusCollection = 0;
  int selectedJenisPembayaran = 0;
  int canvasingIndex = 0;
  int totalPayment = 0;
  String idMA = '';
  double? latitude;
  double? longitude;
  String customerId = '';
  String outletImagePath = '';
  String proofOfPayment = '';
  String ttdPath = '';
  RxBool isCanvasingComplete = false.obs;
  bool isToComplete = false;
  String selectedUnit = '';
  Timer? checkMockTimer;
  String _selectedPPNCode = '';
  String get selectedPPNCode => _selectedPPNCode;

  var isLoading = false.obs;
  var canvasingCustomers = [].obs;
  var filteredCustomers = [].obs;

  get selectedItem => null;

  void searchCustomer(String query) {
    if (query.isEmpty) {
      clearSearch();
    } else {
      filteredCustomers.value = canvasingCustomers
          .where((customer) => customer.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      update();
    }
  }

  void clearSearch() {
    filteredCustomers.value = canvasingCustomers;
    update();
  }

  void fetchCustomers() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); // Placeholder for API call
    canvasingCustomers.value = []; // Replace with fetched data
    filteredCustomers.value = canvasingCustomers;
    isLoading.value = false;
  }

  void checkingMockLocation() {
    checkMockTimer?.cancel();
    checkMockTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      var isMockLocation = await Utils.isUseMockLocation();
      if (isMockLocation) {
        showWarningDialog();
      }
    });
  }

  void completeTo() {
    isToComplete = true;
    update();
  }

  printResi(String idMarketingActivity) async {
    var user = Utils.getUserData();
    var userId = user.id;
    var result = await db.query("taking_order",
        where: "idMA = ?", whereArgs: [idMarketingActivity]);
    var toItems = result.map((e) => ToModel.fromJson(e)).toList();
    var printData = Resi(
      activity: 'Canvasing',
      nomor: getNomorResi(idMarketingActivity, userId),
      namaPelanngan: pemilikController.text,
      namaSales: user.namaPanggilan ?? 'sales',
      toItems: toItems,
    );
    for (var item in printData.toItems) {
      Log.d('ToModel details: ${item.toJson()}');
    }
    PrintResi().printText(printData);
  }

  String getNomorResi(String idMa, String idUser) {
    var date = du.DateUtils.getCurrentDate();
    var year = date.substring(2, 4);
    var month = date.substring(5, 7);
    var nomor = idMa.isNotEmpty ? idMa.substring(idMa.length - 1) : '0';
    return 'FP.$year$month${idUser.padLeft(4, '0')}$nomor';
  }

  void selectJenisPembayaran(int index) {
    selectedJenisPembayaran = index;
    update();
  }

  void getListItem() async {
    items = await HiveService.getListItem();
    update();
  }

  void setCanvasingIndex(int index) {
    canvasingIndex = index;
    update();
  }

  void setOutletAddress(String address) {
    alamatController.text = address;
    update();
  }

  Future<void> updateCustomerData(
    String namaOutlet,
    String namaOwner,
    String noTelp,
    String alamat,
  ) async {
    Map<String, dynamic> canvasingData = {
      'CustID': customerId,
      'nama_outlet': namaOutlet,
      'nama_owner': namaOwner,
      'no_hp': noTelp,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'image_path': outletImagePath,
      'pembayaran': totalPayment,
    };
    Map<String, dynamic> maData = {'cust_name': namaOutlet};
    await db.insert("canvasing", canvasingData);
    await db.update("marketing_activity", maData, "id = ?", [idMA]);
  }

  Future<Position?> getCurrentLocation() async {
    Position? positon = await Geolocator.getCurrentPosition();
    latitude = positon.latitude;
    longitude = positon.longitude;
    if (await Utils.isInternetAvailable()) {
      var address = await getAddress(positon.latitude, positon.longitude);
      setOutletAddress(address);
    } else {
      var alamat =
          "Alamat tidak ditemukan\nLatitude: $latitude\nLongitude: $longitude";
      setOutletAddress(alamat);
    }
    return positon;
  }

  Future<String> getAddress(double lat, lon) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    String street = placemarks[0].street ?? '';
    String subLocality = placemarks[0].subLocality ?? '';
    String locality = placemarks[0].locality ?? '';
    return '$street\n$subLocality, $locality';
  }

  set selectedPPNCode(String value) {
    _selectedPPNCode = value;
    update(); // Notify listeners of the change
  }

  deleteTakingOrder(String itemId) async {
    await db.delete('taking_order', 'idMA = ? AND itemid = ?', [idMA, itemId]); // Updated column name to 'itemID'
    await getTakingOrder();
    calculateTotalPayment();
  }

  updateTakingOrder(
      String itemId, String namaItem, int qty, String unit, int harga) async {
    await getTakingOrder();
    calculateTotalPayment();
  }

  addTakingOrder(ToModel data) async {
    var additionalData = {
      'idMA': idMA,
    };
    var to = data.toJson();
    to.addAll(additionalData);
    await db.insert('taking_order', to);
    await getTakingOrder();
    calculateTotalPayment();
  }

  calculateTotalPayment() {
    totalPayment = 0;
    for (var item in takingOrders) {
      totalPayment += item.price! + item.ppn!;
    }
    nominalController.text = Utils.formatCurrency(totalPayment.toString());
    update();
  }

  getTakingOrder() async {
    var to =
        await db.query('taking_order', where: 'idMA = ?', whereArgs: [idMA]);
    takingOrders = to.map((e) => ToModel.fromJson(e)).toList();
    update();
  }

  inserTtd(String? path) async {
    await db.update('marketing_activity', {'ttd': path}, 'id = ?', [idMA]);
    ttdPath = path ?? '';
    update();
  }

  savePayment(int amount) async {
    var dataPayment = {
      'idMA': idMA,
      'noinvoice': '',
      'nocollect': '',
      'amount': amount,
      'type': jenisPembayaran[selectedJenisPembayaran],
      'status': getStatuCollection(amount),
    };
    if (listCollection.isEmpty) {
      await db.insert('collection', dataPayment);
      await getCollection();
      Get.snackbar('Success', 'Data berhasil disimpan');
      return;
    }
    Get.snackbar('Success', 'Data berhasil diperbarui');
    await getCollection();
  }

  Future<bool> isNetworkAvailable() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);
  }

  getCollection() async {
    if (listCollection.isEmpty) return;
    nominalController.text =
        Utils.formatCurrency(listCollection.first.amount.toString());
    update();
  }

  String getStatuCollection(int amount) {
    if (amount == totalPayment) {
      return 'collected';
    } else if (amount < totalPayment) {
      return 'partial collected';
    } else if (amount == 0) {
      return 'not collected';
    } else {
      return 'not collected';
    }
  }

  checkIn(double lat, double lon) async {
    var userData = Utils.getUserData();
    idMA = await MktUtils().generateMarketingActivityID();
    customerId = await generateCanvasingID('canvasing');
    var dataOutlet = {
      'CustID': customerId,
      'latitude': lat,
      'longitude': lon,
    };
    var waktuCi =
        DateTime.now().toIso8601String().substring(0, 19).replaceAll('T', ' ');
    var dataMA = {
      'id': idMA,
      'user_id': userData.id,
      'cust_id': customerId,
      'waktu_ci': waktuCi,
      'jenis': Call.canvasing,
      'lat_ci': lat,
      'lon_ci': lon,
    };
    await db.insert("canvasing", dataOutlet);
    await db.insert("marketing_activity", dataMA);
  }

  Future<String> generateCanvasingID(String table) async {
    var userId = Utils.getUserData().id;
    String pattern = Call.canvasing + userId;
    String query = '''
      SELECT CustID FROM $table
      WHERE CustID LIKE '$pattern%'
      ORDER BY CustID DESC
      LIMIT 1
    ''';
    List<Map> result = await db.rawQuery(query);

    int newIncrement = 1;
    if (result.isNotEmpty) {
      String lastId = result.first['CustID'];
      int lastIncrement = int.parse(lastId.substring(lastId.length - 4));
      newIncrement = lastIncrement + 1;
    }
    String incrementString = newIncrement.toString().padLeft(4, '0');
    return '$pattern$incrementString';
  }

  cancelCanvasing() async {
    await db.delete('marketing_activity', 'cust_id = ?', [customerId]);
    await db.delete('canvasing', 'CustID = ?', [customerId]);
    await db.delete('taking_order', 'idMA = ?', [idMA]);
    await db.delete('collection', 'idMA = ?', [idMA]);
  }

  Future<void> updateCustData() async {
    await updateCustomerData(
      namaController.text,
      pemilikController.text,
      telpController.text,
      alamatController.text,
    );
  }

  Future<void> checkOut() async {
    Position? position = await Geolocator.getCurrentPosition();
    double lat = position.latitude;
    double lon = position.longitude;
    var waktuCo =
        DateTime.now().toIso8601String().substring(0, 19).replaceAll('T', ' ');
    var statusCall = getStatusCall();
    var dataMA = {
      "lat_co": lat,
      "lon_co": lon,
      "waktu_co": waktuCo,
      "cust_name": namaController.text,
      "status_call": statusCall,
    };
    var dataCanvasing = {
      "nama_outlet": namaController.text,
      "nama_owner": pemilikController.text,
      "no_hp": telpController.text,
      "alamat": alamatController.text,
      "image_path": outletImagePath,
      'pembayaran': totalPayment,
    };
    await db.update('marketing_activity', dataMA, 'id = ?', [idMA]);
    await db.update('canvasing', dataCanvasing, 'CustID = ?', [customerId]);
  }

  saveCustomerData() async {
    await updateCustomerData(
      namaController.text,
      pemilikController.text,
      telpController.text,
      alamatController.text,
    );
  }

  String getStatusCall() {
    if (listCollection.isEmpty) {
      return 'vno';
    }
    if (isCollectionFullCollected()) {
      return 'vwo';
    }
    return 'vno';
  }

  bool isCollectionFullCollected() {
    return listCollection.isNotEmpty &&
        listCollection.every((element) => element.status == 'collected');
  }

  Future<void> isLocationServiceEnabled() async {
    var isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    var locPermission = await Geolocator.checkPermission();
    var isLocGranted = locPermission == LocationPermission.always ||
        locPermission == LocationPermission.whileInUse;
    if (!isLocationEnabled || !isLocGranted) {
      showLocationServiceDisabledDialog();
    } else {
      var isMockLocation = await Utils.isUseMockLocation();
      if (isMockLocation) {
        showWarningDialog();
      } else {
        handleArgumentsOrLocation();
      }
    }
  }

  void showLocationServiceDisabledDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) {
            Get.back();
          }
        },
        child: AlertDialog(
          title: const Text('Warning'),
          content: const Text('Silahkan aktifkan lokasi anda'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

Future<void> handleArgumentsOrLocation() async {
  var args = Get.arguments as Map<String, dynamic>?;

  bool isOnlyBasicArgs = args != null &&
      args.length == 3 &&
      args.containsKey('type') &&
      args.containsKey('name') &&
      args.containsKey('address');

  // Jika args null atau hanya berisi type, name, address → langsung ambil lokasi
  if (args == null || isOnlyBasicArgs) {
    var position = await getCurrentLocation();
    if (position != null) {
      checkIn(position.latitude, position.longitude);
    }
  } else {
    // Kalau args punya data penting lainnya → jalankan handleArguments
    handleArguments(args);
  }
}



  void handleArguments(Map<String, dynamic> args) async {
    customerId = args['id'];
    idMA = args['ma'];
    var result = await db
        .query('canvasing', where: 'CustID = ?', whereArgs: [customerId]);
    var maResult = await db
        .query('marketing_activity', where: 'id = ?', whereArgs: [idMA]);
    canvasing = Canvasing.fromJson(result.first);
    namaController.text = canvasing!.namaOutlet ?? '';
    pemilikController.text = canvasing!.namaOwner ?? '';
    telpController.text = canvasing!.noTelp ?? '';
    alamatController.text = canvasing!.alamat ?? '';
    latitude = canvasing!.latitude;
    longitude = canvasing!.longitude;
    outletImagePath = canvasing!.imagePath ?? '';
    ttdPath = maResult.first['ttd'] ?? '';
    getTakingOrder();
    calculateTotalPayment();
    getCollection();
  }

  showWarningDialog() {
    Get.dialog(
      const PopScope(
        canPop: false,
        child: Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Warning'),
              Text(
                'Anda terdeteksi menggunakan Fake GPS atau Mock Location',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getPriceList() async {
    priceList = await HiveService.getPriceList();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    getListItem();
    getPriceList();
    isLocationServiceEnabled();
    fetchCustomers();
    // getCanvasingCustomers();
  }

  @override
  void onClose() {
    namaController.dispose();
    pemilikController.dispose();
    telpController.dispose();
    alamatController.dispose();
    checkMockTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      if (customerId.isNotEmpty) {
        updateCustomerData(
          namaController.text,
          pemilikController.text,
          telpController.text,
          alamatController.text,
        );
      }
    } else if (state == AppLifecycleState.resumed) {
      print("App is in foreground");
    } else if (state == AppLifecycleState.detached) {
      print("App is detached");
      if (customerId.isNotEmpty) {
        updateCustomerData(
          namaController.text,
          pemilikController.text,
          telpController.text,
          alamatController.text,
        );
      }
    } else if (state == AppLifecycleState.inactive) {
      print("App is inactive");
      if (customerId.isNotEmpty) {
        updateCustomerData(
          namaController.text,
          pemilikController.text,
          telpController.text,
          alamatController.text,
        );
      }
    }
  }
}