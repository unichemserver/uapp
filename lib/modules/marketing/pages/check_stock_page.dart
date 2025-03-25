import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';
import 'package:uapp/modules/marketing/model/stock_model.dart';
import 'package:uapp/modules/marketing/widget/stock_report_dialog.dart';

class CheckStockPage extends StatelessWidget {
  const CheckStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      init: MarketingController(),
      builder: (ctx) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(context, ctx.products, ctx),
          floatingActionButton: _buildFloatingActionButton(ctx),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Cek Sisa Stok',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: const SizedBox(),
    );
  }

  Widget _buildFloatingActionButton(MarketingController ctx) {
    return FloatingActionButton(
      onPressed: () async {
        StockModel? stocks = await Get.dialog(
          StockReportDialog(
            items: ctx.items,
            idMA: ctx.idMarketingActivity!,
          ),
        );
        if (stocks != null) {
          ctx.addStockToDatabase(stocks);
        }
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<StockModel> products,
    MarketingController ctx,
  ) {
    return products.isEmpty
        ? _buildEmptyState(context)
        : _buildProductList(context, products, ctx);
  }

  Widget _buildEmptyState(BuildContext context) {
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
                  fontFamily: 'OpenSans',
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(
    BuildContext context,
    List<StockModel> products,
    MarketingController ctx,
  ) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildDismissibleProduct(context, product, ctx);
      },
    );
  }

  Widget _buildDismissibleProduct(
    BuildContext context,
    StockModel product,
    MarketingController ctx,
  ) {
    return Dismissible(
      key: Key(product.itemId!),
      background: _buildDeleteBackground(),
      secondaryBackground: _buildEditBackground(),
      confirmDismiss: (direction) =>
          _handleDismiss(context, direction, product, ctx),
      child: _buildProductTile(context, product),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      color: Colors.red,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.delete, color: Colors.white),
          SizedBox(width: 8.0),
        ],
      ),
    );
  }

  Widget _buildEditBackground() {
    return Container(
      color: Colors.green,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: 8.0),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Future<bool?> _handleDismiss(
    BuildContext context,
    DismissDirection direction,
    StockModel product,
    MarketingController ctx,
  ) async {
    if (direction == DismissDirection.endToStart) {
      StockModel? stocks = await Get.dialog(
        StockReportDialog(
          items: ctx.items,
          stockData: product,
          idMA: ctx.idMarketingActivity!,
        ),
      );
      if (stocks != null) {
        ctx.updateStockToDatabase(stocks);
      }
    } else if (direction == DismissDirection.startToEnd) {
      bool confirmDelete = await _showDeleteConfirmation(context, product.name);
      if (confirmDelete) {
        ctx.deleteStockFromDatabase(product);
        return true;
      }
    }
    return null;
  }

  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    String? productName,
  ) async {
    return await Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah anda yakin ingin menghapus $productName?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTile(
    BuildContext context,
    StockModel product,
  ) {
    return ExpansionTile(
      title: Text(product.name!),
      subtitle: Row(
        children: [
          const Icon(Icons.inventory),
          const SizedBox(width: 8.0),
          Text('${product.quantity} ${product.unit}'),
        ],
      ),
      children: [
        GestureDetector(
          onTap: () => _showProductImage(context, product.imagePath!),
          child: Image.file(
            File(product.imagePath!),
            width: 100.0,
            height: 100.0,
          ),
        ),
      ],
    );
  }

  void _showProductImage(
    BuildContext context,
    String imagePath,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.file(File(imagePath)),
        );
      },
    );
  }
}
