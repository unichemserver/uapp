import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/models/canvasing.dart';
import 'package:uapp/models/collection.dart';
import 'package:uapp/models/item.dart';
import 'package:uapp/models/to.dart';
import 'package:uapp/models/user.dart';
import 'package:uapp/modules/home/home_controller.dart';

class CanvasingController extends GetxController {
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
  int selectedJenisPembayaran = -1;
  int canvasingIndex = 0;
  int totalPayment = 0;
  int idMA = 0;
  double? latitude;
  double? longitude;
  String customerId = '';
  String outletImagePath = '';
  String proofOfPayment = '';
  String ttdPath = '';

  void selectJenisPembayaran(int index) {
    selectedJenisPembayaran = index;
    update();
  }

  void getListItem() async {
    bool iUnichem = box.get(HiveKeys.baseURL).contains('unichem');
    if (iUnichem) {
      items.clear();
      items.add(Item(
        itemid: 'BJW8-RP-0250G-00B10-DAU002',
        description: 'Garam Daun 250 gr @10 Kg/Ball (Serbet)',
        unitsetid: 'BAL10',
        inventoryUnit: 'KG',
      ));
      items.add(Item(
        itemid: 'XXXX-XX-XXXXX-XXXXX-XXXXX',
        description: 'Garam Daun 250 Gr @4 Pcs/Paket',
        unitsetid: 'PCS4',
        inventoryUnit: 'PCS',
      ));
      update();
      return;
    }
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

  updateCustomerData(
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
    await db.updateCustomerCanvasing(canvasingData);
  }

  Future<Position?> getCurrentLocation() async {
    Position? positon = await Geolocator.getCurrentPosition();
    latitude = positon.latitude;
    longitude = positon.longitude;

    String adress = await getAddress(positon.latitude, positon.longitude);
    setOutletAddress(adress);
    return positon;
  }

  Future<String> getAddress(double lat, lon) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    String street = placemarks[0].street ?? '';
    String subLocality = placemarks[0].subLocality ?? '';
    String locality = placemarks[0].locality ?? '';
    return '$street\n$subLocality, $locality';
  }

  void isFirstTimeCanvasing(double lat, double lon) async {
    bool isFirstTime =
        box.get(HiveKeys.isFirstTimeCanvasing, defaultValue: true);
    if (isFirstTime) {
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
      print('idMA: $idMA');
      box.put(HiveKeys.idMa, idMA);
      box.put(HiveKeys.isFirstTimeCanvasing, false);
    } else {
      idMA = box.get(HiveKeys.idMa);
      customerId = box.get(HiveKeys.selectedCustID);
      canvasing = await db.getCanvasing(customerId);
      setOutletAddress(canvasing?.alamat ?? '');
      outletImagePath = canvasing?.imagePath ?? '';
      namaController.text = canvasing?.namaOutlet ?? '';
      pemilikController.text = canvasing?.namaOwner ?? '';
      telpController.text = canvasing?.noTelp ?? '';
      latitude = canvasing?.latitude;
      longitude = canvasing?.longitude;
      ttdPath = await db.getTtd(idMA) ?? '';
      await getTakingOrder();
      calculateTotalPayment();
      getCollection();
      update();
    }
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
    // totalPayment = takingOrders.length;
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

  checkOut() async {
    var ctx = Get.put(HomeController());
    ctx.checkOut(getStatusCall(), idMA);
    box.put(HiveKeys.isFirstTimeCanvasing, true);
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

  @override
  void onInit() {
    super.onInit();
    getListItem();
    getCurrentLocation().then((position) =>
        isFirstTimeCanvasing(position!.latitude, position.longitude));
  }

  @override
  void onClose() {
    namaController.dispose();
    pemilikController.dispose();
    telpController.dispose();
    alamatController.dispose();
    super.onClose();
  }
}
