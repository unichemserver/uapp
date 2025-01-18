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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: height * 0.07,
          width: width * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? Colors.blueAccent : Colors.grey[200],
          ),
          child: Center(
            child: Icon(
              icon,
              size: 30,
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
