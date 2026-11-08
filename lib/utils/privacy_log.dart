import 'package:flutter/foundation.dart';

class PrivacyLog {
  static final _email = RegExp(
    r'[A-Z0-9._%+\-]+@[A-Z0-9.\-]+\.[A-Z]{2,}',
    caseSensitive: false,
  );
  static final _phone = RegExp(
    r'(?:\+48[\s\-]?|0)?(?:\d[\s\-]?){8,11}\d',
  );

  static String mask(String raw) {
    return raw
        .replaceAllMapped(_email, (_) => '[email]')
        .replaceAllMapped(_phone, (_) => '[telefon]');
  }

  static void debug(String message, [Object? error]) {
    if (kReleaseMode) return;
    final text = error == null ? message : '$message: $error';
    debugPrint(mask(text));
  }
}
