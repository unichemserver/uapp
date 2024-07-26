import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/hive/hive_service.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/notification.dart';
import 'package:uapp/modules/home/home_api.dart';

Future<void> initializeAlarmManager() async {
  await AndroidAlarmManager.initialize();
}

void scheduleUploadData() {
  const int alarmId = 0;
  AndroidAlarmManager.oneShot(
    const Duration(seconds: 1),
    alarmId,
    uploadDataMarketing,
    exact: true,
    wakeup: true,
  );
}

void scheduleUploadDataPeriodic() {
  const int alarmId = 0;
  AndroidAlarmManager.periodic(
    const Duration(minutes: 10),
    alarmId,
    uploadDataMarketing,
    exact: true,
    wakeup: true,
  );
}

void cancelUploadData() {
  const int alarmId = 0;
  AndroidAlarmManager.cancel(alarmId);
}

void uploadDataMarketing() async {
  await initHive();
  Hive.box(HiveKeys.appBox).put(HiveKeys.isSyncing, true);
  showNotification('Sinkronisasi Data', 'Data sedang disinkronisasi');
  final db = DatabaseHelper();
  final data = await db.getCanvasingList();
  if (data.isEmpty || data.every((element) => element['status_sync'] == 1)) {
    Hive.box(HiveKeys.appBox).put(HiveKeys.isSyncing, false);
    showNotification('Sinkronisasi Data', 'Tidak ada data yang perlu disinkronisasi');
    return;
  }
  List<dynamic> results = [];
  for (var item in data) {
    if (item['status_sync'] == 0 && item['waktu_co'] != null) {
      var idMa = item['id'];
      var result = await uploadReportData(db, idMa);
      results.add(result);
    }
  }
  Hive.box(HiveKeys.appBox).put(HiveKeys.isSyncing, false);
  print('Results: $results');
  if (results.contains(null) || results.isEmpty) {
    showNotification('Sinkronisasi Data', 'Terdapat data yang gagal disinkronisasi');
  } else {
    showNotification('Sinkronisasi Data', 'Data berhasil disinkronisasi');
  }
}

Future<String?> uploadReportData(
    DatabaseHelper db, int idMarketingActivity) async {
  var box = Hive.box(HiveKeys.appBox);
  var dataActivity = await db.getMarketingActivity(idMarketingActivity);
  // print('Data Activity: $dataActivity');
  var stockItemsDb = await db.getStockReports(idMarketingActivity);
  var stockItems = stockItemsDb.map((e) => e.toJson()).toList();
  // print('Stock Items: $stockItems');
  var competitorItemsDb = await db.getCompetitors(idMarketingActivity);
  var competitorItems = competitorItemsDb.map((e) => e.toJson()).toList();
  // print('Competitor Items: $competitorItems');
  var collectionItemsDb = await db.getCollections(idMarketingActivity);
  var collectionItems = collectionItemsDb.map((e) => e.toJson()).toList();
  // print('Collection Items: $collectionItems');
  var imageItems = await db.getImageItems(idMarketingActivity);
  // print('Image Items: $imageItems');
  var toItems = await db.getTakingOrder(idMarketingActivity);
  // print('Taking Order Items: ${toItems.map((e) => e.toMap()).toList()}');

  var jenisCall = dataActivity['jenis'];
  // print('Jenis Call: $jenisCall');
  Map<String, dynamic> reportData = dataActivity;
  if (jenisCall == Call.noo) {
    var customerId = box.get(HiveKeys.selectedCustID);
    var nooItem = await db.getNooById(int.parse(customerId));
    var custId = await HomeApi().uploadNooReport(
      nooItem.toJson(),
      box.get(HiveKeys.baseURL),
    );
    if (custId == 0) return null;
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
    // print('Test: ${canvasingItem.toJson()}');
    var custId = await HomeApi().uploadCanvasingReport(
      canvasingItem.toJson(),
      box.get(HiveKeys.baseURL),
    );
    if (custId == 0) return null;
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
  String? result = await HomeApi().uploadReport(
    idMarketingActivity.toString(),
    reportData,
    stockItems,
    competitorItems,
    collectionItems,
    imageItems,
    toItems.map((e) => e.toMap()).toList(),
    box.get(HiveKeys.baseURL),
  );
  if (result == null) return null;
  await db.updateMarketingActivityStatus(idMarketingActivity);
  return result;
}
