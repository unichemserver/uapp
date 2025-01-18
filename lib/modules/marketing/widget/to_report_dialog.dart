import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uapp/core/hive/hive_keys.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/marketing/model/master_item.dart';
import 'package:uapp/modules/marketing/model/to_model.dart';
import 'package:uapp/modules/marketing/model/unit_set.dart';

class ToReportDialog extends StatefulWidget {
  const ToReportDialog({
    super.key,
    required this.items,
    required this.idMA,
  });

  final List<MasterItem> items;
  final String idMA;

  @override
  State<ToReportDialog> createState() => _ToReportDialogState();
}

class _ToReportDialogState extends State<ToReportDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  List<UnitSet> _unitSet = [];
  List<UnitSet> _filteredUnitSet = [];
  MasterItem? _selectedItem;
  UnitSet? _selectedUnit;
  late Box box;

  @override
  void initState() {
    super.initState();
    _initializeBox();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _unitController.dispose();
    _totalController.dispose();
    box.close();
    super.dispose();
  }

  Future<void> _initializeBox() async {
    box = await Hive.openBox<UnitSet>(HiveKeys.unitSetBox);
    _unitSet = box.values.cast<UnitSet>().toList();
  }

  void _filterUnitSet(String? unitSetID) {
    if (unitSetID != null) {
      _filteredUnitSet = _unitSet
          .where((unit) => unit.unitSetID == unitSetID)
          .toList();
      setState(() {});
    }
  }

  void _calculateTotal() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final unitValue = int.tryParse(_unitController.text) ?? 0;
    _totalController.text = (quantity * unitValue).toString();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() == true && _selectedItem != null) {
      final data = ToModel(
        idMA: widget.idMA,
        itemid: _selectedItem!.itemID!,
        description: _selectedItem!.description!,
        quantity: int.parse(_quantityController.text),
        unit: _unitController.text,
        price: int.parse(_totalController.text),
      );
      Navigator.of(context).pop(data);
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
                      _buildItemDropdown(),
                      const SizedBox(height: 16.0),
                      _buildQuantityRow(),
                      const SizedBox(height: 16.0),
                      _buildUnitField(),
                      const SizedBox(height: 16.0),
                      AppTextField(
                        controller: _totalController,
                        label: 'Total',
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
        Log.d('Selected item: ${item?.toJson()}');
        setState(() {
          _filterUnitSet(item?.unitSetID);
          _selectedItem = item;
        });
      },
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: 'Cari produk',
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityRow() {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            controller: _quantityController,
            label: 'Jumlah',
            onChanged: (_) => _calculateTotal(),
          ),
        ),
        const SizedBox(width: 16.0),
        if (_filteredUnitSet.isNotEmpty)
          DropdownButton<UnitSet>(
            value: _selectedUnit,
            items: _filteredUnitSet
                .map((unit) => DropdownMenuItem(
              value: unit,
              child: Text(unit.unitID!),
            ))
                .toList(),
            onChanged: (value) {
              Log.d('Selected unit: ${value?.toJson()}');
              setState(() {
                _selectedUnit = value;
              });
            },
          ),
      ],
    );
  }

  Widget _buildUnitField() {
    return AppTextField(
      controller: _unitController,
      label: 'Satuan',
      keyboardType: TextInputType.number,
      onChanged: (_) => _calculateTotal(),
    );
  }
}

