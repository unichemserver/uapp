import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hand_signature/signature.dart';
import 'package:uapp/core/utils/assets.dart';

class SignatureContainer extends StatelessWidget {
  const SignatureContainer({
    super.key,
    required this.control,
    required this.title,
    this.onSaveSignature,
  });

  final HandSignatureControl control;
  final String title;
  final void Function(ByteData?)? onSaveSignature;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
        image: const DecorationImage(
          image: AssetImage(Assets.placeholderTtd),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: HandSignature(
              control: control,
              type: SignatureDrawType.shape,
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    control.clear();
                  },
                  child: const Text('Hapus'),
                ),
                TextButton(
                  onPressed: () {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                    control.toImage().then((image) {
                      onSaveSignature?.call(image);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
