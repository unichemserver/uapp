import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_signature/signature.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uapp/core/utils/rupiah_formatter.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/models/item.dart';
import 'package:uapp/models/to.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';

class TakingOrderPage extends StatelessWidget {
  TakingOrderPage({super.key});

  HandSignatureControl control = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  String ttdPath = '';

  ValueNotifier<String?> svg = ValueNotifier<String?>(null);
  ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);
  ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);
  final totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketingController>(
      init: MarketingController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Taking Order',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: const SizedBox(),
          ),
          body: _buildBody(context, ctx.takingOrders, ctx),
        );
      },
    );
  }

  _buildBody(
    BuildContext context,
    List<To> takingOrders,
    MarketingController ctx,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DataTable(
            columnSpacing: 16.0,
            columns: const [
              DataColumn(label: Text('No')),
              DataColumn(label: Text('Nama')),
              DataColumn(label: Text('Jumlah')),
              DataColumn(label: Text('Satuan')),
              DataColumn(label: Text('Total')),
            ],
            rows: takingOrders
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text('${e.id}')),
                      DataCell(Text(e.description)),
                      DataCell(Text(e.quantity.toString())),
                      DataCell(Text(e.unit.toString())),
                      DataCell(Text(e.price.toString())),
                    ],
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              var nama = '';
              var itemID = '';
              var jumlah = '';
              var satuan = '';
              var unitID = '';
              Get.dialog(
                Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Tambah Produk'),
                        const SizedBox(height: 16),
                        DropdownSearch<Item>(
                          items: ctx.items,
                          itemAsString: (Item item) => item.description,
                          onChanged: (Item? item) {
                            nama = item!.description;
                            itemID = item.itemid;
                            unitID = item.inventoryUnit;
                            ctx.update();
                          },
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: 'Cari produk',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Jumlah',
                            suffixText: unitID,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            jumlah = value.replaceAll(RegExp(r'[^0-9]'), '');
                            if (satuan.isNotEmpty && jumlah.isNotEmpty) {
                              var total = (int.parse(satuan) * int.parse(jumlah))
                                  .toString();
                              var rupiahFormat = NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp',
                              );
                              // remove character comma and after the comma
                              totalController.text = rupiahFormat.format(int.parse(total)).replaceAll(RegExp(r',00'), '');
                            } else {
                              totalController.text = '';
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Satuan',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            RupiahInputFormatter(),
                          ],
                          onChanged: (value) {
                            satuan = value.replaceAll(RegExp(r'[^0-9]'), '');
                            if (satuan.isNotEmpty && jumlah.isNotEmpty) {
                              var total = (int.parse(satuan) * int.parse(jumlah))
                                  .toString();
                              var rupiahFormat = NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp',
                              );
                              totalController.text = rupiahFormat.format(int.parse(total)).replaceAll(RegExp(r',00'), '');
                            } else {
                              totalController.text = '';
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          readOnly: true,
                          controller: totalController,
                          decoration: const InputDecoration(
                            labelText: 'Total',
                          ),
                          onChanged: (value) {
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            var total = totalController.text.replaceAll(RegExp(r'[^0-9]'), '');
                            ctx.addTakingOrderToDatabase(
                              itemID,
                              nama,
                              int.parse(jumlah),
                              satuan,
                              int.parse(total),
                            );
                            Get.back();
                          },
                          child: const Text('Simpan'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: const Text('Tambah Produk'),
          ),
          const Divider(),
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
            onTap: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Tanda Tangan'),
                  content: Container(
                    height: 500,
                    width: 300,
                    color: Colors.grey[200],
                    child: HandSignature(
                      control: control,
                      type: SignatureDrawType.shape,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        control.clear();
                      },
                      child: const Text('Hapus'),
                    ),
                    TextButton(
                      onPressed: () async {
                        var path = await Utils.saveSignature(control.toImage());
                        ttdPath = path!;
                        ctx.insertTtd(path);
                        rawImage.value = await control.toImage();
                        ctx.update();
                        Get.back();
                      },
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
              );
            },
            child: Align(
              alignment: Alignment.center,
              child: ttdPath.isEmpty ? Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  ValueListenableBuilder<ByteData?>(
                  valueListenable: rawImage,
                  builder: (context, value, child) {
                    if (value == null) {
                      return const SizedBox();
                    }
                    return Image.memory(
                      value.buffer.asUint8List(),
                      fit: BoxFit.cover,
                    );
                  },
                ) ,
              ): Image.file(
                File(ttdPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
