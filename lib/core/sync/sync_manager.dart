import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/api/api_client.dart';
import 'package:uapp/modules/marketing/model/cust_active.dart';
import 'package:uapp/modules/marketing/model/cust_top.dart';
import 'package:uapp/modules/marketing/model/invoice_model.dart';
import 'package:uapp/modules/marketing/model/master_item.dart';
import 'package:uapp/modules/marketing/model/price_list.dart';
import 'package:uapp/modules/marketing/model/unit_set.dart';

class SyncManager {
  final apiClient = MarketingApiClient();
  final db = MarketingDatabase();

  Future<void> syncData() async {
    await Future.wait([
      syncListItem(),
      syncListInvoice(),
      syncListCustomer(),
      syncListUnitSet(),
      syncListCustTop(),
      syncPriceList(),
    ]);
  }

  Future<void> syncListItem() async {
    final box = await Hive.openBox<MasterItem>(HiveKeys.masterItemBox);
    await box.clear();
    final response = await apiClient.postRequest(
      method: 'get_list_item',
      additionalData: {'nik': Utils.getUserData().id},
    );
    if (response.success) {
      var items =
          (response.data as List).map((e) => MasterItem.fromJson(e)).toList();
      for (var element in items) {
        box.add(MasterItem(
          itemID: element.itemID,
          description: element.description,
          salesUnit: element.salesUnit,
          salesPrice: element.salesPrice,
          unitSetID: element.unitSetID,
        ));
      }
    }
  }

  Future<void> syncListInvoice() async {
    await db.delete('invoice', '1=1', []);
    final response =
        await apiClient.postRequest(method: 'get_unbilled_invoice');
    if (response.success) {
      var invoiceList =
          (response.data as List).map((e) => BelumInvoice.fromJson(e)).toList();
      for (var element in invoiceList) {
        await db.insert('invoice', element.toJson());
      }
    }
  }

  Future<void> syncListCustomer() async {
    final box = await Hive.openBox<CustActive>(HiveKeys.custActiveBox);
    await box.clear();
    final bodyRequest = {'collectorid': Utils.getUserData().colectorid};
    final response = await apiClient.postRequest(
      method: 'get_cust_active',
      additionalData: bodyRequest,
    );
    if (response.success) {
      var items =
          (response.data as List).map((e) => CustActive.fromJson(e)).toList();
      for (var element in items) {
        box.add(CustActive(
          custID: element.custID,
          custName: element.custName,
          address: element.address,
        ));
      }
    }
  }

  Future<void> syncListUnitSet() async {
    final box = await Hive.openBox<UnitSet>(HiveKeys.unitSetBox);
    await box.clear();
    final response = await apiClient.postRequest(method: 'get_unit_set');
    if (response.success) {
      var items =
          (response.data as List).map((e) => UnitSet.fromJson(e)).toList();
      for (var element in items) {
        box.add(UnitSet(
          unitSetID: element.unitSetID,
          conversion: element.conversion,
          unitID: element.unitID,
        ));
      }
    }
  }

  Future<void> syncListCustTop() async {
    final box = await Hive.openBox<CustTop>(HiveKeys.custTopBox);
    await box.clear();
    final response = await apiClient.postRequest(method: 'get_cust_top');
    if (response.success) {
      var items =
          (response.data as List).map((e) => CustTop.fromJson(e)).toList();
      for (var element in items) {
        box.add(CustTop(
          custID: element.custID,
          topID: element.topID,
        ));
      }
    }
  }

  Future<void> syncPriceList() async {
    if (!Hive.isBoxOpen(HiveKeys.priceListBox)) {
      await Hive.openBox<PriceList>(HiveKeys.priceListBox);
    }
    final box = Hive.box<PriceList>(HiveKeys.priceListBox);
    await box.clear();
    final response = await apiClient.postRequest(
      method: 'get_price_list',
      additionalData: {'nik': Utils.getUserData().id},
    );
    if (response.success) {
      var items =
          (response.data as List).map((e) => PriceList.fromJson(e)).toList();
      for (var element in items) {
        box.add(PriceList(
          itemID: element.itemID,
          unitID: element.unitID,
          qty: element.qty,
          unitPrice: element.unitPrice,
          topID: element.topID,
        ));
      }
    }
  }
}
