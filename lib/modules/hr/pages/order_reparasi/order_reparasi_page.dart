import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/widget/loading_dialog.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/api.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/api_param.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/history_page.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/kendaraan_alat_berat.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/peralatan_it.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/peralatan_non_it.dart';
import 'package:uapp/modules/hr/pages/order_reparasi/peralatan_reparasi.dart';

class OrderReparasiPage extends StatefulWidget {
  const OrderReparasiPage({super.key});

  @override
  State<OrderReparasiPage> createState() => _OrderReparasiPageState();
}

class _OrderReparasiPageState extends State<OrderReparasiPage> {
  final List<String> jenisPeralatan = [
    'Peralatan Non IT',
    'Peralatan IT',
    'Kendaraan/Alat Berat',
  ];
  String selectedJenisPeralatan = 'Peralatan Non IT';
  bool isEditing = false;
  ResponseData? data;
  String? orderNumber;
  final nonItFormKey = GlobalKey<FormState>();
  final itFormKey = GlobalKey<FormState>();
  final abFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getItAlatBerat().then((value) {
      data = value;
      setState(() {});
    });
  }

  resetForm(String jenisAlat) {
    if (jenisAlat == '1') {
      nonItFormKey.currentState!.reset();
    } else if (jenisAlat == '2') {
      itFormKey.currentState!.reset();
    } else {
      abFormKey.currentState!.reset();
    }
  }

  savedData(ApiParams params) {
    if (isEditing) {
      params.nomorOrder = orderNumber;
    }
    Get.dialog(
      const LoadingDialog(
        message: 'Menyimpan Data',
      ),
      barrierDismissible: false,
    );
    addOrderReparasi(params).then((value) {
      Get.back();
      if (value == null) {
        resetForm(params.jenisAlat);
        Get.snackbar('Berhasil', 'Order Reparasi berhasil ditambahkan');
      } else {
        Get.snackbar('Gagal', value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: jenisPeralatan.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Reparasi'),
          actions: [
            IconButton(
              onPressed: () async {
                var data = await Get.to(() => HistoryPage());
                if (data != null) {
                  isEditing = true;
                  orderNumber = data;
                }
              },
              icon: const Icon(Icons.history),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: jenisPeralatan.map((jenis) => Tab(text: jenis)).toList(),
            onTap: (index) {
              setState(() {
                selectedJenisPeralatan = jenisPeralatan[index];
              });
            },
          ),
        ),
        body: data == null
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text('Mendapatkan Data Perlatan'),
                  ],
                ),
              )
            : TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PeralatanNonIt(
                    alatBerat: data!.ab,
                    onSaved: savedData,
                    formKey: nonItFormKey,
                  ),
                  PeralatanIt(
                    peralatanIt: data!.it,
                    onSaved: savedData,
                    formKey: itFormKey,
                  ),
                  KendaraanAlatBerat(
                    alatBerat: data!.ab,
                    onSaved: savedData,
                    formKey: abFormKey,
                  ),
                ],
              ),
      ),
    );
  }
}
