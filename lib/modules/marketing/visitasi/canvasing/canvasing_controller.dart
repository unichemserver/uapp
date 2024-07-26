import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/print_resi.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/models/canvasing.dart';
import 'package:uapp/models/collection.dart';
import 'package:uapp/models/item.dart';
import 'package:uapp/models/resi.dart';
import 'package:uapp/models/to.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/home/home_controller.dart';
import 'package:uapp/core/utils/date_utils.dart' as du;

class CanvasingController extends GetxController with WidgetsBindingObserver {
  final db = DatabaseHelper();
  final box = Hive.box(HiveKeys.appBox);
  final GlobalKey<FormState> addFormKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController pemilikController = TextEditingController();
  final TextEditingController telpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  Canvasing? canvasing;
  List<To> takingOrders = [];
  List<Item> items = [];
  List<String> jenisPembayaran = ['Cash'];
  List<String> statusCollection = ['Collected', 'Partial', 'Not Collected'];
  List<Collection> listCollection = [];
  int selectedStatusCollection = 0;
  int selectedJenisPembayaran = 0;
  int canvasingIndex = 0;
  int totalPayment = 0;
  int idMA = 0;
  double? latitude;
  double? longitude;
  String customerId = '';
  String outletImagePath = '';
  String proofOfPayment = '';
  String ttdPath = '';
  RxBool isCanvasingComplete = false.obs;
  bool isToComplete = false;

  void completeTo() {
    isToComplete = true;
    update();
  }

  printResi(int idMarketingActivity) async {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    var userId = userData.id;
    List<To> toItems = await db.getTakingOrder(idMarketingActivity);
    var printData = Resi(
      nomor: getNomorResi(idMarketingActivity,userId),
      namaPelanngan: pemilikController.text,
      namaSales: userData.namaPanggilan ?? 'sales',
      toItems: toItems,
    );
    PrintResi().printText(printData);
  }

  String getNomorResi(int idMa, String idUser) {
    var date = du.DateUtils.getCurrentDate();
    var year = date.substring(2, 4);
    var month = date.substring(5, 7);
    var nomor = idMa.toString().padLeft(3, '0');
    return 'FP.$year$month$idUser$nomor';
  }

  void selectJenisPembayaran(int index) {
    selectedJenisPembayaran = index;
    update();
  }

