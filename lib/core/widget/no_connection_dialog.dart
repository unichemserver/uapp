import 'package:flutter/material.dart';

class NoConnectionDialog extends StatelessWidget {
  const NoConnectionDialog({super.key, this.onOkPressed});

  final Function()? onOkPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning),
          SizedBox(width: 10),
          Text('Tidak ada internet'),
        ],
      ),
      content: const Text('Tolong cek koneksi internet anda'),
      actions: [
        TextButton(
          onPressed: onOkPressed,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
