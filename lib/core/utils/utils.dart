import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static String formatCurrency(String value) {
    return 'Rp${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  static void showDialogNotAllowed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('Warning'),
            content: const Text(
                'Anda menggunakan lokasi palsu, silahkan matikan lokasi palsu'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  openAppSettings();
                },
                child: const Text('Buka Pengaturan'),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<String?> saveSignature(Future<ByteData?> imageData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final image = await imageData;
      final pngBytes = image?.buffer.asUint8List();
      final now = DateTime.now().millisecondsSinceEpoch;
      final path = '${directory.path}/signature_$now.png';
      final file = File(path);
      await file.writeAsBytes(pngBytes!);
      return path;
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  static Future<bool> isInternetAvailable() async {
    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }
}
