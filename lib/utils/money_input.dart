import 'package:flutter/services.dart';

class MoneyInput {
  static const keyboard = TextInputType.numberWithOptions(decimal: true);

  static final List<TextInputFormatter> formatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
  ];

  static String normalize(String raw) =>
      raw.trim().replaceAll(' ', '').replaceAll(',', '.');

  static bool isValid(String raw) {
    final value = normalize(raw);
    if (value.isEmpty) return false;
    return RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value);
  }

  static String? errorText(String raw) {
    if (raw.trim().isEmpty) return 'Podaj stawkę liczbową.';
    if (!isValid(raw)) {
      return 'Stawka może zawierać tylko cyfry oraz kropkę lub przecinek.';
    }
    return null;
  }

  static String asRateLabel(String raw) {
    final value = normalize(raw);
    return '${value.replaceAll('.', ',')} zł';
  }
}
