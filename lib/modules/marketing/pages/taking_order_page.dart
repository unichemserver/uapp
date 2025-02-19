import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_signature/signature.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';
import 'package:uapp/modules/marketing/model/to_model.dart';
import 'package:uapp/modules/marketing/widget/to_report_dialog.dart';

class TakingOrderPage extends StatelessWidget {
  TakingOrderPage({super.key});

  final HandSignatureControl control = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  final ValueNotifier<String?> svg = ValueNotifier<String?>(null);
  final ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);
  final totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      init: MarketingController(),
      builder: (ctx) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(context, ctx),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Taking Order',
        style: TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: const SizedBox(),
    );
  }

  Widget _buildBody(BuildContext context, MarketingController ctx) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // _buildTopCustSection(ctx),
          _buildOrderTable(ctx),
          const SizedBox(height: 16),
          _buildAddProductButton(ctx),
          const Divider(),
          _buildSignatureSection(context, ctx),
        ],
      ),
    );
  }

  Widget _buildOrderTable(MarketingController ctx) {
    return DataTable(
      columnSpacing: 16.0,
      columns: const [
        DataColumn(label: Text('Nama')),
        DataColumn(label: Text('Jumlah')),
        DataColumn(label: Text('Satuan')),
        DataColumn(label: Text('Total')),
      ],
      rows: ctx.takingOrders.map((order) => _buildOrderRow(ctx, order)).toList(),
    );
  }

  DataRow _buildOrderRow(MarketingController ctx, ToModel order) {
    return DataRow(
      cells: [
        DataCell(_buildDismissibleNameCell(ctx, order)),
        DataCell(Text(order.quantity.toString())),
        DataCell(Text(order.unit.toString())),
        DataCell(Text(order.price.toString())),
      ],
    );
  }

  Widget _buildDismissibleNameCell(MarketingController ctx, ToModel order) {
    return Dismissible(
      key: Key(order.itemid!),
      confirmDismiss: (direction) => _confirmDismiss(ctx, direction, order),
      child: Text(
        order.description!,
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }

  Future<bool?> _confirmDismiss(
      MarketingController ctx, DismissDirection direction, ToModel order) async {
    if (direction == DismissDirection.startToEnd) return false;

    return await Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Apakah anda ingin menghapus ${order.description} dari daftar?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              ctx.deleteTakingOrderFromDatabase(order);
              Get.back(result: true);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProductButton(MarketingController ctx) {
    return ElevatedButton(
      onPressed: () async {
        ToModel? data = await Get.dialog(
          ToReportDialog(
            items: ctx.items,
            idMA: ctx.idMarketingActivity!,
            priceList: ctx.priceList,
          ),
        );
        if (data != null) {
          ctx.addTakingOrderToDatabase(data);
        }
      },
      child: const Text('Tambah Produk'),
    );
  }

  Widget _buildSignatureSection(BuildContext context, MarketingController ctx) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tanda Tangan Customer',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _showSignatureDialog(ctx),
          child: _buildSignaturePreview(ctx),
        ),
      ],
    );
  }

  Widget _buildSignaturePreview(MarketingController ctx) {
    return Align(
      alignment: Alignment.center,
      child: ctx.ttdPath.isEmpty
          ? Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ValueListenableBuilder<ByteData?>(
          valueListenable: rawImage,
          builder: (context, value, child) {
            if (value == null) return const SizedBox();
            return Image.memory(
              value.buffer.asUint8List(),
              fit: BoxFit.cover,
            );
          },
        ),
      )
          : Image.file(
        File(ctx.ttdPath),
        fit: BoxFit.cover,
      ),
    );
  }

  void _showSignatureDialog(MarketingController ctx) {
    ctx.rotateScreen(false);
    Get.dialog(
      PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) {
            ctx.rotateScreen(true);
            Get.back();
          }
        },
        child: Dialog.fullscreen(
          child: Stack(
            children: [
              Positioned.fill(
                child: HandSignature(
                  control: control,
                  type: SignatureDrawType.shape,
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        control.clear();
                      },
                      child: const Text('Hapus'),
                    ),
                    TextButton(
                      onPressed: () async {
                        var path = await Utils.saveSignature(control.toImage());
                        ctx.ttdPath = path ?? '';
                        ctx.updateSignature(ctx.ttdPath);
                        rawImage.value = await control.toImage();
                        ctx.update();
                        ctx.rotateScreen(true);
                        Get.back();
                      },
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
