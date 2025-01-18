import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uapp/core/utils/rupiah_formatter.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/modules/marketing/model/master_item.dart';
import 'package:uapp/modules/marketing/model/to_model.dart';
import 'package:uapp/modules/marketing/visitasi/canvasing/canvasing_controller.dart';

class ToDialog extends StatefulWidget {
  const ToDialog({super.key, required this.toEdit});

  final ToModel? toEdit;

  @override
  State<ToDialog> createState() => _ToDialogState();
}

class _ToDialogState extends State<ToDialog> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nama = TextEditingController();
  final TextEditingController itemID = TextEditingController();
  final TextEditingController jumlah = TextEditingController();
  final TextEditingController satuan = TextEditingController();
  final TextEditingController total = TextEditingController();

  void _initData() {
    if (widget.toEdit != null) {
      nama.text = widget.toEdit!.description!;
      itemID.text = widget.toEdit!.itemid!;
      jumlah.text = widget.toEdit!.quantity.toString();
      satuan.text = Utils.formatCurrency(widget.toEdit!.unit!);
      total.text = Utils.formatCurrency(widget.toEdit!.price.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    nama.dispose();
    itemID.dispose();
    jumlah.dispose();
    satuan.dispose();
    total.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: GetBuilder<CanvasingController>(
              init: CanvasingController(),
              initState: (_) {},
              builder: (ctx) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownSearch<MasterItem>(
                      items: ctx.items,
                      itemAsString: (MasterItem item) => item.description!,
                      selectedItem: widget.toEdit != null
                          ? ctx.items.firstWhere(
                              (element) =>
                                  element.itemID == widget.toEdit!.itemid,
                            )
                          : null,
                      onChanged: (MasterItem? item) {
                        nama.text = item!.description!;
                        itemID.text = item.itemID!;
                        var selectedprice = ctx.priceList.where((element) {
                          return element.itemID == item.itemID;
                        }).toList();
                        if (selectedprice.length > 1 &&
                            (item.itemID != 'BP-904-0188640' ||
                                item.itemID != 'BP-905-0219030')) {
                          selectedprice = selectedprice
                              .where((element) => element.topID == 'COD')
                              .toList();
                        }
                        var price = selectedprice.first.unitPrice
                            .toString()
                            .replaceAll(RegExp(r'\.00$'), '');
                        satuan.text = int.parse(price).toString();
                        ctx.unitItem.clear();
                        for (var element in selectedprice) {
                          ctx.unitItem.add(element.unitID!);
                        }
                        if (nama.text.contains('MANGKOK') ||
                            nama.text.contains('BASKOM')) {
                          satuan.text = '0';
                        }
                        ctx.selectedUnit = '';
                        ctx.update();
                      },
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        disabledItemFn: widget.toEdit == null
                            ? (MasterItem item) {
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Satuan'),
                      ],
                    ),
                    DropdownSearch<String>(
                      items: ctx.unitItem,
                      selectedItem: ctx.selectedUnit,
                      onChanged: (String? item) {
                        if (item != null) {
                          var price = ctx.priceList
                              .where((element) =>
                                  element.itemID == itemID.text &&
                                  element.unitID == item)
                              .first
                              .unitPrice
                              .toString()
                              .replaceAll(RegExp(r'\.00$'), '');
                          satuan.text = int.parse(price).toString();
                          ctx.selectedUnit = item;
                          ctx.update();
                        }
                        if (nama.text.contains('MANGKOK') ||
                            nama.text.contains('BASKOM')) {
                          satuan.text = '0';
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: jumlah,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Jumlah tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Jumlah',
                        suffix: Text(ctx.selectedUnit),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: satuan,
                      readOnly: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Satuan tidak boleh kosong';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Harga Satuan',
                        prefix: const Text('Rp'),
                        suffix: Text('/${ctx.selectedUnit}'),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    ElevatedButton(
                      onPressed: widget.toEdit != null
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              int jumlahProduct = int.parse(jumlah.text
                                  .replaceAll(RegExp(r'[^0-9]'), ''));
                              int satuanProduct = int.parse(satuan.text
                                  .replaceAll(RegExp(r'[^0-9]'), ''));
                              int totalPrice = jumlahProduct * satuanProduct;
                              var data = ToModel(
                                itemid: itemID.text,
                                description: nama.text,
                                quantity: jumlahProduct,
                                unit: satuanProduct.toString(),
                                price: totalPrice,
                              );
                              ctx.addTakingOrder(data);
                              ctx.selectedUnit = '';
                              ctx.update();
                              Get.back();
                            },
                      child: const Text('Simpan'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
