import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropdownList<T> extends StatelessWidget {
  const DropdownList({
    super.key,
    required this.onChanged,
    required this.items,
    required this.displayItem,
    this.warningText = 'Pilih salah satu',
    this.selectedItem,
  });

  final void Function(T?)? onChanged;
  final List<T> items;
  final String Function(T) displayItem;
  final String? warningText;
  final T? selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      enabled: onChanged != null,
      selectedItem: selectedItem,
      onChanged: onChanged,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      autoValidateMode: AutovalidateMode.onUserInteraction,
      validator: (T? value) {
        if (value == null || value == '') {
          return warningText;
        }
        return null;
      },
      items: items,
      itemAsString: displayItem,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        menuProps: MenuProps(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
