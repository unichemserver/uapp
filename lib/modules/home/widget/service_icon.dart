import 'package:flutter/material.dart';

class ServiceIcon extends StatelessWidget {
  const ServiceIcon({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
  });

  final String title;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? Colors.blueAccent : Colors.grey[200],
          ),
          child: Center(
            child: Icon(
              icon,
              size: 50,
              color: isSelected ? Colors.white : Colors.grey[400],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(title),
      ],
    );
  }
}
