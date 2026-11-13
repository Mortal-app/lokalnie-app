import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Warstwa nośnika danych. Lokalna implementacja może zostać
/// podmieniona na [FirestoreStorageBackend] bez zmian w UI.
abstract interface class StorageBackend {
  Future<Map<String, dynamic>?> read(String documentId);

  Future<void> write(String documentId, Map<String, dynamic> data);
}

class LocalPreferencesBackend implements StorageBackend {
  static const _keyPrefix = 'lokalnie_widzew_doc_';
  static const hasCompletedOnboardingKey = 'has_completed_onboarding';
  static const userHomeNeighborhoodKey = 'user_home_neighborhood';
  static const cachedAnnouncementsKey = 'cached_announcements';
  static const cachedAlertsKey = 'cached_alerts';
  static const cachedFavoriteServicesKey = 'cached_favorite_services';
  static const cachedMessagesKey = 'cached_messages';
  static const cachedSearchHistoryKey = 'cached_search_history';
  static const developmentNoticeSeenKey = 'development_notice_seen_v2';
  static const notificationsEnabledKey = 'notifications_enabled';

  @override
  Future<Map<String, dynamic>?> read(String documentId) async {
    final preferences = await SharedPreferences.getInstance();
    final storedJson = preferences.getString('$_keyPrefix$documentId');
    Map<String, dynamic>? data;
    if (storedJson != null) {
      try {
        data = jsonDecode(storedJson) as Map<String, dynamic>;
      } on FormatException {
        data = null;
      } on TypeError {
        data = null;
      }
    }
    data ??= _cacheFallback(preferences);
    if (data == null) return null;
    return _mergeSessionKeys(preferences, data);
  }

