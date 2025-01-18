import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/model/marketing_activity.dart';

class HistoryVisitasi extends StatefulWidget {
  const HistoryVisitasi({super.key, required this.type});

  final String type;

  @override
  State<HistoryVisitasi> createState() => _HistoryVisitasiState();
}

class _HistoryVisitasiState extends State<HistoryVisitasi> {
  final db = MarketingDatabase();
  final List<MarketingActivity> listMarketingActivity = [];

  getListMarketingActivity() async {
    final list = await db.query('marketing_activity',
        where: 'jenis = ?', whereArgs: [widget.type]);
    final List<MarketingActivity> listMA =
        list.map((e) => MarketingActivity.fromJson(e)).toList();
    setState(() {
      listMarketingActivity.addAll(listMA);
    });
  }

  deleteMarketingActivity(String id) async {
    Utils.showLoadingDialog(context);
    final deleteMarketingActivityFuture =
        db.delete('marketing_activity', 'id = ?', [id]);
    final deleteStockFuture = db.delete('stock', 'idMA = ?', [id]);
    final deleteCompetitorFuture = db.delete('competitor', 'idMA = ?', [id]);
    final deleteDisplayFuture = db.delete('display', 'idMA = ?', [id]);
    final deleteTakingOrderFuture = db.delete('taking_order', 'idMA = ?', [id]);
    final deleteCollectionFuture = db.delete('collection', 'idMA = ?', [id]);

    await Future.wait([
      deleteMarketingActivityFuture,
      deleteStockFuture,
      deleteCompetitorFuture,
      deleteDisplayFuture,
      deleteTakingOrderFuture,
      deleteCollectionFuture,
    ]);

    setState(() {
      listMarketingActivity.removeWhere((element) => element.id == id);
    });
    Navigator.pop(context);
  }

  void showConfimationDialog(
    String action,
    Function() onYes,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin $action data ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onYes();
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  String getTypeVisitation(String type) {
    switch (type) {
      case 'ONR':
        return Call.onroute;
      case 'ACT':
        return Call.custactive;
      case 'NOO':
        return Call.noo;
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils.showLoadingDialog(context);
      getListMarketingActivity().then((value) {
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Kunjungan'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (listMarketingActivity.isEmpty) {
      return Center(
        child: Text('Tidak ada data Kunjungan ${widget.type}'),
      );
    }
    return ListView.builder(
      itemCount: listMarketingActivity.length,
      itemBuilder: (context, index) {
        final item = listMarketingActivity[index];
        String? waktuCO = item.waktuCo ?? 'Belum Check Out';
        return ExpansionTile(
          title: Text(item.custName ?? ''),
          leading: GestureDetector(
            onTap: () {
              Get.dialog(
                Dialog.fullscreen(
                  child: InteractiveViewer(
                    panEnabled: true,
                    scaleEnabled: true,
                    minScale: 0.5,
                    maxScale: 5.0,
                    child: Image.file(File(item.fotoCi!)),
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(item.fotoCi!),
                width: 50,
                height: 50,
              ),
            ),
          ),
          expandedAlignment: Alignment.centerLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(item.waktuCi!),
              leading: const Icon(Icons.login, color: Colors.green),
            ),
            ListTile(
              title: Text(waktuCO),
              leading: const Icon(Icons.logout, color: Colors.red),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: item.waktuCo == null
                      ? () {
                          showConfimationDialog('hapus', () {
                            deleteMarketingActivity(item.id);
                          });
                        }
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: item.waktuCo == null
                      ? () {
                          showConfimationDialog('edit', () {
                            Get.toNamed(Routes.MARKETING, arguments: {
                              'type': getTypeVisitation(widget.type),
                              'id': item.custId,
                              'ma': item.id,
                              'name': item.custName,
                            });
                          });
                        }
                      : null,
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
