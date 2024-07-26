import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';

class PersonSignature extends StatelessWidget {
  PersonSignature({
    super.key,
    required this.title,
    required this.name,
    required this.position,
    required this.tgl,
  });

  final HandSignatureControl control = HandSignatureControl(
    threshold: 5.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  final String title;
  final String name;
  final String position;
  final String tgl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Expanded(
            child: HandSignature(
              control: control,
              type: SignatureDrawType.shape,
            ),
          ),
          Text(name),
          Text(position),
          Text(tgl),
        ],
      ),
    );
  }
}
