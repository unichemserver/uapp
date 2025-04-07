import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/hive/hive_service.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/api/api_client.dart';
import 'package:uapp/modules/marketing/api/sync_marketing_activity_api.dart';
import 'package:uapp/modules/marketing/model/cust_active.dart';
import 'package:uapp/modules/marketing/model/cust_top.dart';
import 'package:uapp/modules/marketing/model/invoice_model.dart';
import 'package:uapp/modules/marketing/model/marketing_activity.dart';
import 'package:uapp/modules/marketing/model/master_item.dart';
import 'package:uapp/modules/marketing/model/price_list.dart';
import 'package:uapp/modules/marketing/model/unit_set.dart';

class SyncMarketingScreen extends StatefulWidget {
  const SyncMarketingScreen({super.key});

  @override
  State<SyncMarketingScreen> createState() => _SyncMarketingScreenState();
}

class _SyncMarketingScreenState extends State<SyncMarketingScreen> {
  final db = MarketingDatabase();
  final apiClient = MarketingApiClient();
  late SyncMarketingActivityApi syncApi;
  bool isNeedSync = false;
  int dataItemLength = 0;
  int dataInvoiceLength = 0;
  int dataCustomerLength = 0;
  int dataUnitSetLength = 0;
  int dataCustTopLength = 0;
  int dataPriceListLength = 0;
  List<MarketingActivity> onRoute = [];
  List<MarketingActivity> customerActive = [];
  List<MarketingActivity> newOpeningOutlet = [];
  List<MarketingActivity> canvasing = [];
  Timer? syncTimer;
  int minutes = 0;
  int seconds = 0;

