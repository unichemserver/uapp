import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';
import 'package:uapp/modules/marketing/model/collection_model.dart';
import 'package:uapp/modules/marketing/widget/collection_report_dialog.dart';

class CollectionPage extends StatelessWidget {
  CollectionPage({super.key});

  final amountPaidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      init: MarketingController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Collection',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: const SizedBox(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              CollectionModel? result = await Get.dialog(CollectionReportDialog());
              if (result != null) {
                ctx.addCollectionToDatabase(result);
              }
            },
            child: const Icon(Icons.add),
          ),
          body: _buildBody(context, ctx),
        );
      },
    );
  }

  String getStatusCall(MarketingController ctx) {
    if (ctx.listCollection.isEmpty) {
      return 'vno';
    }
    if (isCollectionFullCollected(ctx)) {
      return 'vwo';
    }
    return 'vno';
  }

  bool isCollectionFullCollected(MarketingController ctx) {
    if (ctx.listCollection.isEmpty) {
      return false;
    }
    return ctx.listCollection.every((element) => element.status == 'collected');
  }

  IconData getIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'cash':
        return Icons.account_balance_wallet;
      case 'transfer bank':
        return Icons.account_balance;
      case 'giro':
        return Icons.attach_money;
      default:
        return Icons.menu;
    }
  }

  Icon getIconStatus(String status) {
    switch (status.toLowerCase()) {
      case 'collected':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'partial collected':
        return const Icon(Icons.hourglass_bottom, color: Colors.orange);
      default:
        return const Icon(Icons.highlight_off, color: Colors.red);
    }
  }

  String formatCurrency(int amount) {
    final currency = NumberFormat('#,###', 'id_ID');
    return 'Rp ${currency.format(amount)}';
  }

  _buildBody(
      BuildContext context,
      MarketingController ctx,
      ) {
    if (ctx.listCollection.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory,
              size: 100.0,
            ),
            Text(
              'Belum ada data collection',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: ctx.listCollection.length,
      itemBuilder: (context, index) {
        CollectionModel collection = ctx.listCollection[index];
        return ListTile(
          leading: Icon(getIcon(collection.type)),
          title: Row(
            children: [
              const Icon(Icons.receipt_long),
              const SizedBox(width: 10),
              Text(collection.noInvoice),
            ],
          ),
          subtitle: Row(
            children: [
              getIconStatus(collection.status),
              const SizedBox(width: 10),
              Text(formatCurrency(collection.amount.toInt())),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ctx.deleteCollectionFromDatabase(collection);
            },
          ),
        );
      },
    );
  }
}
