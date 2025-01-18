import 'package:flutter/material.dart';
import 'package:uapp/core/widget/app_textfield.dart';
import 'package:uapp/modules/memo/widget/dropdown_list.dart';
import 'package:uapp/modules/memo/widget/label_text.dart';
import 'package:uapp/modules/production/data/model/warehouse.dart';
import 'package:uapp/modules/production/data/production_api_service.dart'
    as api;

class FilterBalanceWidget extends StatefulWidget {
  const FilterBalanceWidget({
    super.key,
    required this.startDateCtrl,
    required this.endDateCtrl,
    required this.onWarehouseSelected,
  });

  final TextEditingController startDateCtrl;
  final TextEditingController endDateCtrl;
  final void Function(Warehouse?)? onWarehouseSelected;

  @override
  State<FilterBalanceWidget> createState() => _FilterBalanceWidgetState();
}

class _FilterBalanceWidgetState extends State<FilterBalanceWidget> {
  List<Warehouse> warehouse = [];

  Future<void> _selectDate(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      initialDate: controller.text.isEmpty
          ? DateTime.now()
          : DateTime.parse(controller.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      var selectedDate = date.toString().substring(0, 10);
      controller.text = selectedDate;
    }
  }

  Future<void> getWarehouse() async {
    setState(() {
      warehouse.add(Warehouse(locationId: '', locationName: 'Memuat data lokasi...'));
    });
    final data = await api.getWarehouse();
    warehouse.clear();
    setState(() {
      warehouse.add(Warehouse(locationId: '', locationName: 'Semua Gudang'));
      warehouse.addAll(data);
    });
  }

  @override
  initState() {
    super.initState();
    getWarehouse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AppTextField(
                controller: widget.startDateCtrl,
                readOnly: true,
                hintText: 'Tanggal Awal',
                onTap: () => _selectDate(widget.startDateCtrl),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal Awal tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              child: const Center(
                child: Text('s/d'),
              ),
            ),
            Expanded(
              child: AppTextField(
                controller: widget.endDateCtrl,
                readOnly: true,
                hintText: 'Tanggal Akhir',
                onTap: () => _selectDate(widget.endDateCtrl),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal Akhir tidak boleh kosong';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const LabelText(label: 'Pilih Gudang'),
        DropdownList<Warehouse>(
          selectedItem: warehouse.first,
          onChanged: widget.onWarehouseSelected,
          items: warehouse,
          displayItem: (item) {
            if (item.locationId == '') {
              return item.locationName;
            }
            return '${item.locationId} - ${item.locationName}';
          },
        ),
      ],
    );
  }
}
