import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/model/noo_model.dart';
import 'package:uapp/modules/marketing/visitasi/noo/doc_form.dart';
import 'package:uapp/modules/marketing/visitasi/noo/kil_form.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_controller.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_options.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_text_controller.dart';
import 'package:uapp/modules/marketing/visitasi/noo/spesimen_form.dart';

class NooPage extends StatefulWidget {
  NooPage({super.key});

  @override
  State<NooPage> createState() => _NooPageState();
}

class _NooPageState extends State<NooPage> {
  final nooCtrl = NooTextController();
  final _formKey = GlobalKey<FormState>();

  void showConfirmationDialog(
    NooController ctx,
    BuildContext context,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text(
          'Apakah anda ingin menyimpan data ini?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Utils.showLoadingDialog(context);
              ctx.deleteData().then((value) {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Utils.showLoadingDialog(context);
              ctx.saveData(nooCtrl).then((value) {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nooCtrl.disposeAll();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NooController>(
      init: NooController(),
      initState: (_) {},
      builder: (ctx) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (!didPop) {
              showConfirmationDialog(ctx,context);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('PDL'),
              leading: IconButton(
                onPressed: () {
                  showConfirmationDialog(ctx,context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    var data = await Get.toNamed(Routes.SAVED_NOO);
                    if (data != null) {
                      data = data as NooModel;
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Data PDL'),
                          content: const Text(
                            'Apakah anda yakin ingin melanjutkan data PDL ini?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                ctx.setNooId(data.id);
                                ctx.setNooData(data);
                                ctx.setNooDocument();
                                ctx.setSpesimentData();
                                ctx.setNooAddress();
                                nooCtrl.mapModelToCtrl(data);
                                Get.back();
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.dataset),
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed(
                      Routes.HISTORY_VISITASI,
                      arguments: Call.noo,
                    );
                  },
                  icon: const Icon(Icons.history),
                ),
              ],
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(text: 'PDL'),
                              Tab(text: 'Document'),
                              Tab(text: 'Spesimen')
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                KilForm(nooCtrl: nooCtrl),
                                DocForm(),
                                SpesimenForm()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (ctx.groupPelanggan.isEmpty) {
                          Utils.showErrorSnackBar(
                            context,
                            'Pilih Group Pelanggan terlebih dahulu',
                          );
                          return;
                        }
                        if (ctx.paymentMethod.isEmpty) {
                          Utils.showErrorSnackBar(
                            context,
                            'Pilih Metode Pembayaran terlebih dahulu',
                          );
                          return;
                        }
                        if (ctx.jaminan.isEmpty &&
                            ctx.groupPelanggan == NooOptions.custGroup[1]) {
                          Utils.showErrorSnackBar(
                            context,
                            'Pilih Jenis Jaminan terlebih dahulu',
                          );
                          return;
                        }
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        Utils.showLoadingDialog(context);
                        ctx.saveData(nooCtrl).then((value) {
                          Navigator.pop(context);
                          _formKey.currentState!.reset();
                          Get.toNamed(Routes.MARKETING, arguments: {
                            'id': ctx.idNOO,
                            'type': Call.noo,
                            'name': nooCtrl.namaPerusahaanCtrl.text,
                          });
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48.0),
                      ),
                      child: const Text('Simpan & Lanjutkan'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
