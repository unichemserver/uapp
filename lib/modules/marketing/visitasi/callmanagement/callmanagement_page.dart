import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/modules/marketing/visitasi/shared/customer_page.dart';
import 'package:uapp/modules/marketing/visitasi/custactive/custactive_controller.dart';

class CallManagementPage extends StatelessWidget {
  const CallManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomerPage(
      title: 'Call Management',
      fetchData: (ctx) async {
        if (!ctx.isLoading) {
          ctx.setSelectedCustId(null);
          // Add logic to fetch Call Management-specific data here
          ctx.getCustActive();
        }
      },
      onContinue: (ctx) {
        Get.toNamed(Routes.MARKETING, arguments: {
          'type': Call.custactive,
          'id': ctx.selectedCustId!.id,
          'name': ctx.selectedCustId!.name,
        });
      },
      actions: [
        IconButton(
          onPressed: () => Get.find<CustactiveController>().updateCustomerActive(),
          icon: const Icon(Icons.sync),
          tooltip: 'Sync Data Customer',
        ),
        IconButton(
          onPressed: () => Get.toNamed(Routes.HISTORY_VISITASI),
          icon: const Icon(Icons.history),
          tooltip: 'History Visitasi Customer',
        ),
      ],
    );
  }
}
