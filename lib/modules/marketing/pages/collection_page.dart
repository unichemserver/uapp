import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/models/collection.dart';
import 'package:uapp/modules/home/home_controller.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';
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
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  var stock = ctx.products;
                  var competitor = ctx.competitors;
                  var display = ctx.displayList;
                  if (stock.isEmpty && competitor.isEmpty && display.isEmpty) {
                    Get.snackbar(
                      'Peringatan',
                      'Silahkan isi semua laporan terlebih dahulu',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Checkout'),
                      content: const Text('Apakah anda yakin ingin checkout?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('Tidak'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.put(HomeController()).checkOut(
                              getStatusCall(ctx),
                              ctx.idMarketingActivity!,
                            );
                            Get.offAllNamed(Routes.HOME);
                          },
                          child: const Text('Ya'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              ctx.getInvoice();
              var result = await Get.dialog(CollectionReportDialog());
              if (result != null) {
                result.removeWhere((key, value) => value == null);
                ctx.addCollectionToDatabase(result);
                ctx.getCollections();
              }
            },
            child: const Icon(Icons.add),
          ),
          body: _buildBody(context, ctx.listCollection),
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

  IconData getIconStatus(String status) {
    switch (status.toLowerCase()) {
      case 'collected':
        return Icons.check_circle;
      case 'partial collected':
        return Icons.hourglass_bottom;
      default:
        return Icons.highlight_off;
    }
  }

  String formatCurrency(int amount) {
    final currency = NumberFormat('#,###', 'id_ID');
    return 'Rp ${currency.format(amount)}';
  }

  _buildBody(
      BuildContext context,
      List<Collection> listCollection,
      ) {
    if (listCollection.isEmpty) {
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
      itemCount: listCollection.length,
      itemBuilder: (context, index) {
        Collection collection = listCollection[index];
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
              Icon(getIconStatus(collection.status)),
              const SizedBox(width: 10),
              Text(formatCurrency(collection.amount)),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Get.find<MarketingController>()
                  .removeCollectionFromDatabase(collection.id!);
              Get.find<MarketingController>().getCollections();
            },
          ),
        );
      },
    );
  }
}