  void getListItem() async {
    var itemsDb = await db.getListItem();
    items = itemsDb;
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
    };
    print('canvasingData: $canvasingData');
    await db.updateCustomerCanvasing(canvasingData);
  }

  Future<Position?> getCurrentLocation() async {
    Position? positon = await Geolocator.getCurrentPosition(
      timeLimit: const Duration(seconds: 2),
    );
    latitude = positon.latitude;
    longitude = positon.longitude;
    print('latitude: $latitude, longitude: $longitude');
    if (await isNetworkAvailable()) {
      var address = await getAddress(positon.latitude, positon.longitude);
      setOutletAddress(address);
    } else {
      var alamat = "Alamat tidak ditemukan\nLatitude: $latitude\nLongitude: $longitude";
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

  // void isFirstTimeCanvasing(double lat, double lon) async {
  //   bool isFirstTime =
  //       box.get(HiveKeys.isFirstTimeCanvasing, defaultValue: true);
  //   if (isFirstTime) {
  //     var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
  //     var dataOutlet = {
  //       'latitude': lat,
  //       'longitude': lon,
  //     };
  //     customerId = await db.addCustomerCanvasing(dataOutlet);
  //     box.put(HiveKeys.selectedCustID, customerId);
  //     var dataMA = {
  //       'user_id': userData.id,
  //       'cust_id': customerId,
  //       'waktu_ci': DateTime.now().toIso8601String(),
  //       'jenis': Call.canvasing,
  //       'lat_ci': lat,
  //       'lon_ci': lon,
  //     };
  //     idMA = await db.checkInCanvasing(dataMA);
  //     print('idMA: $idMA');
  //     box.put(HiveKeys.idMa, idMA);
  //     box.put(HiveKeys.isFirstTimeCanvasing, false);
  //   } else {
  //     idMA = box.get(HiveKeys.idMa);
  //     customerId = box.get(HiveKeys.selectedCustID);
  //     canvasing = await db.getCanvasing(customerId);
  //     setOutletAddress(canvasing?.alamat ?? '');
  //     outletImagePath = canvasing?.imagePath ?? '';
  //     namaController.text = canvasing?.namaOutlet ?? '';
  //     pemilikController.text = canvasing?.namaOwner ?? '';
  //     telpController.text = canvasing?.noTelp ?? '';
  //     latitude = canvasing?.latitude;
  //     longitude = canvasing?.longitude;
  //     ttdPath = await db.getTtd(idMA) ?? '';
  //     await getTakingOrder();
  //     calculateTotalPayment();
  //     getCollection();
  //     update();
  //   }
  // }

  deleteTakingOrder(String itemId) async {
    await db.deleteTakingOrder(idMA, itemId);
    await getTakingOrder();
    calculateTotalPayment();
  }

  updateTakingOrder(
      String itemId,
      String namaItem,
      int qty,
      String unit,
      int harga
      ) async {
    await db.updateTakingOrder(
      idMA,
      itemId,
      namaItem,
      qty,
      unit,
      harga,
    );
    await getTakingOrder();
    calculateTotalPayment();
  }

  addTakingOrder(
    String itemId,
    String namaItem,
    int qty,
    String unit,
    int harga,
  ) async {
    await db.insertTakingOrder(
      idMA,
      itemId,
      namaItem,
      qty,
      unit,
      harga,
    );
    await getTakingOrder();
    calculateTotalPayment();
  }

  calculateTotalPayment() {
    totalPayment = 0;
    for (var item in takingOrders) {
      totalPayment += item.price;
    }
    nominalController.text = Utils.formatCurrency(totalPayment.toString());
    update();
  }

  getTakingOrder() async {
    takingOrders = await db.getTakingOrder(idMA);
    update();
  }

  inserTtd() async {
    await db.updateTtd(idMA, ttdPath);
    ttdPath = await db.getTtd(idMA) ?? '';
  }

  savePayment(int amount) async {
    var dataPayment = {
      'id_marketing_activity': idMA,
      'noinvoice': '',
      'nocollect': '',
      'amount': amount,
      'type': jenisPembayaran[selectedJenisPembayaran],
      'status': getStatuCollection(amount),
    };
    if (listCollection.isEmpty) {
      await db.insertCollection(dataPayment);
      await getCollection();
      Get.snackbar('Success', 'Data berhasil disimpan');
      return;
    }
    await db.updateCollection(listCollection.first.id!, dataPayment);
    Get.snackbar('Success', 'Data berhasil diperbarui');
    await getCollection();
  }

  Future<bool> isNetworkAvailable() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi);
  }

  getCollection() async {
    listCollection = await db.getCollections(idMA);
    nominalController.text =
        Utils.formatCurrency(listCollection.first.amount.toString());
    update();
  }

  String getStatuCollection(int amount) {
    if (amount == totalPayment) {
      return 'collected';
    }
    if (amount < totalPayment) {
      return 'partial collected';
    }
    if (amount == 0) {
      return 'not collected';
    }
    return 'not collected';
  }

  checkIn(double lat, double lon) async {
    var userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
    var dataOutlet = {
      'latitude': lat,
      'longitude': lon,
    };
    customerId = await db.addCustomerCanvasing(dataOutlet);
    box.put(HiveKeys.selectedCustID, customerId);
    var dataMA = {
      'user_id': userData.id,
      'cust_id': customerId,
      'waktu_ci': DateTime.now().toIso8601String(),
      'jenis': Call.canvasing,
      'lat_ci': lat,
      'lon_ci': lon,
    };
    idMA = await db.checkInCanvasing(dataMA);
    box.put(HiveKeys.idMa, idMA);
  }

  cancelCanvasing() async {
    await db.deleteMarketingActivity(idMA);
    await db.deleteCustomerCanvasing(customerId);
    for (var item in takingOrders) {
      await db.deleteTakingOrder(idMA, item.itemid);
    }
    for (var item in listCollection) {
      await db.deleteCollection(item.id!);
    }
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
    // var ctx = Get.put(HomeController());
    // ctx.checkOut(getStatusCall(), idMA);
    print('check out');
    Position? position = await Geolocator.getCurrentPosition();
    double lat = position.latitude;
    double lon = position.longitude;
    print('lat: $lat, lon: $lon');
    await db.checkOut(
      idMA,
      lat,
      lon,
      getStatusCall(),
      Call.canvasing,
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
    if (listCollection.isEmpty) {
      return false;
    }
    return listCollection.every((element) => element.status == 'collected');
  }

  Future<bool> isUseMockLocation() async {
    var isMock = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((value) => value.isMocked);
    return isMock;
  }

  isLocationServiceEnabled() async {
    var isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
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
    } else {
      isUseMockLocation().then((value) {
        if (value) {
          showWarningDialog();
        } else {
          var args = Get.arguments;
          if (args != null) {
            customerId = args['CustID'];
            idMA = args['id'];
            namaController.text = args['nama_outlet'];
            pemilikController.text = args['nama_owner'];
            telpController.text = args['no_hp'];
            latitude = args['latitude'];
            longitude = args['longitude'];
            ttdPath = args['ttd_path'];
            outletImagePath = args['image_path'];
            getTakingOrder();
            calculateTotalPayment();
            getCollection();
          } else {
            getCurrentLocation().then((position) {
              checkIn(position!.latitude, position.longitude);
            });
          }
        }
      });
    }
  }

  showWarningDialog() {
    Get.defaultDialog(
      title: 'Warning',
      content: const Text('Anda menggunakan lokasi palsu'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    getListItem();
    isLocationServiceEnabled();
  }

  @override
  void onClose() {
    namaController.dispose();
    pemilikController.dispose();
    telpController.dispose();
    alamatController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      print("App is in background");
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
