import 'package:flutter/material.dart';
import 'package:uapp/core/utils/date_utils.dart' as du;

class CreatedDate extends StatelessWidget {
  const CreatedDate({
    super.key,
    required this.createdDate,
  });

  final String createdDate;

  @override
  Widget build(BuildContext context) {
    String formattedDate = du.DateUtils.formatDateString(
        createdDate); // 01\nJanuary, 2022\n12:00:00
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          formattedDate.split('\n')[0],
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formattedDate.split('\n')[1],
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        Text(
          formattedDate.split('\n')[2],
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
