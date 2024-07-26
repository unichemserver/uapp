import 'package:flutter/material.dart';
import 'package:uapp/modules/marketing/visitasi/noo/noo_options.dart';

class OwnershipChoice extends StatelessWidget {
  const OwnershipChoice({super.key});

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
            selected: false,
            onSelected: (value) {},
          );
        },
      ),
    );
  }
}
