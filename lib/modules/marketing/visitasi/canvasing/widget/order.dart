import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_signature/signature.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/rupiah_formatter.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/models/item.dart';
import 'package:uapp/models/to.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/canvasing_controller.dart';

class OrderWidget extends StatelessWidget {
  OrderWidget({super.key});

  HandSignatureControl control = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  ValueNotifier<String?> svg = ValueNotifier<String?>(null);
  ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);
  ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

  // final totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CanvasingController>(
      init: CanvasingController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          body: _buildBody(context, ctx.takingOrders, ctx),
        );
      },
    );
  }

  _buildBody(
    BuildContext context,
    List<To> takingOrders,
    CanvasingController ctx,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: takingOrders.length,
            itemBuilder: (context, index) {
              var item = takingOrders[index];
              return ListTile(
                onTap: ctx.isToComplete
                    ? () {}
                    : () {
                        _openOrderDialog(context, ctx, item);
                      },
                title: Text(item.description),
                subtitle: Text(
                  '${item.quantity} * ${Utils.formatCurrency(item.unit)}',
                ),
                leading: Text('${index + 1}'),
                trailing: Text(
                  Utils.formatCurrency(item.price.toString()),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: ctx.isToComplete
                ? null
                : () {
                    _openOrderDialog(context, ctx, null);
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
            onTap: ctx.isToComplete
                ? () {}
                : () {
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
                              var path =
                                  await Utils.saveSignature(control.toImage());
                              ctx.ttdPath = path!;
                              ctx.inserTtd();
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
              child: ctx.ttdPath.isEmpty
                  ? Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ValueListenableBuilder<ByteData?>(
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
                      ),
                    )
                  : Image.file(
                      File(ctx.ttdPath),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _openOrderDialog(
    BuildContext context,
    CanvasingController ctx,
    To? toEdit,
  ) {
    var nama = TextEditingController(
      text: toEdit != null ? toEdit.description : '',
    );
    var itemID = TextEditingController(
      text: toEdit != null ? toEdit.itemid.toString() : '',
    );
    var jumlah = TextEditingController(
      text: toEdit != null ? toEdit.quantity.toString() : '',
    );
    var satuan = TextEditingController(
      text: toEdit != null ? Utils.formatCurrency(toEdit.unit) : '',
    );
    var total = TextEditingController(
      text: toEdit != null ? Utils.formatCurrency(toEdit.price.toString()) : '',
    );
    final formKey = GlobalKey<FormState>();
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Tambah Produk'),
                  const SizedBox(height: 16),
                  DropdownSearch<Item>(
                    items: ctx.items,
                    itemAsString: (Item item) => item.description,
                    selectedItem: toEdit != null
                        ? ctx.items.firstWhere(
                            (element) => element.itemid == toEdit.itemid,
                          )
                        : null,
                    onChanged: (Item? item) {
                      nama.text = item!.description;
                      itemID.text = item.itemid;
                      ctx.update();
                    },
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      // disable item that have field in ctx.takingOrders
                      disabledItemFn: toEdit == null
                          ? (Item item) {
                              return ctx.takingOrders
                                  .map((e) => e.description)
                                  .contains(item.description);
                            }
                          : null,
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
                  TextFormField(
                    controller: jumlah,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Jumlah tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Jumlah',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final box = Hive.box(HiveKeys.appBox);
                      final baseUrl = box.get(HiveKeys.baseURL);
                      bool isUnichem = baseUrl.contains('unichem');
                      if (isUnichem) {
                        if (value.isEmpty) {
                          satuan.text = '';
                          total.text = '';
                        } else if (itemID.text ==
                                'BJW8-RP-0250G-00B10-DAU002' ||
                            itemID.text == 'BJW8-RP-0250G-00B10-DAU001') {
                          int? jumlahInt = int.tryParse(jumlah.text);
                          if (jumlahInt != null && jumlahInt > 25) {
                            satuan.text = '66500';
                          } else {
                            satuan.text = '67500';
                          }
                        } else if (itemID.text == 'XXXX-XX-XXXXX-XXXXX-XXXXX') {
                          satuan.text = '10000';
                        } else if (itemID.text == 'BP-905-0219030' ||
                            itemID.text == 'BP-904-0188640') {
                          satuan.text = '0';
                        }
                      }
                      jumlah.text = value.replaceAll(RegExp(r'[^0-9]'), '');
                      if (satuan.text.isNotEmpty && jumlah.text.isNotEmpty) {
                        var totalPayment =
                            (int.parse(satuan.text) * int.parse(jumlah.text))
                                .toString();
                        var rupiahFormat = NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp',
                        );
                        total.text = rupiahFormat
                            .format(int.parse(totalPayment))
                            .replaceAll(RegExp(r',00'), '');
                      } else {
                        total.text = '';
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: satuan,
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Satuan tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Harga Satuan',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      RupiahInputFormatter(),
                    ],
                    onChanged: (value) {
                      satuan.text = value.replaceAll(RegExp(r'[^0-9]'), '');
                      if (satuan.text.isNotEmpty && jumlah.text.isNotEmpty) {
                        total.text =
                            (int.parse(satuan.text) * int.parse(jumlah.text))
                                .toString();
                        var rupiahFormat = NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp',
                        );
                        total.text = rupiahFormat
                            .format(int.parse(total.text))
                            .replaceAll(RegExp(r',00'), '');
                      } else {
                        total.text = '';
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    controller: total,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Total tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Total',
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      toEdit != null
                          ? IconButton(
                              onPressed: () {
                                ctx.deleteTakingOrder(toEdit.itemid);
                                Get.back();
                              },
                              icon: const Icon(Icons.delete),
                            )
                          : const SizedBox(),
                      ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          int jumlahProduct = int.parse(
                              jumlah.text.replaceAll(RegExp(r'[^0-9]'), ''));
                          int satuanProduct = int.parse(
                              satuan.text.replaceAll(RegExp(r'[^0-9]'), ''));
                          int totalPrice = jumlahProduct * satuanProduct;
                          if (toEdit != null) {
                            ctx.updateTakingOrder(
                              toEdit.itemid,
                              toEdit.description,
                              jumlahProduct,
                              satuanProduct.toString(),
                              totalPrice,
                            );
                            Get.back();
                            return;
                          }
                          ctx
                              .addTakingOrder(
                            itemID.text,
                            nama.text,
                            jumlahProduct,
                            satuanProduct.toString(),
                            totalPrice,
                          )
                              .then((value) {
                            total.clear();
                          });
                          Get.back();
                        },
                        child: const Text('Simpan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
