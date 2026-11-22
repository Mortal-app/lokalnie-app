/// Mapowanie payloadu FCM / powiadomienia lokalnego na ekran w aplikacji.
class PushNavigation {
  static const announcementIdKey = 'announcementId';
  static const routeKey = 'route';

  static Map<String, String> dataFromPayload(String payload) {
    final trimmed = payload.trim();
    if (trimmed.isEmpty) return const {};
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      return _fromLooseJson(trimmed);
    }
    if (trimmed.contains('=')) {
      final out = <String, String>{};
      for (final part in trimmed.split('&')) {
        final index = part.indexOf('=');
        if (index <= 0) continue;
        out[part.substring(0, index).trim()] = part.substring(index + 1).trim();
      }
      if (out.isNotEmpty) return out;
    }
    return {announcementIdKey: trimmed};
  }

  static Map<String, String> fromRemoteData(Map<String, dynamic> data) {
    return {
      for (final entry in data.entries)
        entry.key: entry.value?.toString() ?? '',
    };
  }

  static String? announcementId(Map<String, String> data) {
    final direct = data[announcementIdKey]?.trim() ?? '';
    if (direct.isNotEmpty) return direct;
    final route = data[routeKey]?.trim() ?? '';
    const prefix = 'announcement:';
    if (route.toLowerCase().startsWith(prefix)) {
      return route.substring(prefix.length).trim();
    }
    return null;
  }

  /// 0 Tablica, 1 Zapisane, 2 Wiadomości, 3 Profil.
  static int? tabIndex(Map<String, String> data) {
    final route = (data[routeKey] ?? '').trim().toLowerCase();
    switch (route) {
      case 'home':
      case 'tablica':
        return 0;
      case 'saved':
      case 'zapisane':
        return 1;
      case 'messages':
      case 'wiadomosci':
      case 'wiadomości':
        return 2;
      case 'profile':
      case 'profil':
        return 3;
      default:
        return null;
    }
  }

  static Map<String, String> _fromLooseJson(String raw) {
    final out = <String, String>{};
    final pair = RegExp(r'"([^"]+)"\s*:\s*"([^"]*)"');
    for (final match in pair.allMatches(raw)) {
      out[match.group(1)!] = match.group(2)!;
    }
    return out;
  }
}
