import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropdownSelectableList<Contact> extends StatefulWidget {
  final List<Contact> items;
  final String Function(Contact) displayItem;
  final void Function(List<Contact>)? onSelectionChanged;
  final bool isContact;
  final List<Contact>? selectedItems;
  final bool enabled;

  const DropdownSelectableList({
    super.key,
    required this.items,
    required this.displayItem,
    this.onSelectionChanged,
    this.isContact = true,
    this.selectedItems,
    this.enabled = true,
  });

  @override
  _DropdownSelectableListState<Contact> createState() =>
      _DropdownSelectableListState<Contact>();
}

class _DropdownSelectableListState<Contact>
    extends State<DropdownSelectableList<Contact>> {
  Contact? selectedItem;
  List<Contact> selectedItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.selectedItems != null) {
      selectedItems = List<Contact>.from(widget.selectedItems!);
    }
  }

  @override
  void didUpdateWidget(covariant DropdownSelectableList<Contact> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItems != null &&
        !areListsEqual(widget.selectedItems!, oldWidget.selectedItems!)) {
      setState(() {
        selectedItems = List<Contact>.from(widget.selectedItems!);
      });
    }
  }

  bool areListsEqual(List<Contact> list1, List<Contact> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownSearch<Contact>(
          enabled: widget.enabled,
          onChanged: (Contact? newValue) {
            setState(() {
              selectedItem = newValue;
              if (newValue != null && !selectedItems.contains(newValue)) {
                selectedItems.add(newValue);
                if (widget.onSelectionChanged != null) {
                  widget.onSelectionChanged!(selectedItems);
                }
              }
            });
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          items: widget.items,
          itemAsString: (Contact item) => widget.displayItem(item),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            disabledItemFn: (Contact item) => selectedItems.contains(item),
            menuProps: MenuProps(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        selectedItems.isEmpty
            ? ListTile(
                title: Text(
                  'Belum ada ${widget.isContact ? 'penerima' : 'produk'} yang dipilih',
                  style: const TextStyle(color: Colors.grey),
                ),
              )
            : ExpansionTile(
                title: Text(
                    '${widget.isContact ? 'Penerima' : 'Produk'} yang dipilih'),
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      spacing: 8,
                      runSpacing: 0,
                      children: selectedItems.map((item) {
                        return Chip(
                          label: Text(widget.displayItem(item)),
                          onDeleted: !widget.enabled
                              ? null
                              : () {
                                  // if (!widget.enabled) return;
                                  setState(() {
                                    selectedItems.remove(item);
                                    if (widget.onSelectionChanged != null) {
                                      widget.onSelectionChanged!(selectedItems);
                                    }
                                  });
                                },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
