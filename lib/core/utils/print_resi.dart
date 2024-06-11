import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:uapp/core/utils/date_utils.dart';
import 'package:uapp/core/utils/log.dart';
import 'package:uapp/models/resi.dart';

class PrintResi {
  static final PrintResi _instance = PrintResi._internal();

  PrintResi._internal();

  factory PrintResi() {
    return _instance;
  }

  final int totalWidth = 32;
  final spacetwo = '================================\n';
  final spaceone = '--------------------------------\n';
  final bluetoothAddress = '00:11:22:33:44:55';
  BluetoothConnection? connection;

  String centerText(String text, int width) {
    int padding = (width - text.length) ~/ 2;
    return text.padLeft(padding + text.length).padRight(width);
  }

  Future<void> _initializeConnection() async {
    if (connection == null || !(connection!.isConnected)) {
      connection = await BluetoothConnection.toAddress(bluetoothAddress);
    }
  }

  Future<void> print(Resi resi) async {
    await _initializeConnection();

    try {
      if (connection != null) {
        connection!.output.add(Uint8List.fromList(utf8.encode(spacetwo)));
        connection!.output.add(Uint8List.fromList(utf8.encode('Tanggal\t  : ${DateUtils.getFormattedDateOnly(DateTime.now())}\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('Nomor\t  : ${resi.nomor}\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('Pelanggan: ${resi.namaPelanngan}\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode(spaceone)));
        for (var item in resi.toItems) {
          connection!.output.add(Uint8List.fromList(utf8.encode('${item.description}\n')));
          connection!.output.add(Uint8List.fromList(utf8.encode('\t ${item.quantity} X ${item.unit}\t${item.price}\n')));
        }
        connection!.output.add(Uint8List.fromList(utf8.encode(spaceone)));
        connection!.output.add(Uint8List.fromList(utf8.encode('SUB TOTAL\t\t${resi.toItems.map((e) => e.price).reduce((value, element) => value + element)}\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('DISKON 2\t\t0\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('PPN (0%)\t\t0\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode(spaceone)));
        connection!.output.add(Uint8List.fromList(utf8.encode('TOTAL QTY\t${resi.toItems.length}\tTOTAL\t\t${resi.toItems.map((e) => e.price).reduce((value, element) => value + element)}\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('BAYAR\t\t${resi.toItems.map((e) => e.price).reduce((value, element) => value + element)}\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('KEMBALIAN\t\t0\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode(spacetwo)));
        connection!.output.add(Uint8List.fromList(utf8.encode('${DateUtils.getCurrentDateTime()}-${resi.namaSales}\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('${centerText("Barang yang sudah dibeli", totalWidth)}\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('${centerText("tidak bisa ditukar", totalWidth)}\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('${centerText("atau dikembalikan", totalWidth)}\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('${centerText(".:terima kasih:.", totalWidth)}\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('\n')));
        connection!.output.add(Uint8List.fromList(utf8.encode('\n')));
      }
    } catch (exception) {
      Log.d('Cannot print receipt, exception occurred');
    }
  }

}