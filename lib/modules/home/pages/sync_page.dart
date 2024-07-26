import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/home/home_controller.dart';

class SyncPage extends StatelessWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      initState: (_) {},
      builder: (ctx) {
        bool showFunctionality = ctx.listMarketingActivity
            .where((element) => element.waktuCo == null)
            .isNotEmpty;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sinkronisasi'),
            actions: [
              IconButton(
                onPressed: () async {
                  bool isInet = await Utils.isInternetAvailable();
                  if (!isInet) {
                    Get.snackbar(
                      'Info',
                      'Tidak ada koneksi internet',
                    );
                    return;
                  }
                  if ((ctx.listMarketingActivity
                      .where((element) => element.statusSync == 0)
                      .isEmpty) || showFunctionality || ctx.listMarketingActivity.isEmpty) {
                    Get.snackbar(
                      'Info',
                      'Tidak ada data yang perlu disinkronisasi',
                    );
                  } else {
                    Get.snackbar(
                      'Info',
                      'Data sedang disinkronisasi',
                      duration: const Duration(hours: 1),
                    );
                    ctx.syncMarketingActivity().then((value) {
                      ctx.getListMarketingActivity();
                      if (Get.isSnackbarOpen) {
                        Get.back();
                      }
                    });
                  }
                },
                icon: const Icon(Icons.upload),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              ctx.getListMarketingActivity();
            },
            child: ctx.listMarketingActivity.isEmpty
                ? const Center(
                    child: Text('Tidak ada data kunjungan'),
                  )
                : showFunctionality
                    ? const Center(
                        child:
                            Text('Terdapat data kunjungan yang belum selesai'),
                      )
                    : ListView.builder(
                        itemCount: ctx.listMarketingActivity.length,
                        itemBuilder: (context, index) {
                          var item = ctx.listMarketingActivity[index];
                          print(item.toJson());
                          return ListTile(
                            leading: Text(getJenis(item.jenis ?? '')),
                            title: Text(item.custId ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(formatDateTime(item.waktuCi!)),
                                Text(formatDateTime(item.waktuCo!)),
                              ],
                            ),
                            trailing: Icon(
                              item.statusSync! == 1 ? Icons.check : Icons.close,
                              color: item.statusSync == 1
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            onTap: () {},
                          );
                        },
                      ),
          ),
        );
      },
    );
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('EEEE, MMMM d, yyyy - h:mm a').format(dateTime);
  }

  String getJenis(String jenis) {
    switch (jenis) {
      case Call.onroute:
        return 'On Route';
      case Call.noo:
        return 'New Opening Outlet';
      case Call.custactive:
        return 'Customer Active';
      case Call.canvasing:
        return 'Canvasing';
      default:
        return '';
    }
  }
}
