import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/utils/rupiah_formatter.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';
import 'package:uapp/modules/marketing/model/collection_model.dart';
import 'package:uapp/modules/marketing/widget/list_invoice.dart';

class CollectionReportDialog extends StatelessWidget {
  CollectionReportDialog({super.key});

  final amountPaidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Collection'),
        ),
        body: GetBuilder<MarketingController>(
          init: MarketingController(),
          initState: (_) {},
          builder: (ctx) {
            String selectedNoInv = ctx.selectedInvoice?.nomorInvoice ?? '';
            int selectedAmount =
                int.parse(ctx.selectedInvoice?.sisaPiutang!.split('.').first ?? '0');
            final noInvController = TextEditingController(text: selectedNoInv);
            final amountController = TextEditingController(
              text: Utils.formatCurrency(
                selectedAmount.toString(),
              ),
            );
            return Scaffold(
              body: ListView(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: noInvController,
                          onTap: () {
                            Get.bottomSheet(const InvoiceListSheet());
                          },
                          readOnly: true,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            labelText: 'Nomor Invoice',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          readOnly: true,
                          controller: amountController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            labelText: 'Jumlah Tagihan',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Metode Pembayaran',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Wrap(
                          spacing: 8,
                          children: ctx.paymentMethod.map((e) {
                            return ChoiceChip(
                              label: Row(
                                children: [
                                  Icon(
                                    getIcon(e),
                                    color: ctx.selectedPaymentMethod == e
                                        ? Colors.white
                                        : Theme.of(context).disabledColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(e),
                                ],
                              ),
                              selected: ctx.selectedPaymentMethod == e,
                              onSelected: (value) {
                                ctx.selectPaymentMethod(e);
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        buildBuktiTransfer(ctx),
                        TextFormField(
                          controller: amountPaidController,
                          enabled: ctx.selectedPaymentMethod != null,
                          keyboardType: TextInputType.number,
                          inputFormatters: [RupiahInputFormatter()],
                          onChanged: (value) {
                            String number =
                                value.replaceAll(RegExp(r'[^0-9]'), '');
                            int amount = int.tryParse(number) ?? 0;
                            if (amount == 0) {
                              ctx.selectStatusPayment(2);
                            } else if (amount == selectedAmount) {
                              ctx.selectStatusPayment(0);
                            } else if (amount < selectedAmount) {
                              ctx.selectStatusPayment(1);
                            } else if (amount > selectedAmount) {
                              amountPaidController.text = amountController.text;
                            }
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            labelText: 'Jumlah Bayar',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Status Pembayaran',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        buildSelectedChip(ctx.selectedStatusPayment),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            int amount = int.tryParse(
                                  amountPaidController.text
                                      .replaceAll(RegExp(r'[^0-9]'), ''),
                                ) ??
                                0;
                            if (ctx.selectedPaymentMethod == null) {
                              Get.snackbar(
                                'Error',
                                'Pilih metode pembayaran terlebih dahulu',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            } else {
                              String noColl =
                                  'COLL${DateTime.now().toString().split(' ')[0]}${ctx.idMarketingActivity}';
                              var data = CollectionModel(
                                idMA: ctx.idMarketingActivity!,
                                noInvoice: noInvController.text,
                                amount: amount.toInt(),
                                type: ctx.selectedPaymentMethod!,
                                noCollect: noColl,
                                buktiBayar: ctx.buktiTransfer,
                                status: ctx.selectedStatusPayment == 0
                                    ? 'collected'
                                    : ctx.selectedStatusPayment == 1
                                        ? 'partial collected'
                                        : 'not collected',
                              );
                              // clear all input
                              Get.back(result: data);
                              noInvController.clear();
                              amountController.clear();
                              amountPaidController.clear();
                              ctx.selectInvoice(null);
                              ctx.selectPaymentMethod(null);
                              ctx.selectStatusPayment(null);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text('Simpan'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildBuktiTransfer(MarketingController ctx) {
    if (ctx.selectedPaymentMethod == 'Transfer Bank') {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: GestureDetector(
          onTap: ctx.buktiTransfer == null
              ? null
              : () async {
                  var result = await Get.toNamed(Routes.REPORT);
                  if (result != null) {
                    ctx.buktiTransfer = result;
                    ctx.update();
                  }
                },
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(Get.context!).disabledColor,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ctx.buktiTransfer == null
                ? GestureDetector(
                  onTap: () async {
                    var imgPath = await Get.toNamed(Routes.REPORT);
                    if (imgPath != null) {
                      ctx.buktiTransfer = imgPath;
                      ctx.update();
                    }
                  },
                  child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload),
                          Text('Upload Bukti Transfer'),
                        ],
                      ),
                    ),
                )
                : GestureDetector(
                    onTap: () async {
                      await Get.dialog(
                        Dialog.fullscreen(
                          child: Image.file(File(ctx.buktiTransfer!)),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Image.file(
                          File(ctx.buktiTransfer!),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              ctx.buktiTransfer = null;
                              ctx.update();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget buildSelectedChip(int selectedStatusPayment) {
    switch (selectedStatusPayment) {
      case 0:
        return ChoiceChip(
          label: const Row(
            children: [
              Icon(Icons.check_circle),
              SizedBox(width: 4),
              Text('Collected'),
            ],
          ),
          selected: true,
          onSelected: (value) {},
        );
      case 1:
        return ChoiceChip(
          label: const Row(
            children: [
              Icon(Icons.hourglass_bottom),
              SizedBox(width: 4),
              Text('Partial Collected'),
            ],
          ),
          selected: true,
          onSelected: (value) {},
        );
      case 2:
        return ChoiceChip(
          label: const Row(
            children: [
              Icon(Icons.highlight_off),
              SizedBox(width: 4),
              Text('Not Collected'),
            ],
          ),
          selected: true,
          onSelected: (value) {},
        );
      default:
        return Container(); // Return an empty container if no valid status is selected
    }
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
}
