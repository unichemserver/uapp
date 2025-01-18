import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hand_signature/signature.dart';
import 'package:uapp/core/utils/utils.dart';

class SignatureWidget extends StatefulWidget {
  const SignatureWidget({
    super.key,
    required this.onSaved,
    this.initTtdPath,
    this.isGestureEnabled = true, // Defaultnya false
  });

  final Function(String) onSaved;
  final String? initTtdPath;
  final bool isGestureEnabled; // Properti baru untuk enable/disable GestureDetector

  @override
  State<SignatureWidget> createState() => _SignatureWidgetState();
}

class _SignatureWidgetState extends State<SignatureWidget> {
  final HandSignatureControl control = HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  final ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);
  String ttdPath = '';

  void _rotateScreen(bool isPortrait) {
    SystemChrome.setPreferredOrientations(isPortrait
        ? [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
        : [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  @override
  void initState() {
    super.initState();
    ttdPath = widget.initTtdPath ?? '';
  }

  @override
  void dispose() {
    control.dispose();
    super.dispose();
  }

  Future<void> _saveSignature(BuildContext context) async {
    var path = await Utils.saveSignature(control.toImage());
    ttdPath = path ?? '';
    rawImage.value = await control.toImage();
    _rotateScreen(true);
    widget.onSaved(ttdPath);
    Navigator.of(context).pop();
  }

  Widget _buildSignatureDialog(BuildContext context) {
    return Dialog.fullscreen(
      child: Stack(
        children: [
          Positioned.fill(
            child: HandSignature(control: control, type: SignatureDrawType.shape),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(
              children: [
                TextButton(
                  onPressed: control.clear,
                  child: const Text('Hapus'),
                ),
                TextButton(
                  onPressed: () => _saveSignature(context),
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSignatureDialog() {
    _rotateScreen(false);
    Get.dialog(
      PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) {
            _rotateScreen(true);
            Get.back();
          }
        },
        child: _buildSignatureDialog(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isGestureEnabled // Kondisi baru berdasarkan isGestureEnabled
        ? GestureDetector(
      onTap: _showSignatureDialog,
      child: _buildSignatureBox(),
    )
        : _buildSignatureBox(); // Signature box tanpa GestureDetector jika isGestureEnabled false
  }

  Widget _buildSignatureBox() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: ttdPath.isEmpty ? Colors.grey[100] : null,
          image: ttdPath.isNotEmpty
              ? DecorationImage(
            image: FileImage(File(ttdPath)),
            fit: BoxFit.cover,
          )
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ttdPath.isEmpty
            ? ValueListenableBuilder<ByteData?>(
          valueListenable: rawImage,
          builder: (context, value, child) {
            return value == null
                ? const SizedBox()
                : Image.memory(
              value.buffer.asUint8List(),
              fit: BoxFit.cover,
            );
          },
        )
            : null,
      ),
    );
  }
}

