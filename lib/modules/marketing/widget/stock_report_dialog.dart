import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uapp/app/routes.dart';
import 'package:uapp/modules/marketing/marketing_controller.dart';
import 'package:uapp/modules/marketing/model/master_item.dart';
import 'package:uapp/modules/marketing/model/stock_model.dart';

class StockReportDialog extends StatefulWidget {
  const StockReportDialog({
    super.key,
    this.stockData,
    required this.items,
    required this.idMA,
  });

  final StockModel? stockData;
  final String idMA;
  final List<MasterItem> items;

  @override
  State<StockReportDialog> createState() => _StockReportDialogState();
}

class _StockReportDialogState extends State<StockReportDialog> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  String imagePath = '';
  final formKey = GlobalKey<FormState>();
  MasterItem? selectedStockName;

  @override
  void initState() {
    super.initState();
    if (widget.stockData != null) {
      productNameController.text = widget.stockData!.name!;
      quantityController.text = widget.stockData!.quantity.toString();
      unitController.text = widget.stockData!.unit!;
      imagePath = widget.stockData!.imagePath!;
      selectedStockName = widget.items.firstWhere(
        (element) => element.description == widget.stockData!.name,
      );
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    quantityController.dispose();
    unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Tambah Laporan Stok'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            Get.find<MarketingController>().getListItem();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          'Nama Produk',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        DropdownSearch<MasterItem>(
                          items: widget.items,
                          itemAsString: (MasterItem item) => item.description!,
                          selectedItem: selectedStockName,
                          onChanged: (MasterItem? item) {
                            productNameController.text = item!.description!;
                            unitController.text = item.salesUnit!;
                            selectedStockName = item;
                            setState(() {});
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
                        const SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          'Jumlah',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Jumlah produk tidak boleh kosong';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Masukkan jumlah produk',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                readOnly: true,
                                controller: unitController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Satuan produk tidak boleh kosong';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'satuan produk',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        imagePath.isEmpty
                            ? Container(
                                alignment: Alignment.center,
                                height: 200.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add_a_photo),
                                      onPressed: () async {
                                        var imagePath = await Navigator.pushNamed(
                                            context, Routes.REPORT);
                                        if (imagePath != null) {
                                          setState(() {
                                            this.imagePath = imagePath.toString();
                                          });
                                        }
                                      },
                                    ),
                                    const Text('Tidak ada gambar yang dipilih'),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Image.file(
                                          File(imagePath),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Tutup'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                imagePath = '';
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Hapus Foto'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Image.file(
                                  File(imagePath),
                                ),
                              ),
                        const SizedBox(
                          height: 16.0,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (imagePath.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Gambar tidak boleh kosong'),
                              ),
                            );
                          } else {
                            var stockData = StockModel(
                              idMA: widget.idMA,
                              itemId: selectedStockName!.itemID!,
                              name: selectedStockName!.description!,
                              quantity: int.parse(quantityController.text),
                              unit: unitController.text,
                              imagePath: imagePath,
                            );
                            Navigator.pop(context, stockData);
                            // print(stockData.toJson());
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48.0),
                      ),
                      child: const Text('Simpan'),
                    ),
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
