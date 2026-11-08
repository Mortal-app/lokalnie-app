class Utf8TextGuard {
  static String sanitize(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune == 0x09 || rune == 0x0A || rune == 0x0D) {
        buffer.writeCharCode(rune);
        continue;
      }
      if (rune < 0x20 || rune == 0x7F) continue;
      if (rune == 0xFFFE || rune == 0xFFFF) continue;
      if (rune >= 0xD800 && rune <= 0xDFFF) continue;
      buffer.writeCharCode(rune);
    }
    return buffer.toString().trim();
  }
}
