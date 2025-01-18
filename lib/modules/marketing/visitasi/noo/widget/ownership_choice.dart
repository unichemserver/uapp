import 'package:flutter/material.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_options.dart';

class OwnershipChoice extends StatefulWidget {
  const OwnershipChoice({
    super.key,
    required this.onSelected,
  });

  final Function(String) onSelected;

  @override
  State<OwnershipChoice> createState() => _OwnershipChoiceState();
}

class _OwnershipChoiceState extends State<OwnershipChoice> {
  String selectedOwnership = '';

  setSelectedOwnership(String value) {
    setState(() {
      selectedOwnership = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 0,
      children: List.generate(
        NooOptions.ownership.length,
        (index) {
          return ChoiceChip(
            label: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                NooOptions.ownership[index],
                textAlign: TextAlign.center,
              ),
            ),
            selected: selectedOwnership == NooOptions.ownership[index],
            onSelected: (value) {
              if (value) {
                setSelectedOwnership(NooOptions.ownership[index]);
                widget.onSelected(NooOptions.ownership[index]);
              }
            },
          );
        },
      ),
    );
  }
}