  Future<void> getData() async {
    onRoute = await db.query('marketing_activity',
        where: 'jenis = ?',
        whereArgs: [
          Call.onroute
        ]).then(
        (value) => value.map((e) => MarketingActivity.fromJson(e)).toList());
    customerActive = await db.query('marketing_activity',
        where: 'jenis = ?',
        whereArgs: [
          Call.custactive
        ]).then(
        (value) => value.map((e) => MarketingActivity.fromJson(e)).toList());
    newOpeningOutlet = await db.query('marketing_activity',
        where: 'jenis = ?',
        whereArgs: [
          Call.noo
        ]).then(
        (value) => value.map((e) => MarketingActivity.fromJson(e)).toList());
    canvasing = await db.query('marketing_activity',
        where: 'jenis = ?',
        whereArgs: [
          Call.canvasing
        ]).then(
        (value) => value.map((e) => MarketingActivity.fromJson(e)).toList());
    // loop in every list to check if there is any data that need to be sync
    isNeedSync = onRoute.any((element) =>
            (element.statusSync == 0 && element.waktuCo != null)) ||
        customerActive.any((element) =>
            (element.statusSync == 0 && element.waktuCo != null)) ||
        newOpeningOutlet.any((element) =>
            (element.statusSync == 0 && element.waktuCo != null)) ||
        canvasing.any(
            (element) => (element.statusSync == 0 && element.waktuCo != null));
    setState(() {});
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

  Future<void> getListItemLength() async {
    final box = await Hive.openBox<MasterItem>(HiveKeys.masterItemBox);
    final items = box.values.map((e) => e).toList();
    setState(() {
      dataItemLength = items.length;
    });
  }

  Future<void> getListInvoiceLength() async {
    final res = await db.query('invoice');
    setState(() {
      dataInvoiceLength = res.length;
    });
  }

  Future<void> getListCustomerLength() async {
    final box = await Hive.openBox<CustActive>(HiveKeys.custActiveBox);
    final items = box.values.map((e) => e).toList();
    setState(() {
      dataCustomerLength = items.length;
    });
  }

  Future<void> getListUnitSetLength() async {
    final box = await Hive.openBox<UnitSet>(HiveKeys.unitSetBox);
    final items = box.values.map((e) => e).toList();
    setState(() {
      dataUnitSetLength = items.length;
    });
  }

  Future<void> getListCustTopLength() async {
    final box = await Hive.openBox<CustTop>(HiveKeys.custTopBox);
    final items = box.values.map((e) => e).toList();
    setState(() {
      dataCustTopLength = items.length;
    });
  }

  Future<void> getListPriceListLength() async {
    final box = await Hive.openBox<PriceList>(HiveKeys.priceListBox);
    final items = box.values.map((e) => e).toList();
    setState(() {
      dataPriceListLength = items.length;
    });
  }

  void _updateTime(int syncTime) {
    setState(() {
      final DateTime syncDate = DateTime.fromMillisecondsSinceEpoch(syncTime);
      final Duration diff = DateTime.now().difference(syncDate);
      minutes = diff.inMinutes;
      seconds = diff.inSeconds.remainder(60);
    });
  }

  void _startSyncTimer() {
    final int? syncTime = HiveService.getTimerSyncMkt();
    if (syncTime != null) {
      _updateTime(syncTime);
      syncTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _updateTime(syncTime);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    syncApi = SyncMarketingActivityApi(api: apiClient, db: db);
    getData();
    getListItemLength();
    getListInvoiceLength();
    getListCustomerLength();
    getListUnitSetLength();
    getListCustTopLength();
    getListPriceListLength();
    _startSyncTimer();
  }

  @override
  void dispose() {
    syncTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Marketing'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              if (isNeedSync) {
                Utils.showLoadingDialog(context);
                syncApi.syncMarketingActivity().then((_) {
                  getData();
                  Navigator.of(context).pop();
                });
              } else {
                Utils.showSnackbar(
                  context,
                  'Tidak ada data yang perlu disinkronisasi',
                );
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Align(alignment: Alignment.topRight, child: _buildTimerSync()),
          _buildSectionHeader(context, 'Data Kunjungan',
              'Data kunjungan akan dihapus otomatis setelah 7 hari'),
          _buildExpansionTile('On Route', onRoute),
          _buildExpansionTile('Customer Active', customerActive),
          _buildExpansionTile('New Opening Outlet', newOpeningOutlet),
          _buildExpansionTile('Canvasing', canvasing),
          const Divider(),
          _buildSectionHeader(context, 'Data Lainnya'),
          _buildDataSyncTile(
              'Data Item', dataItemLength, syncListItem, getListItemLength),
          _buildDataSyncTile('Data Invoice', dataInvoiceLength, syncListInvoice,
              getListInvoiceLength),
          _buildDataSyncTile('Data Customer Active', dataCustomerLength,
              syncListCustomer, getListCustomerLength),
          _buildDataSyncTile('Data Unit Set', dataUnitSetLength,
              syncListUnitSet, getListUnitSetLength),
          _buildDataSyncTile('Data TOP Customer', dataCustTopLength,
              syncListCustTop, getListCustTopLength),
          _buildDataSyncTile('Data Price List', dataPriceListLength,
              syncPriceList, getListPriceListLength),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title,
      [String? subtitle]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        if (subtitle != null) ...[
          const SizedBox(height: 8.0),
          Text(subtitle,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Colors.red)),
        ],
      ],
    );
  }

  Widget _buildExpansionTile(String title, List<dynamic> items) {
    return ExpansionTile(
      title: Text(title),
      children: items
          .map((e) => ListTile(
                title: Text(e.custId ?? ''),
                subtitle: Text('${e.waktuCi ?? ''} - ${e.waktuCo ?? ''}'),
                trailing: IconButton(
                  icon: Icon(e.statusSync == 1 ? Icons.check : Icons.sync),
                  onPressed: (e.statusSync == 1 || e.waktuCo == null)
                      ? null
                      : () {
                          // Tambah logika sync data per item di sini
                        },
                ),
              ))
          .toList(),
    );
  }

  Widget _buildDataSyncTile(String title, int dataCount,
      Future<void> Function() syncAction, void Function() refreshData) {
    return ListTile(
      title: Text(title),
      subtitle: Text('Total data: $dataCount'),
      trailing: IconButton(
        icon: const Icon(Icons.sync),
        onPressed: () {
          Utils.showLoadingDialog(context);
          syncAction().then((_) {
            refreshData();
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }

  Widget _buildTimerSync() {
    final int? syncTime = HiveService.getTimerSyncMkt();
    if (syncTime == null) return const SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        Text(
          'Terakhir sinkronisasi otomatis:',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const SizedBox(width: 4),
        Text(
          '$minutes menit $seconds detik yang lalu',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
