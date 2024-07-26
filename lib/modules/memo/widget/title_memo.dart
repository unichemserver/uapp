import 'package:flutter/material.dart';

class TitleMemo extends StatelessWidget {
  const TitleMemo({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
      textAlign: TextAlign.center,
    ); // Text;
  }
}
