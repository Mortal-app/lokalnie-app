import 'announcement.dart';

class NeighborhoodStreet {
  static const selectable = [
    'Puszkina',
    'Rokicińska',
    'Przybyszewskiego',
  ];

  static bool matchesAnnouncement(
    Announcement announcement,
    List<String> streets,
  ) {
    if (streets.isEmpty) return true;
    final haystack =
        '${announcement.title} ${announcement.description} ${announcement.subDistrict}'
            .toLowerCase();
    return streets.any((street) => haystack.contains(street.toLowerCase()));
  }
}
