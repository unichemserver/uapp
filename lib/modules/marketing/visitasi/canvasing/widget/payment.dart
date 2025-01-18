import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/fonts.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/core/utils/rupiah_formatter.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/core/widget/speech_to_textfield.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/canvasing_controller.dart';

class PaymentWidget extends StatelessWidget {
  const PaymentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CanvasingController>(
      builder: (ctx) {
        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Total Nilai Order:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                Utils.formatCurrency(ctx.totalPayment.toString()),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontFamily: Fonts.rubik,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Jenis Pembayaran:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  ctx.jenisPembayaran.length,
                  (index) => ChoiceChip(
                    label: Text(ctx.jenisPembayaran[index]),
                    selected: ctx.selectedJenisPembayaran == index,
                    onSelected: (value) {
                      if (index == 0) {
                        ctx.proofOfPayment = '';
                        ctx.update();
                      }
                      ctx.selectJenisPembayaran(index);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SpeechToTextField(
                      readOnly: true,
                      prefixIcon: const Icon(Icons.monetization_on),
                      controller: ctx.nominalController,
                      hintText: 'Nominal Pembayaran',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        RupiahInputFormatter(),
                      ],
                      onChanged: (value) {
                        var nominal = int.parse(
                          value.replaceAll(RegExp(r'[^\d]'), ''),
                        );
                        if (nominal > ctx.totalPayment) {
                          Get.snackbar(
                            'Peringatan',
                            'Nominal pembayaran tidak boleh melebihi total order',
                          );
                          ctx.selectedStatusCollection = 2;
                          ctx.nominalController.text = '';
                          ctx.update();
                          return;
                        }
                        if (nominal < ctx.totalPayment) {
                          ctx.selectedStatusCollection = 1;
                        } else if (nominal == ctx.totalPayment) {
                          ctx.selectedStatusCollection = 0;
                        } else {
                          ctx.selectedStatusCollection = 2;
                        }
                        ctx.update();
                      },
                    ),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(left: 8),
                  //   padding: const EdgeInsets.all(8),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.grey),
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: Text(
                  //     ctx.statusCollection[ctx.selectedStatusCollection],
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 16),
              ctx.selectedJenisPembayaran == 1
                  ? Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: ctx.proofOfPayment.isEmpty
                            ? GestureDetector(
                                onTap: () async {
                                  var imgPath =
                                      await Get.toNamed(Routes.REPORT);
                                  if (imgPath != null) {
                                    ctx.proofOfPayment = imgPath;
                                    ctx.update();
                                  }
                                },
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'Bukti Pembayaran',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Stack(
                                children: [
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              child: Image.file(
                                                File(ctx.proofOfPayment),
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Image.file(
                                        File(ctx.proofOfPayment),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          ctx.proofOfPayment = '';
                                          ctx.update();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  var nominal = int.parse(
                    ctx.nominalController.text.replaceAll(RegExp(r'\D'), ''),
                  );
                  await ctx.savePayment(nominal);
                  if (!ctx.isToComplete) {
                    await ctx.updateCustData();
                    await ctx.checkOut();
                  }
                  ctx.printResi(ctx.idMA).then((value) {
                    ctx.completeTo();
                  });
                },
                child: Text(
                  ctx.isToComplete ? 'Cetak Ulang Struk' : 'Cetak Struk',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: ctx.isToComplete ? Get.back : null,
                child: const Text('Kembali ke Beranda'),
              )
            ],
          ),
        );
      },
    );
  }
}
