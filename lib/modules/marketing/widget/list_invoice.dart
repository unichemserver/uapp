import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';
import 'package:uapp/modules/marketing/model/invoice_model.dart';

class InvoiceListSheet extends StatelessWidget {
  const InvoiceListSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      init: MarketingController(),
      initState: (_) {},
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: ctx.listInvoice.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada invoice',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: ctx.listInvoice.length,
                  itemBuilder: (context, index) {
                    BelumInvoice invoice = ctx.listInvoice[index];
                    double width = MediaQuery.of(context).size.width;
                    return ExpansionTile(
                      leading: Radio(
                        value: invoice,
                        groupValue: ctx.selectedInvoice,
                        onChanged: (value) {
                          ctx.selectInvoice(value as BelumInvoice);
                          Get.back();
                        },
                      ),
                      title: Row(
                        children: [
                          const Icon(Icons.receipt_long),
                          Text(invoice.nomorInvoice!),
                        ],
                      ),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: width - width / 2),
                        const Text('Nilai Invoice:'),
                        Text(
                          Utils.formatCurrency(invoice.nilaiInvoice.toString()),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text('Sisa Piutang:'),
                        Text(
                          Utils.formatCurrency(invoice.sisaPiutang.toString()),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text('Jatuh Tempo:'),
                        Text(
                          formatDate(DateTime.parse(invoice.jatuhTempo!)),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  },
                ),
        );
      },
    );
  }

  String formatDate(DateTime date) {
    return '${date.day} ${monthName(date.month)} ${date.year}';
  }

  String monthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }
}
