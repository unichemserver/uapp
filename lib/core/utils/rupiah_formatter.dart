import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RupiahInputFormatter extends TextInputFormatter {
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Check if there are no digits in the new text
    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Parse the text to a number
    int? number = int.tryParse(newText);

    // If parsing fails, return the new value with empty text
    if (number == null) {
      return newValue.copyWith(text: '');
    }

    // Format the number to Rupiah
    String formattedText = _currencyFormat.format(number);

    // Return the new TextEditingValue with the formatted text
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
