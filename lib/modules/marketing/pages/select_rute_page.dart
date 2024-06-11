import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';
import 'package:uapp/modules/marketing/widget/noo_dialog.dart';
import 'package:uapp/modules/marketing/widget/select_customer_sheet.dart';

class SelectRutePage extends StatelessWidget {
  const SelectRutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      init: MarketingController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Pilih Rute Kunjungan'),
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {},
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              ctx.onInit();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChoiceChip(
                    label: const Row(
                      children: [
                        Icon(Icons.route),
                        SizedBox(width: 8),
                        Text('On Route'),
                      ],
                    ),
                    selected: ctx.jenisRute == 0,
                    onSelected: (value) {
                      ctx.changeJenisRute(0);
                      ctx.changeSelectedOffRoute(-1);
                      ctx.changeJenisCall('');
                    },
                  ),
                  ChoiceChip(
                    label: const Row(
                      children: [
                        Icon(Icons.block),
                        SizedBox(width: 8),
                        Text('Off Route'),
                      ],
                    ),
                    selected: ctx.jenisRute == 1,
                    onSelected: (value) {
                      ctx.changeJenisRute(1);
                      ctx.changeSelectedOnRoute(-1);
                      ctx.changeJenisCall('');
                      ctx.changeSelectedOffRoute(-1);
                      ctx.ruteId = null;
                      ctx.update();
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    ctx.jenisRute == 0
                        ? 'Pilih rute kunjungan yang akan dilakukan'
                        : ctx.jenisRute == 1
                            ? 'Pilih jenis off route yang akan dilakukan'
                            : '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  _buildListRute(context, ctx),
                  ElevatedButton(
                    onPressed: () {
                      if (ctx.jenisCall.isEmpty) {
                        Get.snackbar(
                          'Peringatan',
                          'Silahkan pilih jenis rute terlebih dahulu',
                        );
                        return;
                      }

                      if (ctx.jenisCall == 'onroute') {
                        ctx.changeIndex(1);
                      } else if (ctx.jenisCall == 'custactive') {
                        Get.bottomSheet(
                          SelectExistingCustomerSheet(
                            existingCustomer: ctx.existingCustomer,
                            onSelect: (customer) {
                              ctx.setCustomerId(customer?.custId ?? '');
                            },
                            onLanjut: () {
                              Get.back();
                              ctx.changeIndex(1);
                            },
                            customerId: ctx.customerId!,
                          ),
                        );
                      } else if (ctx.jenisCall == Call.noo) {
                        Get.dialog(const NooDialog());
                      } else if (ctx.jenisCall == Call.canvasing) {
                        // show dialog to confirm to user
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: const Text(
                              'Apakah anda yakin ingin melakukan canvasing?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                  ctx.box.put(HiveKeys.isCheckIn, true);
                                  ctx.box.put(HiveKeys.jenisCall, Call.canvasing);
                                  Get.toNamed(Routes.CANVASING);
                                },
                                child: const Text('Lanjut'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Lanjut'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListRute(BuildContext context, MarketingController ctx) {
    return Expanded(
      child: ctx.jenisRute == 0
          ? ListView.builder(
              itemCount: ctx.listRute.length,
              itemBuilder: (context, index) {
                var rute = ctx.listRute[index];
                var ruteId = rute.idRute;
                return RadioListTile(
                  value: index,
                  groupValue: ctx.selectedOnRoute,
                  onChanged:  (value) {
                    ctx.changeSelectedOnRoute(value!);
                    ctx.changeJenisCall(Call.onroute);
                    ctx.ruteId = rute.idRute;
                    ctx.update();
                  },
                  title: ExpansionTile(
                    title: Text(rute.custname ?? ''),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(rute.personalName ?? ''),
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(rute.address ?? ''),
                      ),
                      ListTile(
                        leading: const Icon(Icons.note),
                        title: Text(rute.jadwalRute),
                        subtitle: Text(
                          rute.keterangan.replaceAll(' HARI', '\nHARI'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : ctx.jenisRute == 1
              ? _buildOffRoute(context, ctx)
              : const Center(
                  child: Text(
                    'Silahkan Pilih jenis rute terlebih dahulu',
                  ),
                ),
    );
  }

  _buildOffRoute(BuildContext context, MarketingController ctx) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ChoiceChip(
            label: const Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 8),
                Text('Customer Aktif'),
              ],
            ),
            selected: ctx.selectedOffRoute == 0,
            onSelected: (value) {
              ctx.changeSelectedOffRoute(0);
              ctx.changeJenisCall(Call.custactive);
              ctx.getExistingCustomer();
            },
          ),
          ChoiceChip(
            label: const Row(
              children: [
                Icon(Icons.store),
                SizedBox(width: 8),
                Text('New Outlet Opening'),
              ],
            ),
            selected: ctx.selectedOffRoute == 1,
            onSelected: (value) {
              ctx.changeSelectedOffRoute(1);
              ctx.changeJenisCall(Call.noo);
            },
          ),
          ChoiceChip(
            label: const Row(
              children: [
                Icon(Icons.map),
                SizedBox(width: 8),
                Text('Canvasing'),
              ],
            ),
            selected: ctx.selectedOffRoute == 2,
            onSelected: (value) {
              ctx.changeSelectedOffRoute(2);
              ctx.changeJenisCall(Call.canvasing);
            },
          ),
          const SizedBox(height: 16),
          // _buildSelectedOffRoute(context, ctx),
        ],
      ),
    );
  }
}
