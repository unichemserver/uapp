import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:uapp/core/utils/log.dart';
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
  final TextEditingController ppnController = TextEditingController();

  void _initData() {
    if (widget.toEdit != null) {
      nama.text = widget.toEdit!.description!;
      itemID.text = widget.toEdit!.itemid!;
      jumlah.text = widget.toEdit!.quantity.toString();
      satuan.text = Utils.formatCurrency(widget.toEdit!.unit!);
      total.text = Utils.formatCurrency(widget.toEdit!.price.toString());
      ppnController.text = Utils.formatCurrency(widget.toEdit!.ppn.toString());
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
    ppnController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Produk'),
        ),
        body: GetBuilder<CanvasingController>(
          init: CanvasingController(),
          builder: (ctx) {
            return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          const Text('Pilih Produk'),
                          _buildItemDropdown(ctx),
                          _buildUnitDropdown(ctx),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildJumlahField(ctx),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: satuan,
                                  readOnly: true,
                                  inputFormatters: [
                                    RupiahInputFormatter(),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Harga Satuan',
                                    prefix: const Text('Rp'),
                                    suffix: Text('/${ctx.selectedUnit}'),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Satuan tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: ppnController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'PPN',
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: total,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Total (Termasuk PPN)',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Total tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              int jumlahProduct = int.parse(jumlah.text.replaceAll(RegExp(r'[^0-9]'), ''));
                              int satuanProduct = int.parse(satuan.text.replaceAll(RegExp(r'[^0-9]'), ''));
                              int ppnValue = int.parse(ppnController.text.replaceAll(RegExp(r'[^0-9]'), ''));
                              int totalPrice = jumlahProduct * satuanProduct;
                              var data = ToModel(
                                itemid: itemID.text,
                                description: nama.text,
                                quantity: jumlahProduct,
                                unit: satuanProduct.toString(),
                                price: totalPrice,
                                ppn: ppnValue,
                              );
                              ctx.addTakingOrder(data);
                              ctx.selectedUnit = '';
                              ctx.update();
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text('Simpan'),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: widget.toEdit != null
                                ? () async {
                                    // Log.d('Delete ${widget.toEdit!.itemid!}');
                                    ctx.deleteTakingOrder(widget.toEdit!.itemid!);
                                    Get.back();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              'Hapus',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItemDropdown(CanvasingController ctx) {
    return DropdownSearch<MasterItem>(
      items: ctx.items,
      itemAsString: (MasterItem item) => item.description!,
      selectedItem: widget.toEdit != null
          ? ctx.items.firstWhere((element) => element.itemID == widget.toEdit!.itemid)
          : null,
      onChanged: (MasterItem? item) {
        nama.text = item!.description!;
        itemID.text = item.itemID!;
        var selectedprice = ctx.priceList.where((element) {
          return element.itemID == item.itemID && element.topID == 'COD';
        }).toList();

        if (selectedprice.length > 1 &&
            (item.itemID != 'BP-904-0188640' && item.itemID != 'BP-905-0219030')) {
          selectedprice = selectedprice.where((element) => element.topID == 'COD').toList();
        }

        ctx.selectedPPNCode = item.taxGroupID!;

        // Set initial unit price
        var initialPrice = int.parse(selectedprice.first.unitPrice.toString().replaceAll(RegExp(r'\.00$'), ''));
        satuan.text = initialPrice.toString();

        ctx.unitItem.clear();
        for (var element in selectedprice) {
          if (!ctx.unitItem.contains(element.unitID)) {
            ctx.unitItem.add(element.unitID!);
          }
        }
        ctx.unitItem = ctx.unitItem.toSet().toList(); // Remove duplicates
        if (nama.text.contains('MANGKOK') || nama.text.contains('BASKOM')) {
          satuan.text = '0';
        }

        ctx.selectedUnit = '';
        ctx.update();
      },
      popupProps: PopupProps.menu(
        showSearchBox: true,
        disabledItemFn: widget.toEdit == null
            ? (MasterItem item) {
                return ctx.takingOrders.map((e) => e.description).contains(item.description);
              }
            : null,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Cari produk',
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJumlahField(CanvasingController ctx) {
    return TextFormField(
      controller: jumlah,
      decoration: InputDecoration(
        labelText: 'Jumlah',
        suffix: Text(ctx.selectedUnit),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Jumlah tidak boleh kosong';
        }
        return null;
      },
      onChanged: (value) {
        jumlah.text = value.replaceAll(RegExp(r'[^0-9]'), '');
        if (jumlah.text.isNotEmpty) {
          var quantity = int.parse(jumlah.text);

          // Adjust unit price based on quantity
          var selectedprice = ctx.priceList.where((element) {
            return element.itemID == itemID.text && element.topID == 'COD';
          }).toList();

          var price = int.parse(selectedprice.first.unitPrice.toString().replaceAll(RegExp(r'\.00$'), ''));
          if (quantity >= 10) {
            var qty10Price = selectedprice.firstWhere(
              (element) => double.parse(element.qty.toString()) == 10.0,
              orElse: () => selectedprice.first,
            );
            price = int.parse(qty10Price.unitPrice.toString().replaceAll(RegExp(r'\.00$'), ''));
          }
          satuan.text = price.toString();

          // Calculate total and PPN
          var totalPayment = price * quantity;
          double ppnRate = (ctx.selectedPPNCode == 'PPN1108') ? 0.0 : 0.11;
          var ppnValue = (totalPayment * ppnRate).toInt();

          var rupiahFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
          ppnController.text = rupiahFormat.format(ppnValue).replaceAll(RegExp(r',00'), '');
          total.text = rupiahFormat.format(totalPayment + ppnValue).replaceAll(RegExp(r',00'), '');
        } else {
          ppnController.text = '';
          total.text = '';
        }
      },
    );
  }

  Widget _buildUnitDropdown(CanvasingController ctx) {
    if (ctx.unitItem.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        const Text('Pilih Unit Produk'),
        DropdownSearch<String>(
          items: ctx.unitItem,
          selectedItem: ctx.selectedUnit,
          onChanged: (String? item) {
            if (item != null) {
              var price = ctx.priceList
                  .where((element) => element.itemID == itemID.text && element.unitID == item)
                  .first
                  .unitPrice
                  .toString()
                  .replaceAll(RegExp(r'\.00$'), '');
              satuan.text = int.parse(price).toString();
              ctx.selectedUnit = item;
              ctx.update();
            }
            if (nama.text.contains('MANGKOK') || nama.text.contains('BASKOM')) {
              satuan.text = '0';
            }
          },
        ),
      ],
    );
  }
}