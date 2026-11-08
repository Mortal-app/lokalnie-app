import '../models/announcement.dart';

class AnnouncementShare {
  static String clipboardText(Announcement announcement) {
    final id = announcement.publishedAt.microsecondsSinceEpoch;
    final link = 'https://lokalniewidzew.app/ogloszenie/$id';
    final description = announcement.description.trim();
    final buffer = StringBuffer()
      ..writeln(announcement.title)
      ..writeln('${announcement.category} · ${announcement.subDistrict}')
      ..writeln('Lokalnie Widzew — tablica sąsiedzka Widzewa, Olechowa i Janowa');
    if (description.isNotEmpty) {
      buffer.writeln(description);
    }
    buffer
      ..writeln()
      ..write(link);
    return buffer.toString();
  }
}
