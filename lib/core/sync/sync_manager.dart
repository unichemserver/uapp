import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/database/local_database.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/sync/sync_api_service.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/models/user.dart';

class SyncManager {
  final SyncApiService apiService;
  final DatabaseHelper db;
  late User userData;

  SyncManager(this.apiService, this.db) {
    final box = Hive.box(HiveKeys.appBox);
    userData = User.fromJson(jsonDecode(box.get(HiveKeys.userData)));
  }

  Future<void> syncAll({void Function(String status)? onStatus}) async {
    List<Future<void>> syncTasks = [];

    syncTasks.add(
      syncData(
        'user',
        apiService.fetchUser,
        'id_user',
        onStatus: onStatus,
      ),
    );

    await Future.wait(syncTasks);
  }

  Future<void> syncData(
    String tableName,
    Future<List<dynamic>> Function() fetchApiData,
    String idKey, {
    void Function(String status)? onStatus,
  }) async {
    try {
      onStatus?.call('Mengambil data $tableName dari server');
      List<dynamic> dataApi = await fetchApiData();
      onStatus?.call('Mengambil data $tableName dari lokal');
      List<Map<String, dynamic>> dataLocal = await db.getData(tableName);

      Map<String, Map<String, dynamic>> localDataMap = {
        for (var item in dataLocal) item[idKey]: item
      };

      for (var item in dataApi) {
        onStatus?.call('Memproses data $tableName ${item[idKey]}');
        var localData = localDataMap[item[idKey]];

        if (localData == null) {
          onStatus?.call('Menyimpan data $tableName ${item[idKey]}');
          await db.insertData(tableName, item);
        } else {
          bool needsUpdate = false;
          for (var key in item.keys) {
            if (item[key] != localData[key]) {
              needsUpdate = true;
              break;
            }
          }

          if (needsUpdate) {
            onStatus?.call('Memperbarui data $tableName ${item[idKey]}');
            await db.updateData(tableName, item, idKey, item[idKey]);
          }
        }
      }
    } catch (e) {
      onStatus?.call('Error: $e');
      Log.d('Error during synchronization $tableName: $e');
    }
  }
}
