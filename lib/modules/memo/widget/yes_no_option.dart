import 'package:flutter/material.dart';

class YesNoOption extends StatelessWidget {
  YesNoOption({
    super.key,
    required this.selectedOption,
    required this.onSelected,
  });

  final int selectedOption;
  final ValueChanged<int> onSelected;
  final List<String> options = ['Ya', 'Tidak'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 10,
        alignment: WrapAlignment.end,
        children: options.map((option) {
          return ChoiceChip(
            label: Text(option),
            selected: selectedOption == options.indexOf(option),
            onSelected: (selected) {
              onSelected(options.indexOf(option));
            },
          );
        }).toList(),
      ),
    );
  }
}
