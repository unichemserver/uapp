import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/model/noo_model.dart';
import 'package:uapp/modules/marketing/visitasi/noo/doc_form.dart';
import 'package:uapp/modules/marketing/visitasi/noo/kil_form.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_controller.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_text_controller.dart';
import 'package:uapp/modules/marketing/visitasi/noo/spesimen_form.dart';

class UpdateNooPage extends StatefulWidget {
  const UpdateNooPage({super.key});

  @override
  State<UpdateNooPage> createState() => _UpdateNooPageState();
}

class _UpdateNooPageState extends State<UpdateNooPage> {
  final nooCtrl = NooTextController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  @override
  @override
void initState() {
  super.initState();
  loadNooData();
}

Future<void> loadNooData() async {
  final nooId = Get.arguments['id'] as String;
  final nooData = Get.arguments['data'] as NooModel?;
  final controller = Get.find<NooController>();

  setState(() {
    isLoading = true;
  });

  controller.setIdNoo(nooId);

  try {
    await controller.fetchMasterNooData();
    final masternoo = controller.masternoo.value;
    

    if (nooData != null) {
      controller.setNooUpdateId(nooData.id!);
      controller.setNooId(nooData.idNoo!);
      controller.setNooData(nooData);
      controller.setNooDocument();
      controller.setSpesimentData();
      controller.setNooAddressFromApi();
      nooCtrl.mapModelToCtrl(nooData);
    } else {
      if (masternoo != null && masternoo.isNotEmpty) {
        final nooModel = NooModel.fromJson(masternoo);
        nooCtrl.mapModelToCtrl(nooModel);

        final groupCust = nooModel.groupCust ?? '';
        final match = RegExp(r'^(.*?)\[(.*?)\]$').firstMatch(groupCust);
        if (match != null) {
          controller.setSelectedCluster(match.group(2) ?? '');
          controller.setSelectedNamaDesc(match.group(1) ?? '');
        }
      }
    }
  } catch (e) {
    Log.d('Error fetching NOO data: $e');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}



  void showConfirmationDialog(NooController ctx, BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah anda yakin ingin kembali?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _formKey.currentState!.reset();
              Get.back();
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
      builder: (ctx) {
        if (isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (!didPop) {
              showConfirmationDialog(ctx, context);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Update NOO'),
              leading: IconButton(
                onPressed: () {
                  showConfirmationDialog(ctx, context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
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
                              Tab(text: 'Spesimen'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                KilForm(nooCtrl: nooCtrl),
                                DocForm(),
                                SpesimenForm(),
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
                        if (ctx.selectedNamaDesc.value.isEmpty) {
                          Utils.showErrorSnackBar(
                            context,
                            'Pilih Group Pelanggan terlebih dahulu',
                          );
                          return;
                        }
                        if (ctx.jaminan.isEmpty) {
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
                        ctx.saveData(nooCtrl, nooId: ctx.nooId.value).then((value) {
                          Navigator.pop(context);
                          _formKey.currentState!.reset();
                          Get.offNamed(Routes.HOME);
                          Log.d('Data berhasil disimpan: $nooCtrl');
                          Utils.showSuccessSnackBar(context, 'Data berhasil disimpan');
                        }).catchError((error) {
                          Navigator.pop(context);
                          Utils.showErrorSnackBar(
                            context,
                            'Terjadi kesalahan saat menyimpan data: $error',
                          );
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
