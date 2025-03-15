import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/modules/marketing/api/api_client.dart';
import 'package:uapp/modules/marketing/model/noo_activity.dart';
import 'package:uapp/core/notification/notification.dart';
import 'package:uapp/core/notification/notif_id.dart';

class SyncNooActivityApi {
  final MarketingApiClient api;
  final MarketingDatabase db;

  SyncNooActivityApi({
    required this.api,
    required this.db,
  });

  Future<void> syncNooActivity({String? idNoo}) async {
    Log.d('Syncing NOO activity...');
    final data = await _getNooActivityById(idNoo!);
    if (data.isEmpty) return;
    for (final item in data) {
      var idNoo = item.idnoo;
      Log.d('Syncing NOO activity for ID $idNoo');
      await _uploadNooData(idNoo!);
      try {
        await db.update(
          'noo_activity',
          {'statussync': 1},
          'idnoo = ?',
          [idNoo],
        );
      } catch (e) {
        Log.d('Error syncing NOO activity for ID $idNoo: $e');
      }
    }
    showNotification(
      NotifId.MKT_SYNC_CH_ID,
      NotifId.MKT_SYNC_CH_NAME,
      NotifId.MKT_SYNC_ID,
      'NOO Terbaru',
      'Ada data NOO terbaru, segera Approve',
    );
  }

  Future<List<NooActivity>> _getNooActivityById(String idNoo) async {
    final nooActivity = await db.query(
      'noo_activity',
      where: 'idnoo = ?',
      whereArgs: [idNoo],
    );
    return nooActivity.map((json) => NooActivity.fromJson(json)).toList();
  }

  // Future<List<NooActivity>> _getUnsyncedNooActivity() async {
  //   final unsyncedNooActivity = await db.query(
  //     'noo_activity',
  //     where: 'statussync = ?',
  //     whereArgs: [0],
  //   );
  //   return unsyncedNooActivity.map((json) => NooActivity.fromJson(json)).toList();
  // }

  Future<void> _uploadNooData(String idNoo) async {
    var result = await db.query(
      'masternoo',
      where: 'status_sync = ? AND id = ?',
      whereArgs: [0, idNoo],
    );

    if (result.isEmpty) return;

    var nooAddress = await db.query('nooaddress', where: 'id_noo = ?', whereArgs: [idNoo]);
    var nooDocumentResult = await db.query('noodocument', where: 'id_noo = ?', whereArgs: [idNoo]);
    var nooSpesimen = await db.query('noospesimen', where: 'id_noo = ?', whereArgs: [idNoo]);

    var nooData = result.first;
    var nooDocument = nooDocumentResult.first;

    await api.postRequest(method: 'marketing_noo', additionalData: nooData);
    await _uploadMultipleRecords(nooAddress, 'insert_noo_address');
    await _uploadMultipleFileRecords(nooSpesimen, 'insert_noo_spesimen', ['ttd', 'stempel']);
    var docFileKeys = nooDocument.keys.where((key) => key != 'id' && key != 'id_noo').toList();
    await api.postFileRequest(
        method: 'insert_noo_document',
        additionalData: nooDocument,
        fileKeys: docFileKeys);
    await db.update(
      'masternoo',
      {'status_sync': 1},
      'id = ?',
      [idNoo],
    );
  }

  Future<void> _uploadMultipleRecords(List<Map<String, dynamic>> records, String method) async {
    for (var record in records) {
      await api.postRequest(method: method, additionalData: record);
    }
  }

  Future<void> _uploadMultipleFileRecords(List<Map<String, dynamic>> records, String method, List<String> fileKeys) async {
    for (var record in records) {
      await api.postFileRequest(method: method, additionalData: record, fileKeys: fileKeys);
    }
  }
}