  @override
  Future<void> write(String documentId, Map<String, dynamic> data) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final saved = await preferences.setString(
        '$_keyPrefix$documentId',
        jsonEncode(data),
      );
      if (!saved) {
        throw StateError(
          'Nie udało się zapisać danych. Sprawdź wolne miejsce na telefonie.',
        );
      }
      await _writeSessionKeys(preferences, data);
    } catch (error) {
      throw StateError(
        'Nie udało się zapisać danych. Sprawdź wolne miejsce na telefonie. ($error)',
      );
    }
  }

  Map<String, dynamic>? _cacheFallback(SharedPreferences preferences) {
    final cachedAnnouncements = preferences.getString(cachedAnnouncementsKey);
    final completed = preferences.getBool(hasCompletedOnboardingKey);
    final neighborhood = preferences.getString(userHomeNeighborhoodKey);
    final notificationsEnabled = preferences.getBool(notificationsEnabledKey);
    if (cachedAnnouncements == null &&
        completed == null &&
        neighborhood == null &&
        notificationsEnabled == null) {
      return null;
    }
    final data = <String, dynamic>{};
    if (completed != null) data['onboardingCompleted'] = completed;
    if (neighborhood != null) data['defaultSubDistrict'] = neighborhood;
    if (notificationsEnabled != null) {
      data['neighborhoodNotificationsEnabled'] = notificationsEnabled;
    }
    if (cachedAnnouncements != null) {
      try {
        data['announcements'] = jsonDecode(cachedAnnouncements);
      } on FormatException {
        // Zachowaj pozostałe klucze sesji.
      }
    }
    final cachedMessages = preferences.getString(cachedMessagesKey);
    if (cachedMessages != null) {
      try {
        data['messages'] = jsonDecode(cachedMessages);
      } on FormatException {
        // Zachowaj tablicę ogłoszeń.
      }
    }
    final cachedHistory = preferences.getString(cachedSearchHistoryKey);
    if (cachedHistory != null) {
      try {
        data['searchHistory'] = jsonDecode(cachedHistory);
      } on FormatException {
        // Zachowaj tablicę ogłoszeń.
      }
    }
    return data.isEmpty ? null : data;
  }

  Map<String, dynamic> _mergeSessionKeys(
    SharedPreferences preferences,
    Map<String, dynamic> data,
  ) {
    final merged = Map<String, dynamic>.from(data);
    final completed = preferences.getBool(hasCompletedOnboardingKey);
    if (completed != null) {
      merged['onboardingCompleted'] = completed;
    }
    final neighborhood = preferences.getString(userHomeNeighborhoodKey);
    if (neighborhood != null && neighborhood.isNotEmpty) {
      merged['defaultSubDistrict'] = neighborhood;
    }
    if (merged['announcements'] == null) {
      final cachedAnnouncements = preferences.getString(cachedAnnouncementsKey);
      if (cachedAnnouncements != null) {
        try {
          merged['announcements'] = jsonDecode(cachedAnnouncements);
        } on FormatException {
          // Zostaw snapshot bez nadpisywania listy.
        }
      }
    }
    if (merged['messages'] == null) {
      final cachedMessages = preferences.getString(cachedMessagesKey);
      if (cachedMessages != null) {
        try {
          merged['messages'] = jsonDecode(cachedMessages);
        } on FormatException {
          // Zostaw snapshot bez nadpisywania czatu.
        }
      }
    }
    if (merged['searchHistory'] == null) {
      final cachedHistory = preferences.getString(cachedSearchHistoryKey);
      if (cachedHistory != null) {
        try {
          merged['searchHistory'] = jsonDecode(cachedHistory);
        } on FormatException {
          // Zostaw snapshot bez nadpisywania historii.
        }
      }
    }
    final notificationsEnabled = preferences.getBool(notificationsEnabledKey);
    if (notificationsEnabled != null) {
      merged['neighborhoodNotificationsEnabled'] = notificationsEnabled;
    }
    return merged;
  }

  Future<void> _writeSessionKeys(
    SharedPreferences preferences,
    Map<String, dynamic> data,
  ) async {
    final completed = data['onboardingCompleted'];
    if (completed is bool) {
      await preferences.setBool(hasCompletedOnboardingKey, completed);
    }
    final notificationsEnabled = data['neighborhoodNotificationsEnabled'];
    if (notificationsEnabled is bool) {
      await preferences.setBool(notificationsEnabledKey, notificationsEnabled);
    }
    final neighborhood = data['defaultSubDistrict'];
    if (neighborhood is String && neighborhood.isNotEmpty) {
      await preferences.setString(userHomeNeighborhoodKey, neighborhood);
    }
    final announcements = data['announcements'];
    if (announcements is List) {
      await preferences.setString(
        cachedAnnouncementsKey,
        jsonEncode(announcements),
      );
      final alerts = announcements.where((item) {
        if (item is! Map) return false;
        final category = (item['category'] ?? '').toString().toLowerCase();
        final pending = item['pendingSync'] == true;
        return pending ||
            category.contains('dzik') ||
            category.contains('uwaga') ||
            category.contains('ostrze');
      }).toList();
      await preferences.setString(cachedAlertsKey, jsonEncode(alerts));
    }
    final chat = data['messages'];
    if (chat is List) {
      await preferences.setString(cachedMessagesKey, jsonEncode(chat));
    }
    final history = data['searchHistory'];
    if (history is List) {
      await preferences.setString(cachedSearchHistoryKey, jsonEncode(history));
    }
    final services = data['services'];
    if (services is List) {
      final favorites = services.where((item) {
        if (item is! Map) return false;
        return item['isRecommended'] == true || item['isCertified'] == true;
      }).toList();
      await preferences.setString(
        cachedFavoriteServicesKey,
        jsonEncode(favorites),
      );
    }
  }
}

/// Adapter pod Cloud Firestore. Po dodaniu `cloud_firestore` wystarczy
/// podmienić backend w [AppStoreFactory.cloud].
class FirestoreStorageBackend implements StorageBackend {
  FirestoreStorageBackend({this.collection = 'app_snapshots'});

  final String collection;

  @override
  Future<Map<String, dynamic>?> read(String documentId) {
    throw UnsupportedError(
      'FirestoreStorageBackend($collection/$documentId) wymaga '
      'skonfigurowanego pakietu cloud_firestore. '
      'Podmień LocalPreferencesBackend w AppStoreFactory.',
    );
  }

  @override
  Future<void> write(String documentId, Map<String, dynamic> data) {
    throw UnsupportedError(
      'FirestoreStorageBackend($collection/$documentId) wymaga '
      'skonfigurowanego pakietu cloud_firestore. '
      'Podmień LocalPreferencesBackend w AppStoreFactory.',
    );
  }
}

class InMemoryStorageBackend implements StorageBackend {
  final Map<String, Map<String, dynamic>> _documents = {};

  @override
  Future<Map<String, dynamic>?> read(String documentId) async {
    final stored = _documents[documentId];
    return stored == null ? null : Map<String, dynamic>.from(stored);
  }

  @override
  Future<void> write(String documentId, Map<String, dynamic> data) async {
    _documents[documentId] = Map<String, dynamic>.from(data);
  }
}
