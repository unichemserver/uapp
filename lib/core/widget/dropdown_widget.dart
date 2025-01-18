import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatefulWidget {
  final List<T> items; // List of items for the dropdown
  final String label; // Label text for the dropdown
  final String hint; // Hint text for the dropdown
  final T? selectedItem; // Initial selected item
  final bool showSearchBox; // Whether to show a search box
  final Function(T?)? onChanged; // Callback when item is selected

  const DropdownWidget({
    super.key,
    required this.items,
    this.label = 'Select Item',
    this.hint = 'Please select an item',
    this.selectedItem,
    this.showSearchBox = false,
    this.onChanged,
  });

  @override
  State<DropdownWidget<T>> createState() => _DropdownWidgetState<T>();
}

class _DropdownWidgetState<T> extends State<DropdownWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: widget.items,
      selectedItem: widget.selectedItem,
      onChanged: widget.onChanged,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
