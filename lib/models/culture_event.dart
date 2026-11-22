enum CultureVenue { dkWidzew, fabryczka }

extension CultureVenueX on CultureVenue {
  String get label => switch (this) {
    CultureVenue.dkWidzew => 'Dom kultury',
    CultureVenue.fabryczka => 'Fabryczka',
  };
}

class CultureEvent {
  final String id;
  final String title;
  final String description;
  final String place;
  final DateTime startsAt;
  final CultureVenue venue;
  final bool forKids;
  final bool isWorkshop;
  final bool interested;

  const CultureEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.place,
    required this.startsAt,
    required this.venue,
    this.forKids = false,
    this.isWorkshop = false,
    this.interested = false,
  });

  CultureEvent copyWith({bool? interested}) {
    return CultureEvent(
      id: id,
      title: title,
      description: description,
      place: place,
      startsAt: startsAt,
      venue: venue,
      forKids: forKids,
      isWorkshop: isWorkshop,
      interested: interested ?? this.interested,
    );
  }

  String toIcs() {
    String stamp(DateTime value) {
      final utc = value.toUtc();
      String two(int number) => number.toString().padLeft(2, '0');
      return '${utc.year}${two(utc.month)}${two(utc.day)}T'
          '${two(utc.hour)}${two(utc.minute)}${two(utc.second)}Z';
    }

    return 'BEGIN:VCALENDAR\n'
        'VERSION:2.0\n'
        'BEGIN:VEVENT\n'
        'SUMMARY:$title\n'
        'DTSTART:${stamp(startsAt)}\n'
        'LOCATION:$place\n'
        'DESCRIPTION:$description\n'
        'END:VEVENT\n'
        'END:VCALENDAR';
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'place': place,
    'startsAt': startsAt.toIso8601String(),
    'venue': venue.name,
    'forKids': forKids,
    'isWorkshop': isWorkshop,
    'interested': interested,
  };

  factory CultureEvent.fromJson(Map<String, dynamic> json) {
    return CultureEvent(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      place: json['place'] as String? ?? '',
      startsAt:
          DateTime.tryParse(json['startsAt'] as String? ?? '') ??
          DateTime(2026, 11, 5, 17),
      venue: CultureVenue.values.firstWhere(
        (item) => item.name == json['venue'],
        orElse: () => CultureVenue.dkWidzew,
      ),
      forKids: json['forKids'] as bool? ?? false,
      isWorkshop: json['isWorkshop'] as bool? ?? false,
      interested: json['interested'] as bool? ?? false,
    );
  }

  static List<CultureEvent> seeded() => [
    CultureEvent(
      id: 'cult-kids',
      title: 'Zajęcia plastyczne dla dzieci',
      description: 'Farby i papier, od 5 lat, zapis przy kasie DK.',
      place: 'Dom kultury',
      startsAt: DateTime(2026, 11, 8, 11),
      venue: CultureVenue.dkWidzew,
      forKids: true,
    ),
    CultureEvent(
      id: 'cult-workshop',
      title: 'Warsztaty linorytu',
      description: 'Dla dorosłych, materiały w cenie.',
      place: 'Fabryczka',
      startsAt: DateTime(2026, 11, 12, 18),
      venue: CultureVenue.fabryczka,
      isWorkshop: true,
    ),
    CultureEvent(
      id: 'cult-concert',
      title: 'Koncert sąsiedzki w domu kultury',
      description: 'Lokalne zespoły, wstęp wolny.',
      place: 'dom kultury, sala widowiskowa',
      startsAt: DateTime(2026, 11, 15, 19),
      venue: CultureVenue.dkWidzew,
    ),
  ];
}
