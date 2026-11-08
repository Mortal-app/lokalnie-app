class NeighborQr {
  static const prefix = 'lokalniewidzew://';

  static String profilePayload({
    required String userName,
    required String subDistrict,
  }) {
    return '${prefix}sasiad?name=${Uri.encodeComponent(userName)}'
        '&osiedle=${Uri.encodeComponent(subDistrict)}';
  }

  static String announcementPayload(DateTime publishedAt) {
    return '${prefix}ogloszenie/${publishedAt.toIso8601String()}';
  }

  static bool isNeighborPayload(String raw) =>
      raw.contains('lokalniewidzew') || raw.startsWith(prefix);
}
