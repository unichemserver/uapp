import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/modules/marketing/model/cust_active.dart';
import 'package:uapp/modules/marketing/model/cust_top.dart';
import 'package:uapp/modules/marketing/model/master_item.dart';
import 'package:uapp/modules/marketing/model/price_list.dart';
import 'package:uapp/modules/marketing/model/unit_set.dart';

class HiveService {
  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox(HiveKeys.appBox);
    if (!Hive.isAdapterRegistered(CustActiveAdapter().typeId)) {
      Hive.registerAdapter(CustActiveAdapter());
    }
    if (!Hive.isAdapterRegistered(MasterItemAdapter().typeId)) {
      Hive.registerAdapter(MasterItemAdapter());
    }
    if (!Hive.isAdapterRegistered(UnitSetAdapter().typeId)) {
      Hive.registerAdapter(UnitSetAdapter());
    }
    if (!Hive.isAdapterRegistered(CustTopAdapter().typeId)) {
      Hive.registerAdapter(CustTopAdapter());
    }
    if (!Hive.isAdapterRegistered(PriceListAdapter().typeId)) {
      Hive.registerAdapter(PriceListAdapter());
    }
  }

  static Future<List<PriceList>> getPriceList() async {
    final box = await Hive.openBox<PriceList>(HiveKeys.priceListBox);
    final items =
        box.values.map((e) => PriceList.fromJson(e.toJson())).toList();
    return items;
  }

  static void setTimerSyncMkt(int time) {
    final box = Hive.box(HiveKeys.appBox);
    box.put(HiveKeys.timerSyncMkt, time);
  }

  static int? getTimerSyncMkt() {
    final box = Hive.box(HiveKeys.appBox);
    return box.get(HiveKeys.timerSyncMkt);
  }

  static Future<List<MasterItem>> getListItem() async {
    final box = await Hive.openBox<MasterItem>(HiveKeys.masterItemBox);
    final items =
        box.values.map((e) => MasterItem.fromJson(e.toJson())).toList();
    return items;
  }

  static String baseUrl() {
    final box = Hive.box(HiveKeys.appBox);
    return box.get(HiveKeys.baseURL);
  }
}
