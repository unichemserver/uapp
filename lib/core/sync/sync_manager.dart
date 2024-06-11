import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/sync/sync_api_service.dart';
import 'package:uapp/core/utils/log.dart';

class SyncManager {
  final SyncApiService apiService;
  final DatabaseHelper db;

  SyncManager(this.apiService, this.db);

  Future<void> syncAll({void Function(String status)? onStatus}) async {
    await syncRute(onStatus: onStatus);
    await syncItem(onStatus: onStatus);
    await syncInvoice(onStatus: onStatus);
    await syncUser(onStatus: onStatus);
    await syncCustomer(onStatus: onStatus);
  }

  Future<void> syncRute({
    void Function(String status)? onStatus,
  }) async {
    try {
      onStatus!('Mengambil data rute dari server');
      List<dynamic> dataApi = await apiService.fetchRute();
      onStatus('Mengambil data rute dari lokal');
      List<Map<String, dynamic>> dataLocal = await db.getData('rute');
      Map<String, Map<String, dynamic>> localDataMap = {
        for (var item in dataLocal) item['id_rute']: item
      };

      for (var item in dataApi) {
        onStatus('Memproses data rute ${item['id_rute']}');
        var localData = localDataMap[item['id_rute']];
        if (localData == null) {
          onStatus('Menyimpan data rute ${item['id_rute']}');
          await db.insertData('rute', item);
        } else {
          bool needsUpdate = false;
          for (var key in item.keys) {
            if (item[key] != localData[key]) {
              needsUpdate = true;
              break;
            }
          }
          if (needsUpdate) {
            onStatus('Memperbarui data rute ${item['id_rute']}');
            await db.updateData(
              'rute',
              item,
              'id_rute',
              item['id_rute'],
            );
          }
        }
      }
    } catch (e) {
      onStatus!('Error: $e');
      Log.d('Error during synchronization rute: $e');
    }
  }

  Future<void> syncItem({
    void Function(String status)? onStatus,
  }) async {
    try {
      onStatus!('Mengambil data item dari server');
      List<dynamic> dataApi = await apiService.fetchItem();
      onStatus('Mengambil data item dari lokal');
      List<Map<String, dynamic>> dataLocal = await db.getData('item');

      Map<String, Map<String, dynamic>> localDataMap = {
        for (var item in dataLocal) item['itemid']: item
      };

      for (var item in dataApi) {
        onStatus('Memproses data item ${item['itemid']}');
        var localData = localDataMap[item['itemid']];

        if (localData == null) {
          await db.insertData('item', item);
        } else {
          bool needsUpdate = false;

          for (var key in item.keys) {
            if (item[key] != localData[key]) {
              needsUpdate = true;
              break;
            }
          }

          if (needsUpdate) {
            onStatus('Memperbarui data item ${item['itemid']}');
            await db.updateData(
              'item',
              item,
              'itemid',
              item['itemid'],
            );
          }
        }
      }
    } catch (e) {
      onStatus!('Error: $e');
      Log.d('Error during synchronization item: $e');
    }
  }

  Future<void> syncInvoice({
    void Function(String status)? onStatus,
  }) async {
    try {
      onStatus!('Mengambil data invoice dari server');
      List<dynamic> dataApi = await apiService.fetchInvoice();
      onStatus('Mengambil data invoice dari lokal');
      List<Map<String, dynamic>> dataLocal = await db.getData('invoice');
      Map<String, Map<String, dynamic>> localDataMap = {
        for (var item in dataLocal) item['noinvoice']: item
      };
      for (var item in dataApi) {
        onStatus('Memproses data invoice ${item['noinvoice']}');
        var localData = localDataMap[item['noinvoice']];
        if (localData == null) {
          onStatus('Menyimpan data invoice ${item['noinvoice']}');
          await db.insertData('invoice', item);
        } else {
          bool needsUpdate = false;
          for (var key in item.keys) {
            if (item[key] != localData[key]) {
              needsUpdate = true;
              break;
            }
          }
          if (needsUpdate) {
            onStatus('Memperbarui data invoice ${item['noinvoice']}');
            await db.updateData(
              'invoice',
              item,
              'noinvoice',
              item['noinvoice'],
            );
          }
        }
      }
    } catch (e) {
      onStatus!('Error: $e');
      Log.d('Error during synchronization invoice: $e');
    }
  }

  Future<void> syncUser({
    void Function(String status)? onStatus,
  }) async {
    try {
      onStatus!('Mengambil data user dari server');
      List<dynamic> dataApi = await apiService.fetchUser();
      onStatus('Mengambil data user dari lokal');
      List<Map<String, dynamic>> dataLocal = await db.getData('user');
      Map<String, Map<String, dynamic>> localDataMap = {
        for (var item in dataLocal) item['id_user']: item
      };
      for (var item in dataApi) {
        onStatus('Memproses data user ${item['id_user']}');
        var localData = localDataMap[item['id_user']];
        if (localData == null) {
          onStatus('Menyimpan data user ${item['id_user']}');
          await db.insertData('user', item);
        } else {
          bool needsUpdate = false;
          for (var key in item.keys) {
            if (item[key] != localData[key]) {
              needsUpdate = true;
              break;
            }
          }
          if (needsUpdate) {
            onStatus('Memperbarui data user ${item['id_user']}');
            await db.updateData(
              'user',
              item,
              'id_user',
              item['id_user'],
            );
          }
        }
      }
    } catch (e) {
      onStatus!('Error: $e');
      Log.d('Error during synchronization user: $e');
    }
  }

  Future<void> syncCustomer({
    void Function(String status)? onStatus,
  }) async {
    try {
      onStatus!('Mengambil data customer dari server');
      List<dynamic> dataApi = await apiService.fetchCustomer();
      onStatus('Mengambil data customer dari lokal');
      List<Map<String, dynamic>> dataLocal = await db.getData('customer');
      Map<String, Map<String, dynamic>> localDataMap = {
        for (var item in dataLocal) item['CustID']: item
      };
      for (var item in dataApi) {
        onStatus('Memproses data customer ${item['CustID']}');
        var localData = localDataMap[item['CustID']];
        if (localData == null) {
          onStatus('Menyimpan data customer ${item['CustID']}');
          await db.insertData('customer', item);
        } else {
          bool needsUpdate = false;
          for (var key in item.keys) {
            if (item[key] != localData[key]) {
              needsUpdate = true;
              break;
            }
          }
          if (needsUpdate) {
            onStatus('Memperbarui data customer ${item['CustID']}');
            await db.updateData(
              'customer',
              item,
              'CustID',
              item['CustID'],
            );
          }
        }
      }
    } catch (e) {
      onStatus!('Error: $e');
      Log.d('Error during synchronization customer: $e');
    }
  }
}
