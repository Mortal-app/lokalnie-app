import '../models/announcement.dart';

class AnnouncementShare {
  static String clipboardText(Announcement announcement) {
    final id = announcement.publishedAt.microsecondsSinceEpoch;
    final link = 'https://lokalniewidzew.app/ogloszenie/$id';
    final location = announcement.subDistrict.trim().isEmpty
        ? 'Brak lokalizacji'
        : announcement.subDistrict.trim();
    final description = announcement.description.trim();
    final buffer = StringBuffer()
      ..writeln('Lokalnie — ogłoszenie sąsiedzkie')
      ..writeln()
      ..writeln('Tytuł: ${announcement.title}')
      ..writeln('Kategoria: ${announcement.displayCategory}')
      ..writeln('Lokalizacja: $location')
      ..writeln('Status: ${announcement.status.label}');
    if (description.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln('Opis:')
        ..writeln(description);
    }
    buffer
      ..writeln()
      ..write(link);
    return buffer.toString();
  }
}
