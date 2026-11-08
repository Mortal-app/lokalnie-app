import 'package:shared_preferences/shared_preferences.dart';

import 'storage_backend.dart';

class DevelopmentNoticeStore {
  static const seenKey = LocalPreferencesBackend.developmentNoticeSeenKey;

  static Future<bool> hasSeen() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return preferences.getBool(seenKey) ?? false;
    } catch (_) {
      // Brak wtyczki / błąd odczytu: pokaż okno, zamiast je cicho pominąć.
      return false;
    }
  }

  static Future<void> markSeen() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(seenKey, true);
    } catch (_) {
      // Testy i środowiska bez wtyczki nie blokują zamknięcia okna.
    }
  }

  static Future<void> reset() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(seenKey);
    } catch (_) {
      // Brak wtyczki nie blokuje startu aplikacji.
    }
  }
}
