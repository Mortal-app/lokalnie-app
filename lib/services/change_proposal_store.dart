import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ChangeProposalStore {
  static const key = 'lokalnie_widzew_change_proposals';

  static Future<void> add(String text, {String? userName}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    try {
      final preferences = await SharedPreferences.getInstance();
      final stored = preferences.getStringList(key) ?? [];
      stored.add(
        jsonEncode({
          'text': trimmed,
          'userName': userName ?? '',
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );
      await preferences.setStringList(key, stored);
    } catch (_) {
      // Testy i środowiska bez wtyczki nie blokują wysyłki.
    }
  }
}
