import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/modules/marketing/visitasi/onroute/customer_page.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/history_canvasing_screen.dart';


class CanvasingOnroute extends StatelessWidget {
  const CanvasingOnroute({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomerPage(
      title: 'Pilih Customer',
      fetchData: (ctx) async {
        await ctx.initData(loadCanvasing: true);
        ctx.setSelectedCustId(null);
      },
      onContinue: (ctx) {
        Get.toNamed(Routes.CANVASING, arguments: {
          'type': Call.canvasing,
          // 'id': ctx.selectedCustId!.id,
          'name': ctx.selectedCustId!.name, // Add outlet name
          'address': ctx.selectedCustId!.address,       // Add address
        });
      },
      actions: [
        IconButton(
          onPressed: () => Get.toNamed(Routes.NOO),
          icon: const Icon(Icons.add_business_outlined),
          tooltip: 'Add Customer',
        ),
        IconButton(
          onPressed: () => Get.to(() => const HistoryCanvasingScreen()),
          icon: const Icon(Icons.history_outlined),
          tooltip: 'History Canvasing',
        ),
      ],
    );
  }
}
