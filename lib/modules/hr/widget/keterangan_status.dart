import 'package:flutter/material.dart';

class KeteranganStatus extends StatelessWidget {
  const KeteranganStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
          color: Colors.green[100],
        ),
        const Text(' : Disetujui'),
        const SizedBox(width: 8),
        Container(
          width: 20,
          height: 20,
          color: Colors.red[100],
        ),
        const Text(' : Belum disetujui'),
        const SizedBox(width: 8),
        Container(
          width: 20,
          height: 20,
          color: Colors.redAccent,
        ),
        const Text(' : Ditolak'),
      ],
    );
  }
}
