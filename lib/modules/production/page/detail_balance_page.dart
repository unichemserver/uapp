import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:uapp/core/utils/assets.dart';
import 'package:uapp/modules/memo/widget/label_text.dart';
import 'package:uapp/modules/production/data/model/balance.dart';
import 'package:uapp/modules/production/data/model/warehouse.dart';
import 'package:uapp/modules/production/data/production_api_service.dart'
    as api;
import 'package:uapp/modules/production/widget/filter_balance_widget.dart';
import 'package:uapp/modules/production/widget/image_carousel.dart';

class DetailBalancePage extends StatefulWidget {
  const DetailBalancePage({
    super.key,
    required this.totalData,
    required this.itemid,
    this.itemdesc,
    required this.warehouse,
    required this.startdate,
    required this.enddate,
  });

  final int totalData;
  final String itemid;
  final String? itemdesc;
  final String warehouse;
  final String startdate;
  final String enddate;

  @override
  State<DetailBalancePage> createState() => _DetailBalancePageState();
}

class _DetailBalancePageState extends State<DetailBalancePage> {
  final TextEditingController startDateCtrl = TextEditingController();
  final TextEditingController endDateCtrl = TextEditingController();
  String selectedWarehouse = '';
  List<Balance> filteredBalance = [];
  List<String?> listImage = [];
  bool isLoading = false;
  bool isTabular = true;
  bool isPortrait = true;

  String getLatestEndQty(List<Balance> balances) {
    balances.sort((a, b) {
      final dateComparison = b.trDate.compareTo(a.trDate);
      if (dateComparison != 0) {
        return dateComparison;
      } else {
        return b.trTime.compareTo(a.trTime);
      }
    });

    return balances.isNotEmpty ? balances.first.endQty : '';
  }

  getDetailBalance() async {
    setState(() => isLoading = true);
    startDateCtrl.text = widget.startdate;
    endDateCtrl.text = widget.enddate;

    final result = await api.fetchBalance(
      itemid: widget.itemid,
      page: '1',
      limit: widget.totalData.toString(),
      warehouse: widget.warehouse,
      startDate: widget.startdate,
      endDate: widget.enddate,
    );
    listImage.clear();
    setState(() {
      listImage = result?.images.map((e) => e['Path_']).toList() ?? [];
      filteredBalance = result?.data ?? [];
      isLoading = false;
    });
  }

  String formatDecimal(String input) {
    if (input.contains('.')) {
      List<String> parts = input.split('.');
      String wholePart = parts[0];
      String decimalPart = parts[1];

      if (decimalPart.length > 2) {
        decimalPart = decimalPart.substring(0, 2);
      }

      return '$wholePart.$decimalPart';
    } else {
      return input;
    }
  }

  @override
  void initState() {
    super.initState();
    getDetailBalance();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        var isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        if (didPop) {
          if (!isPortrait) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Balance'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              var isPortrait =
                  MediaQuery.of(context).orientation == Orientation.portrait;
              if (!isPortrait) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
              }
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: _buildFilterDialog,
                );
              },
            ),
            // IconButton(
            //   icon: Icon(
            //     isTabular ? Icons.view_list : Icons.table_chart_outlined,
            //   ),
            //   onPressed: () {
            //     setState(() {
            //       isTabular = !isTabular;
            //     });
            //   },
            // ),
            IconButton(
              icon: Icon(
                isPortrait ? Icons.landscape : Icons.portrait,
              ),
              onPressed: () {
                setState(() {
                  isPortrait = !isPortrait;
                });
                if (isPortrait) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                } else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.itemdesc != null
                        ? widget.itemdesc!
                        : filteredBalance.isNotEmpty
                            ? filteredBalance.first.description
                            : '',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listImage.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            child: ImageCarousel(
                              imageUrls: listImage,
                            ),
                          )
                        : Container(),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: isTabular ? 0 : 16),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      child: Text(
                        isLoading
                            ? 'Sedang memuat data...'
                            : 'Terdapat ${filteredBalance.length} data ditemukan',
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const Divider(),
                    LabelText(
                      label:
                      'Begin Qty: ${filteredBalance.isNotEmpty ? formatDecimal(filteredBalance.first.qty) : 0}',
                    ),
                    LabelText(
                      label:
                      'End Qty: ${formatDecimal(getLatestEndQty(filteredBalance))}',
                    ),
                    _buildContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (filteredBalance.isEmpty) {
      return Center(
        child: LottieBuilder.asset(Assets.noDataAnimation),
      );
    } else {
      return isTabular ? _tabularView() : _listView();
    }
  }

  Widget _listView() {
    return ListView.builder(
      itemCount: filteredBalance.length,
      itemBuilder: (context, index) {
        final item = filteredBalance[index];
        return ExpansionTile(
          title: Row(
            children: [
              const Icon(Icons.description),
              Text(
                item.trNo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.date_range),
              LabelText(
                label: item.trDate,
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time),
              LabelText(label: item.trTime),
            ],
          ),
          children: [
            ListTile(
              title: Text(item.description),
              subtitle: Text(
                item.descEng,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Qty        : ${item.qty} ${item.inventoryUnit}',
              ),
              subtitle: Text(
                'End Qty: ${item.endQty} ${item.inventoryUnit}',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _tabularView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
            2: IntrinsicColumnWidth(),
            3: IntrinsicColumnWidth(),
            4: IntrinsicColumnWidth(),
            // 5: IntrinsicColumnWidth(),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[300]),
              children: const [
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Tr No',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Tr Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Tr Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Desc Eng',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Qty',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // TableCell(
                //   child: Padding(
                //     padding: EdgeInsets.all(8.0),
                //     child: Text(
                //       'End Qty',
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // ),
              ],
            ),
            for (var item in filteredBalance)
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.trNo),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.trDate),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.trTime),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item.descEng,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${formatDecimal(item.qty)} ${item.inventoryUnit}'),
                    ),
                  ),
                  // TableCell(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Text('${item.endQty} ${item.inventoryUnit}'),
                  //   ),
                  // ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter'),
      content: FilterBalanceWidget(
        startDateCtrl: startDateCtrl,
        endDateCtrl: endDateCtrl,
        onWarehouseSelected: (Warehouse? warehouse) {
          setState(() {
            selectedWarehouse = warehouse?.locationId ?? '';
          });
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            api
                .fetchBalance(
              itemid: widget.itemid,
              page: '1',
              limit: widget.totalData.toString(),
              warehouse: selectedWarehouse,
              startDate: startDateCtrl.text,
              endDate: endDateCtrl.text,
            )
                .then((result) {
              setState(() {
                filteredBalance = result?.data ?? [];
              });
              Navigator.of(context).pop();
            });
          },
          child: const Text('Filter'),
        ),
      ],
    );
  }
}
