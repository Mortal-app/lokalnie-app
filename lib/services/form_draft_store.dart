import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FormDraftStore {
  static final Map<String, Map<String, String>> _memory = {};
  static const _prefix = 'form_draft_';

  static const addAnnouncement = 'add_announcement';
  static const handyJob = 'handy_job';
  static const snapPost = 'snap_post';
  static const sosAlert = 'sos_alert';
  static const homeFilters = 'home_filters';

  static Map<String, String> peek(String formId) =>
      Map<String, String>.from(_memory[formId] ?? const {});

  static Future<Map<String, String>> load(String formId) async {
    final cached = _memory[formId];
    if (cached != null) return Map<String, String>.from(cached);
    try {
      final preferences = await SharedPreferences.getInstance();
      final raw = preferences.getString('$_prefix$formId');
      if (raw == null || raw.isEmpty) return {};
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return {};
      final fields = {
        for (final entry in decoded.entries) '${entry.key}': '${entry.value}',
      };
      _memory[formId] = fields;
      return Map<String, String>.from(fields);
    } catch (_) {
      return {};
    }
  }

  static void save(String formId, Map<String, String> fields) {
    _memory[formId] = Map<String, String>.from(fields);
    unawaited(_persist(formId, fields));
  }

  static void clear(String formId) {
    _memory.remove(formId);
    unawaited(_remove(formId));
  }

  static Future<void> _persist(
    String formId,
    Map<String, String> fields,
  ) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('$_prefix$formId', jsonEncode(fields));
    } catch (_) {
      // Brak miejsca / błąd nośnika — szkic zostaje w pamięci sesji.
    }
  }

  static Future<void> _remove(String formId) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove('$_prefix$formId');
    } catch (_) {}
  }
}
