import 'package:flutter/material.dart';
import 'package:uapp/modules/hrd/utils/jenis_tamu_opt.dart';

class FilterDialog extends StatefulWidget {
  final List<JenisTamu> items;
  final JenisTamu? selectedJenisTamu;
  final Function(JenisTamu) onSelected;
  final VoidCallback onApply;

  const FilterDialog({
    super.key,
    required this.items,
    this.selectedJenisTamu,
    required this.onSelected,
    required this.onApply,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  JenisTamu? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedJenisTamu;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Tamu'),
      content: Wrap(
        children: widget.items.map((item) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ChoiceChip(
              label: Text(item.title),
              selected: selectedValue == item,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    selectedValue = item;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            widget.onSelected(selectedValue!);
            widget.onApply();
            Navigator.pop(context);
          },
          child: const Text('Terapkan'),
        ),
      ],
    );
  }
}
