import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/utils/jenis_call.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  String visitType(String type) {
    switch (type) {
      case Call.onroute:
        return 'On Route';
      case Call.custactive:
        return 'Customer Active';
      case Call.noo:
        return 'New Opening Outlet';
      default:
        return 'Canvasing';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      builder: (ctx) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildVisitTypeHeader(context, ctx),
              _buildStockSection(ctx),
              _buildCompetitorSection(ctx),
              _buildDisplaySection(ctx),
              _buildTakingOrderSection(ctx),
              _buildCollectionSection(ctx),
              _buildSignatureSection(ctx),
              const SizedBox(height: 16),
              _cetakStrukButton(ctx),
              _buildCheckoutButton(context, ctx),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Checkout'),
      centerTitle: true,
      leading: const SizedBox(),
    );
  }

  Widget _buildVisitTypeHeader(BuildContext context, MarketingController ctx) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Text(
        visitType(ctx.jenisCall),
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildStockSection(MarketingController ctx) {
    return ExpansionTile(
      title: const Text('Stock'),
      trailing: _buildTotalData(ctx.products.length),
      children: ctx.products
          .map(
            (e) => ListTile(
              title: Text(e.name!),
              subtitle: Text(e.quantity.toString()),
              trailing: Image.file(File(e.imagePath!)),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCompetitorSection(MarketingController ctx) {
    return ExpansionTile(
      title: const Text('Competitor'),
      trailing: _buildTotalData(ctx.competitors.length),
      children: ctx.competitors
          .map(
            (e) => ListTile(
              title: Text(e.name!),
              subtitle: Text('Program: ${e.program}\nSupport: ${e.support}'),
              trailing: Text(e.price.toString()),
            ),
          )
          .toList(),
    );
  }

  Container _buildTotalData(int total) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Text(
        total.toString(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDisplaySection(MarketingController ctx) {
    return ExpansionTile(
      title: const Text('Display'),
      trailing: _buildTotalData(ctx.displayList.length),
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: ctx.displayList
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    Get.dialog(Dialog(child: Image.file(File(e))));
                  },
                  child: Image.file(
                    File(e),
                    width: 50,
                    height: 50,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTakingOrderSection(MarketingController ctx) {
    return ExpansionTile(
      title: const Text('Taking Order'),
      trailing: _buildTotalData(ctx.takingOrders.length),
      children: ctx.takingOrders
          .map(
            (e) => ListTile(
              title: Text(e.description!),
              subtitle: Text(
                  '${e.quantity} * ${Utils.formatCurrency(e.unit!)}\nPPN: ${Utils.formatCurrency(e.ppn.toString())}',
                ),
                trailing: Text(
                  Utils.formatCurrency(e.price.toString()),
                ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCollectionSection(MarketingController ctx) {
    return ExpansionTile(
      title: const Text('Collection'),
      trailing: _buildTotalData(ctx.listCollection.length),
      children: ctx.listCollection
          .map(
            (e) => ListTile(
              title: Text(e.noInvoice),
              subtitle: Text(e.amount.toString()),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSignatureSection(MarketingController ctx) {
    return ExpansionTile(
      title: const Text('Tanda Tangan'),
      initiallyExpanded: ctx.ttdPath.isNotEmpty,
      children: [
        if (ctx.ttdPath.isNotEmpty)
          Image.file(File(ctx.ttdPath))
        else
          const SizedBox(),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context, MarketingController ctx) {
    return ElevatedButton(
      onPressed: () => _showCheckoutConfirmationDialog(context, ctx),
      child: const Text('Check-Out'),
    );
  }

Widget _cetakStrukButton(MarketingController ctx) {
    return ElevatedButton(
      onPressed: () async {
        ctx.printResi().then((value) {
          ctx.completeTo();
        });
        
      },
      child: Text(
        ctx.isToComplete ? 'Cetak Ulang Struk' : 'Cetak Struk',
      ),
    );
  }

  void _showCheckoutConfirmationDialog(
      BuildContext context, MarketingController ctx) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text(
          'Apakah Anda yakin ingin check-out?\nPastikan data-data yang telah diinput sudah benar!',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              Utils.showLoadingDialog(context);
              await ctx.checkOut();
              Get.offAllNamed(Routes.HOME);
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }
}
