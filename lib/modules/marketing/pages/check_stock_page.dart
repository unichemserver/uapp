import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/models/stock.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';
import 'package:uapp/modules/marketing/widget/stock_report_dialog.dart';

class CheckStockPage extends StatelessWidget {
  const CheckStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      init: MarketingController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Cek Sisa Stok',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: const SizedBox(),
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.arrow_forward),
            //     onPressed: () {
            //       // ctx.getCompetitors();
            //       // ctx.switchPage(3);
            //     },
            //   ),
            // ],
          ),
          body: _buildBody(context, ctx.products),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Stock? stocks = await Get.dialog(
                StockReportDialog(items: ctx.items),
              );
              if (stocks != null) {
                Get.find<MarketingController>().addStockToDatabase(stocks);
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  _buildBody(BuildContext context, List<Stock> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory,
              size: 100.0,
            ),
            Text(
              'Belum ada data stok yang anda masukkan',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rubik',
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ExpansionTile(
          title: Text(product.name),
          subtitle: Row(
            children: [
              const Icon(Icons.inventory),
              const SizedBox(width: 8.0),
              Text('${product.quantity} ${product.unit}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  Stock? stocks = await Get.dialog(
                    StockReportDialog(
                      items: Get.find<MarketingController>().items,
                      stockData: product,
                    ),
                  );
                  if (stocks != null) {
                    Get.find<MarketingController>()
                        .updateStockToDatabase(stocks);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Get.find<MarketingController>()
                      .removeStockFromDatabase(product);
                },
              ),
            ],
          ),
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Image.file(
                        File(product.imagePath),
                      ),
                    );
                  },
                );
              },
              child: Image.file(
                File(product.imagePath),
                width: 100.0,
                height: 100.0,
              ),
            ),
          ],
        );
      },
    );
  }
}
