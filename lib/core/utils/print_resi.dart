import 'package:flutter/services.dart';
import 'package:uapp/core/utils/date_utils.dart';
import 'package:uapp/core/utils/utils.dart';
import 'package:uapp/models/resi.dart';

class PrintResi {
  static final PrintResi _instance = PrintResi._internal();

  PrintResi._internal();

  factory PrintResi() {
    return _instance;
  }

  static const platform = MethodChannel('com.uci.uapp/printer');
  static const maxLength = 9;
  static const valueLength = 10;
  static const quantityLength = 3;
  static const unitLength = 7;
  static const maxLineLength = 32;

  Future<void> printText(Resi resi) async {
    try {
      final String text = getFormattedStringToPrint(resi);
      final String result = await platform.invokeMethod('printText', {'text': text});
      print(result);
    } on PlatformException catch (e) {
      print("Failed to print text: '${e.message}'.");
    }
  }

  String formatLabel(String label) {
    return label.padRight(maxLength);
  }

  String formatValue(String value) {
    return value.padLeft(valueLength);
  }

  String formatQuantity(int quantity) {
    return quantity.toString().padLeft(quantityLength);
  }

  String formatUnit(String unit) {
    return unit.padRight(unitLength);
  }

  String formatLabelValue(String label, String value) {
    int spacesCount = maxLineLength - label.length - value.length;
    return '$label${' ' * spacesCount}$value';
  }

  String getFormattedStringToPrint(Resi resi) {
    String receipt = '';
    var subtotal = resi.toItems.map((e) => e.price).reduce((value, element) => value! + element!);
    var subtotalFormatted = rp(subtotal.toString());
    var subtotalppn = resi.toItems.map((e) => e.ppn ?? 0).reduce((value, element) => value + element);
    var subtotalppnFormatted = rp(subtotalppn.toString());

    var total = (subtotal ?? 0) + (subtotalppn);
    var totalFormatted = rp(total.toString());

    if (resi.activity == 'Canvasing') {
      receipt += '${centerText('PENJUALAN', totalWidth)}\n';
    } else {
      receipt += '${centerText('TAKING ORDER', totalWidth)}\n';
    }
    receipt += spacetwo;
    receipt += '${formatLabel('Tanggal')} : ${DateUtils.getFormattedDateOnly(DateTime.now())}\n';
    receipt += '${formatLabel('Nomor')} : ${resi.nomor}\n';
    receipt += '${formatLabel('Pelanggan')} : ${resi.namaPelanngan}\n';
    receipt += spaceone;
    for (var item in resi.toItems) {
      receipt += '${item.description}\n';
      String quantity = formatQuantity(item.quantity!);
      String unit = rp(formatUnit(item.unit!));
      String price = rp(item.price.toString());
      String ppn = rp((item.ppn ?? 0).toString());
      receipt += '${formatLabelValue('$quantity X $unit', price)}\n';
      receipt += '${formatLabelValue('PPN', ppn)}\n';
    }
    receipt += spaceone;
    receipt += '${formatLabelValue('SUB TOTAL', subtotalFormatted)}\n';
    receipt += '${formatLabelValue('DISKON', '0')}\n';
    receipt += '${formatLabelValue('PPN', subtotalppnFormatted)}\n';
    receipt += spaceone;
    receipt += '${formatLabelValue('TOTAL', totalFormatted)}\n';
    receipt += spacetwo;
    receipt += '${DateUtils.getCurrentDateTime()}-${resi.namaSales}\n';
    receipt += '\n';
    if (resi.activity == 'Canvasing') {
      receipt += '${centerText('*** L U N A S ***', totalWidth)}\n';
    }
    receipt += '\n';
    receipt += '${centerText("Barang yang sudah dibeli", totalWidth)}\n';
    receipt += '${centerText("tidak bisa ditukar", totalWidth)}\n';
    receipt += '${centerText("atau dikembalikan", totalWidth)}\n';
    receipt += '\n';
    receipt += '${centerText(".:TERIMA KASIH:.", totalWidth)}\n';
    receipt += '\n';
    receipt += '\n';
    receipt += '\n';

    return receipt;
  }

  final int totalWidth = 32;
  final spacetwo = '================================\n';
  final spaceone = '--------------------------------\n';
  final bluetoothAddress = '00:11:22:33:44:55';

  String centerText(String text, int width) {
    int padding = (width - text.length) ~/ 2;
    return text.padLeft(padding + text.length).padRight(width);
  }

  String rp(String value) {
    return Utils.formatCurrency(value);
  }

}