import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/marketing/model/master_item.dart';
import 'package:uapp/modules/marketing/model/price_list.dart';
import 'package:uapp/modules/marketing/model/to_model.dart';

class ToReportDialog extends StatefulWidget {
  const ToReportDialog({
    super.key,
    required this.items,
    required this.idMA,
    required this.priceList,
  });

  final List<MasterItem> items;
  final String idMA;
  final List<PriceList> priceList;

  @override
  State<ToReportDialog> createState() => _ToReportDialogState();
}

class _ToReportDialogState extends State<ToReportDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final List<String> _topID = [];
  final List<String> _listUnit = [];
  List<PriceList> _priceList = [];
  MasterItem? _selectedItem;
  String selectedUnit = '';
  String selectedTopID = '';

  @override
  void dispose() {
    _quantityController.dispose();
    _unitController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _calculateTotal(String value) {
    if (value.isEmpty) return;
    final quantity = int.tryParse(value) ?? 0;
    final unitValue =
        int.tryParse(_unitController.text.replaceAll('.', '')) ?? 0;
    _totalController.text = (quantity * unitValue).toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  void _onSave() {
    if (_formKey.currentState?.validate() == true && _selectedItem != null) {
      final data = ToModel(
        idMA: widget.idMA,
        itemid: _selectedItem!.itemID!,
        description: _selectedItem!.description!,
        quantity: int.parse(_quantityController.text),
        unit: _unitController.text,
        price: int.parse(_totalController.text.replaceAll('.', '')),
        topID: selectedTopID,
        unitID: selectedUnit,
      );
      Navigator.of(context).pop(data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_formKey.currentState?.validate() == true
              ? 'Pilih produk terlebih dahulu'
              : 'Isi semua field'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TO - Tambah Produk'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const Text('Pilih Produk'),
                      _buildItemDropdown(),
                      _buildUnitDropdown(),
                      _buildTopIDDropdown(),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              controller: _quantityController,
                              label: 'Jumlah',
                              maxLength: 5,
                              keyboardType: TextInputType.number,
                              onChanged: _calculateTotal,
                              suffixIcon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(selectedUnit),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            flex: 3,
                            child: AppTextField(
                              controller: _unitController,
                              label: 'Satuan',
                              keyboardType: TextInputType.number,
                              prefixIcon: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Rp'),
                                ],
                              ),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      const SizedBox(height: 16.0),
                      AppTextField(
                        controller: _totalController,
                        label: 'Total',
                        prefixIcon: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Rp'),
                          ],
                        ),
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48.0),
                  ),
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemDropdown() {
    return DropdownSearch<MasterItem>(
      items: widget.items,
      itemAsString: (MasterItem item) => item.description!,
      onChanged: (MasterItem? item) {
        _priceList = widget.priceList
            .where((element) => element.itemID == item?.itemID)
            .toList();
        _topID.clear();
        _listUnit.clear();
        for (var i = 0; i < _priceList.length; i++) {
          if (!_topID.contains(_priceList[i].topID!)) {
            _topID.add(_priceList[i].topID!.trim());
          }
          if (!_listUnit.contains(_priceList[i].unitID)) {
            _listUnit.add(_priceList[i].unitID!.trim());
          }
          Log.d('topID: ${_priceList[i].toJson()}');
        }
        _selectedItem = item;
        setState(() {});
      },
      popupProps: PopupProps.menu(
        showSearchBox: true,
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

  Widget _buildUnitDropdown() {
    if (_listUnit.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        const Text('Pilih Unit Produk'),
        DropdownSearch<String>(
          items: _listUnit,
          onChanged: (String? value) {
            setState(() {
              selectedUnit = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTopIDDropdown() {
    if (_topID.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        const Text('Pilih Term of Payment (TOP)'),
        DropdownSearch<String>(
          items: _topID,
          onChanged: (String? value) {
            selectedTopID = value!;
            for (var i = 0; i < _priceList.length; i++) {
              if (_priceList[i].topID == selectedTopID &&
                  _priceList[i].unitID == selectedUnit) {
                var unitPrice = _priceList[i].unitPrice.toString();
                unitPrice = unitPrice.contains('.00')
                    ? unitPrice.substring(0, unitPrice.length - 3)
                    : unitPrice;
                _unitController.text = unitPrice.replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (Match m) => '${m[1]}.');
                break;
              }
            }
          },
        ),
      ],
    );
  }
}
