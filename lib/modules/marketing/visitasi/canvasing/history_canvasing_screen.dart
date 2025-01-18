import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/database/marketing_database.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/modules/marketing/model/canvasing_model.dart';

class HistoryCanvasingScreen extends StatefulWidget {
  const HistoryCanvasingScreen({super.key});

  @override
  State<HistoryCanvasingScreen> createState() => _HistoryCanvasingScreenState();
}

class _HistoryCanvasingScreenState extends State<HistoryCanvasingScreen> {
  final db = MarketingDatabase();
  List<CanvasingModel> canvasingList = [];
  var listColor = [
    Colors.amberAccent[100],
    Colors.green[100],
    Colors.red[100],
  ];

  void getCanvasingList() async {
    String query = '''
      SELECT * FROM marketing_activity ma
      INNER JOIN canvasing c ON ma.cust_id = c.CustID
      WHERE ma.jenis = ? AND ma.status_sync = ?
    ''';
    var data = await db.rawQuery(query, args: [Call.canvasing, 0]);
    canvasingList = data.map((e) => CanvasingModel.fromJson(e)).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCanvasingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History Canvasing',
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: getCanvasingList,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.CANVASING)?.then((value) {
            getCanvasingList();
          });
        },
        child: const Icon(Icons.add_business_outlined),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getCanvasingList();
        },
        child: ListView.builder(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          itemCount: canvasingList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                onTap: canvasingList[index].waktuCo != null
                    ? null
                    : () {
                        Get.toNamed(Routes.CANVASING, arguments: {
                          'id': canvasingList[index].custID,
                          'ma': canvasingList[index].idMA,
                        });
                      },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tileColor: canvasingList[index].waktuCo == null
                    ? listColor[2]
                    : canvasingList[index].status == 1
                        ? listColor[1]
                        : listColor[0],
                title: Text('Nama Toko: ${canvasingList[index].namaOutlet}'),
                subtitle: Text('Nama Owner: ${canvasingList[index].namaOwner}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
