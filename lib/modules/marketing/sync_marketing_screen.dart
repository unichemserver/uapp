import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/hive/hive_service.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/log.dart';
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
  bool isRefreshing = false;
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
    try {
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
        Log.d('Items synced successfully');
      } else {
        // Tampilkan snackbar jika gagal
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal sync Items: ${response.message}'),
              backgroundColor: Colors.red[700],
            ),
          );
        }
      }
    } catch (e) {
      // Tampilkan snackbar jika terjadi exception
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi error saat sync Items: $e'),
            backgroundColor: Colors.red[700],
          ),
        );
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
    Log.d(response.data.toString());
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

  Future<void> refreshAllData() async {
    setState(() {
      isRefreshing = true;
    });
    
    try {
      await Future.wait([
        getData(),
        getListItemLength(),
        getListInvoiceLength(),
        getListCustomerLength(),
        getListUnitSetLength(),
        getListCustTopLength(),
        getListPriceListLength(),
      ]);
    } finally {
      setState(() {
        isRefreshing = false;
      });
    }
  }

  Future<void> syncSelectedData(String title, Future<void> Function() syncAction) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Syncing $title',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    try {
      await syncAction();
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(8),
          backgroundColor: Colors.green[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Text('$title synced successfully'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      
      refreshAllData();
    } catch (e) {
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(8),
          backgroundColor: Colors.red[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Text('Failed to sync $title'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _syncAllMarketingActivity() async {
    if (!isNeedSync) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(8),
          backgroundColor: Colors.blue[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 12),
              Text('No data needs to be synchronized'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            const Text(
              'Syncing Marketing Activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    try {
      await syncApi.syncMarketingActivity();
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(8),
          backgroundColor: Colors.green[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Marketing activity synced successfully'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      
      refreshAllData();
    } catch (e) {
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(8),
          backgroundColor: Colors.red[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Text('Failed to sync marketing activity'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
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
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Marketing'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isRefreshing ? null : refreshAllData,
            tooltip: 'Refresh Data',
          ),
          // IconButton(
          //   icon: const Icon(Icons.sync),
          //   onPressed: _syncAllMarketingActivity,
          //   tooltip: 'Sync All Activities',
          // ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshAllData,
        child: isRefreshing 
        ? const Center(child: CircularProgressIndicator())
        : CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: colorScheme.primary.withOpacity(0.05),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSyncStatusCard(),
                    const SizedBox(height: 16),
                    _buildLastSyncInfo(),
                  ],
                ),
              ),
            ),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      context, 
                      'Marketing Activities',
                      'Data will be automatically deleted after 7 days',
                      Icons.history,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildActivityCards(),
              ),
            ),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildSectionHeader(
                  context, 
                  'Master Data',
                  'Sync to update local database',
                  Icons.storage,
                ),
              ),
            ),
            
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildListDelegate([
                  _buildDataSyncCard('Items', dataItemLength, 
                    Icons.inventory_2_outlined, syncListItem),
                  _buildDataSyncCard('Invoices', dataInvoiceLength, 
                    Icons.receipt_outlined, syncListInvoice),
                  _buildDataSyncCard('Customers', dataCustomerLength, 
                    Icons.people_outline, syncListCustomer),
                  _buildDataSyncCard('Unit Sets', dataUnitSetLength, 
                    Icons.category_outlined, syncListUnitSet),
                  _buildDataSyncCard('Customer TOP', dataCustTopLength, 
                    Icons.assignment_outlined, syncListCustTop),
                  _buildDataSyncCard('Price Lists', dataPriceListLength, 
                    Icons.attach_money_outlined, syncPriceList),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatusCard() {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isNeedSync 
                  ? Colors.orange.withOpacity(0.2) 
                  : Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isNeedSync ? Icons.sync_problem : Icons.check_circle_outline,
                color: isNeedSync ? Colors.orange : Colors.green,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isNeedSync ? 'Pending Sync' : 'All Data Synced',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isNeedSync 
                      ? 'There are data that need to be sync' 
                      : 'All records are up to date',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isNeedSync)
              ElevatedButton.icon(
                onPressed: _syncAllMarketingActivity,
                icon: const Icon(Icons.sync, size: 18),
                label: const Text('Sync Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastSyncInfo() {
    final int? syncTime = HiveService.getTimerSyncMkt();
    if (syncTime == null) return const SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(
          Icons.access_time, 
          size: 14,
          color: Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          'Last auto-sync: $minutes min $seconds sec ago',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, 
    String title, 
    [String? subtitle, IconData? icon]
  ) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActivityCards() {
    return Column(
      children: [
        _buildActivityCard('On Route', onRoute, Icons.directions_car_outlined),
        const SizedBox(height: 12),
        _buildActivityCard('Customer Active', customerActive, Icons.people_outline),
        const SizedBox(height: 12),
        _buildActivityCard('New Opening Outlet', newOpeningOutlet, Icons.storefront_outlined),
        const SizedBox(height: 12),
        _buildActivityCard('Canvasing', canvasing, Icons.search_outlined),
      ],
    );
  }

  Widget _buildActivityCard(String title, List<MarketingActivity> activities, IconData icon) {
    final pendingCount = activities.where((e) => 
      e.statusSync == 0 && e.waktuCo != null).length;
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${activities.length})',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          subtitle: pendingCount > 0
              ? Text(
                  '$pendingCount records pending sync',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 13,
                  ),
                )
              : null,
          trailing: pendingCount > 0
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sync,
                        color: Colors.orange[700],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Pending',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : const Icon(Icons.expand_more),
          children: activities.isEmpty
              ? [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No records found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ]
              : activities.map((activity) {
                  final bool needsSync = activity.statusSync == 0 && activity.waktuCo != null;
                  
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: needsSync 
                          ? Colors.orange.withOpacity(0.05) 
                          : Colors.grey.withOpacity(0.05),
                      border: Border.all(
                        color: needsSync 
                            ? Colors.orange.withOpacity(0.3) 
                            : Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: needsSync
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                        child: Icon(
                          needsSync ? Icons.sync : Icons.check_circle,
                          color: needsSync ? Colors.orange : Colors.green,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        activity.custId ?? 'No Customer ID',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        '${activity.waktuCi ?? 'No check-in'} - ${activity.waktuCo ?? 'No check-out'}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: needsSync
                          ? Chip(
                              label: const Text('Pending'),
                              labelStyle: TextStyle(
                                color: Colors.orange[700],
                                fontSize: 12,
                              ),
                              backgroundColor: Colors.orange.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            )
                          : Chip(
                              label: const Text('Synced'),
                              labelStyle: TextStyle(
                                color: Colors.green[700],
                                fontSize: 12,
                              ),
                              backgroundColor: Colors.green.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                    ),
                  );
                }).toList(),
        ),
      ),
    );
  }

  Widget _buildDataSyncCard(String title, int count, IconData icon, Future<void> Function() syncAction) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => syncSelectedData(title, syncAction),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Tambahkan ini untuk menghindari overflow
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$count data',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.all(4),
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(4),
                  //   ),
                  //   child: Icon(
                  //     Icons.sync,
                  //     color: Theme.of(context).colorScheme.primary,
                  //     size: 18,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}