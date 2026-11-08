import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/tradesperson_marketplace.dart';

class TradespersonStore {
  static const key = 'tradesperson_marketplace_v1';

  static Future<MarketplaceState> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final raw = preferences.getString(key);
      if (raw == null || raw.isEmpty) return const MarketplaceState();
      return MarketplaceState.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      return const MarketplaceState();
    }
  }

  static Future<bool> save(MarketplaceState state) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setString(key, jsonEncode(state.toJson()));
      return saved;
    } catch (_) {
      return false;
    }
  }

  static Future<void> clear() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove(key);
    } catch (_) {}
  }
}
