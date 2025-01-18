import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/notification/notif_id.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/notification/notification.dart';
import 'package:uapp/modules/marketing/api/api_client.dart';
import 'package:uapp/modules/marketing/model/canvasing_model.dart';
import 'package:uapp/modules/marketing/model/marketing_activity.dart';

class SyncMarketingActivityApi {
  final MarketingApiClient api;
  final MarketingDatabase db;

  SyncMarketingActivityApi({
    required this.api,
    required this.db,
  });

  Future<void> syncMarketingActivity() async {
    Log.d('Syncing marketing activity...');
    final data = await _getUnsyncedMarketingActivity();
    Log.d('Found ${data.length} unsynced marketing activity');
    if (data.isEmpty) return;
    for (final item in data) {
      var idMA = item.id;
      Log.d('Syncing marketing activity for ID $idMA');
      if (item.jenis == Call.noo) {
        await _uploadNooData(item.custId!);
      } else if (item.jenis == Call.canvasing) {
        await _uploadCanvasingData(item.custId!);
      }
      try {
        var reports = await Future.wait([
          _getReport('stock', idMA),
          _getReport('competitor', idMA),
          _getReport('display', idMA),
          _getReport('taking_order', idMA),
          _getReport('collection', idMA)
        ]);

        var uploadFutures = [
          _safeUploadReport('marketing_activity', [item.toMap()],
              fileKeys: ['foto_ci', 'ttd']),
          _safeUploadReport('marketing_report_stock', reports[0],
              fileKeys: ['image_path']),
          _safeUploadReport('marketing_report_competitor', reports[1]),
          _safeUploadReport('marketing_report_display', reports[2],
              fileKeys: ['image']),
          _safeUploadReport('marketing_report_to', reports[3]),
          _safeUploadReport('marketing_report_collection', reports[4])
        ];

        await Future.wait(uploadFutures);
      } catch (e) {
        Log.d('Error syncing marketing activity for ID $idMA: $e');
      } finally {
        await db.update(
          'marketing_activity',
          {'status_sync': 1},
          'id = ?',
          [idMA],
        );
      }
    }
    showNotification(
      NotifId.MKT_SYNC_CH_ID,
      NotifId.MKT_SYNC_CH_NAME,
      NotifId.MKT_SYNC_ID,
      'Sinkronisasi Data Kunjungan',
      'Data kunjungan berhasil terkirim',
    );
  }

  Future<void> _safeUploadReport(String method, List<Map<String, dynamic>> data,
      {List<String>? fileKeys}) async {
    try {
      await _uploadReport(method, data, fileKeys: fileKeys);
    } catch (e) {
      Log.d('Failed to upload report $method: $e');
    }
  }

  Future<List<MarketingActivity>> _getUnsyncedMarketingActivity() async {
    final unsyncedMarketingActivity = await db.query(
      'marketing_activity',
      where: 'status_sync = ? AND waktu_co IS NOT NULL',
      whereArgs: [0],
    );
    final data = unsyncedMarketingActivity
        .map((e) => MarketingActivity.fromJson(e))
        .toList();
    return data;
  }

  Future<List<Map<String, dynamic>>> _getReport(
      String table, String idMA) async {
    try {
      final report = await db.query(
        table,
        where: 'idMA = ?',
        whereArgs: [idMA],
      );
      Log.d('Retrieved ${report.length} report from $table for ID $idMA');
      return report;
    } catch (e) {
      Log.d('Error retrieving report from $table for ID $idMA: $e');
      return [];
    }
  }

  Future<void> _uploadReport(String method, List<Map<String, dynamic>> data,
      {List<String>? fileKeys}) async {
    if (data.isEmpty) return;
    List<Future> futures = [];
    for (final item in data) {
      try {
        Future res;
        if (fileKeys != null && fileKeys.isNotEmpty) {
          res = api.postFileRequest(
              method: method, additionalData: item, fileKeys: fileKeys);
        } else {
          res = api.postRequest(method: method, additionalData: item);
        }
        futures.add(res);
      } catch (e) {
        Log.d('Error preparing upload for $method: $e');
      }
    }
    Log.d('Uploading ${futures.length} report for $method');
    await Future.wait(futures);
  }

  Future<void> _uploadNooData(String customerId) async {
    var result = await db.query(
      'masternoo',
      where: 'status_sync = ? AND id = ?',
      whereArgs: [0, customerId],
    );

    if (result.isEmpty) return;

    var nooAddress = await db
        .query('nooaddress', where: 'id_noo = ?', whereArgs: [customerId]);
    var nooDocumentResult = await db
        .query('noodocument', where: 'id_noo = ?', whereArgs: [customerId]);
    var nooSpesimen = await db
        .query('noospesimen', where: 'id_noo = ?', whereArgs: [customerId]);

    var nooData = result.first;
    var nooDocument = nooDocumentResult.first;

    await api.postRequest(method: 'marketing_noo', additionalData: nooData);
    await _uploadMultipleRecords(nooAddress, 'insert_noo_address');
    await _uploadMultipleFileRecords(
        nooSpesimen, 'insert_noo_spesimen', ['ttd', 'stempel']);
    var docFileKeys = nooDocument.keys
        .where((key) => key != 'id' && key != 'id_noo')
        .toList();
    await api.postFileRequest(
        method: 'insert_noo_document',
        additionalData: nooDocument,
        fileKeys: docFileKeys);
    await db.update(
      'masternoo',
      {'status_sync': 1},
      'id = ?',
      [customerId],
    );
  }

  Future<void> _uploadCanvasingData(String custId) async {
    var result = await db.query(
      'canvasing',
      where: 'status_sync = ? AND CustID = ?',
      whereArgs: [0, custId],
    );

    if (result.isEmpty) return;

    CanvasingModel canvasingData = CanvasingModel.fromJson(result.first);
    await api.postFileRequest(
      method: 'marketing_canvasing',
      additionalData: canvasingData.toJson(),
      fileKeys: ['image_path'],
    );
    await db.update(
      'canvasing',
      {'status_sync': 1},
      'CustID = ?',
      [custId],
    );
  }

  Future<void> _uploadMultipleRecords(
      List<Map<String, dynamic>> records, String method) async {
    for (var record in records) {
      await api.postRequest(method: method, additionalData: record);
    }
  }

  Future<void> _uploadMultipleFileRecords(List<Map<String, dynamic>> records,
      String method, List<String> fileKeys) async {
    for (var record in records) {
      await api.postFileRequest(
          method: method, additionalData: record, fileKeys: fileKeys);
    }
  }
}
