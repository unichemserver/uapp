import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/modules/memo/widget/label_text.dart';
import 'package:uapp/modules/production/data/model/balance.dart';
import 'package:uapp/modules/production/data/model/barang.dart';
import 'package:uapp/modules/production/data/model/warehouse.dart';
import 'package:uapp/modules/production/data/production_api_service.dart'
    as api;
import 'package:uapp/modules/production/page/detail_balance_page.dart';
import 'package:uapp/modules/production/widget/filter_balance_widget.dart';
import 'package:uapp/modules/production/widget/search_item.dart';

class ItemBalancePage extends StatefulWidget {
  const ItemBalancePage({super.key});

  @override
  State<ItemBalancePage> createState() => _ItemBalancePageState();
}

class _ItemBalancePageState extends State<ItemBalancePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController startDateCtrl = TextEditingController();
  final TextEditingController endDateCtrl = TextEditingController();
  final TextEditingController searchCtrl = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String selectedWarehouse = '';
  List<Warehouse> warehouse = [];
  List<Balance> balance = [];
  List<BarangBalance> searchResult = [];
  String itemid = '';
  bool onSearch = false;

  final contentPadding = const EdgeInsets.only(
    left: 16,
    right: 16,
    top: 16,
  );

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      if (barcodeScanRes == '-1') {
        return;
      }
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return const LoadingDialog(message: 'Sedang memuat data...');
          },
          barrierDismissible: false,
        );
      }
      setState(() {
        itemid = barcodeScanRes;
      });
      var totalData = await api.getTotalBalance(itemid);
      Navigator.of(context).pop();
      if (totalData == 0) {
        Utils.showErrorSnackBar(context, 'Data tidak ditemukan');
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailBalancePage(
            totalData: totalData,
            itemid: itemid,
            warehouse: selectedWarehouse,
            startdate: startDateCtrl.text,
            enddate: endDateCtrl.text,
          ),
        ),
      );
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    startDateCtrl.dispose();
    endDateCtrl.dispose();
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Balance'),
      ),
      body: Padding(
        // except bottom
        padding: contentPadding,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LabelText(label: 'Pilih Tanggal'),
              FilterBalanceWidget(
                startDateCtrl: startDateCtrl,
                endDateCtrl: endDateCtrl,
                onWarehouseSelected: (value) {
                  setState(() {
                    selectedWarehouse = value?.locationId ?? '';
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  scanBarcodeNormal();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.maxFinite, 48),
                ),
                child: const Text('Scan Barcode'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!formKey.currentState!.validate()) {
            return;
          }
          showModalBottomSheet(
            context: context,
            builder: (modalContext) {
              return StatefulBuilder(builder: (context, setState) {
                return SearchItem(
                  searchCtrl: searchCtrl,
                  isOnSearch: onSearch,
                  onSearch: () {
                    setState(() {
                      onSearch = true;
                    });
                    searchResult.clear();
                    api.searchBarang(searchCtrl.text).then(
                      (value) {
                        setState(() {
                          searchResult.addAll(value);
                          onSearch = false;
                        });
                      },
                    );
                  },
                  barang: searchResult,
                  onResultTap: (item) async {
                    int totalData = await api.getTotalBalance(item.itemid);
                    if (totalData == 0) {
                      Utils.showErrorSnackBar(context, 'Data + ${item.descitem} tidak ditemukan');
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBalancePage(
                          totalData: totalData,
                          itemid: item.itemid,
                          itemdesc: item.descitem,
                          warehouse: selectedWarehouse,
                          startdate: startDateCtrl.text,
                          enddate: endDateCtrl.text,
                        ),
                      ),
                    );
                  },
                );
              });
            },
          ).whenComplete(() {
            setState(() {
              searchCtrl.clear();
              searchResult.clear();
            });
          });
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
