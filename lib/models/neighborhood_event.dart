class NeighborhoodEvent {
  final String id;
  final String title;
  final String place;
  final String description;
  final DateTime startsAt;
  final int goingCount;
  final bool isGoing;

  const NeighborhoodEvent({
    required this.id,
    required this.title,
    required this.place,
    required this.description,
    required this.startsAt,
    this.goingCount = 0,
    this.isGoing = false,
  });

  NeighborhoodEvent toggleGoing() {
    if (isGoing) {
      return copyWith(isGoing: false, goingCount: goingCount - 1);
    }
    return copyWith(isGoing: true, goingCount: goingCount + 1);
  }

  NeighborhoodEvent copyWith({
    int? goingCount,
    bool? isGoing,
  }) {
    return NeighborhoodEvent(
      id: id,
      title: title,
      place: place,
      description: description,
      startsAt: startsAt,
      goingCount: goingCount ?? this.goingCount,
      isGoing: isGoing ?? this.isGoing,
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
    'place': place,
    'description': description,
    'startsAt': startsAt.toIso8601String(),
    'goingCount': goingCount,
    'isGoing': isGoing,
  };

  factory NeighborhoodEvent.fromJson(Map<String, dynamic> json) {
    return NeighborhoodEvent(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? '',
      description: json['description'] as String? ?? '',
      startsAt:
          DateTime.tryParse(json['startsAt'] as String? ?? '') ??
          DateTime(2026, 10, 25),
      goingCount: json['goingCount'] as int? ?? 0,
      isGoing: json['isGoing'] as bool? ?? false,
    );
  }

  static List<NeighborhoodEvent> seeded() => [
    NeighborhoodEvent(
      id: 'picnic',
      title: 'Piknik sąsiedzki na górce osiedlowej',
      place: 'Park osiedlowy',
      description: 'Koce, limonada i poznanie sąsiadów z okolicy.',
      startsAt: DateTime(2026, 10, 25, 15),
      goingCount: 18,
    ),
    NeighborhoodEvent(
      id: 'meeting',
      title: 'Zebranie wspólnoty przy Głównej',
      place: 'Świetlica, ul. Główna',
      description: 'Porządek obrad: parking, zieleń, oświetlenie.',
      startsAt: DateTime(2026, 10, 27, 18),
      goingCount: 9,
    ),
    NeighborhoodEvent(
      id: 'garage',
      title: 'Wyprzedaż garażowa w okolicy',
      place: 'Przy pętli',
      description: 'Rzeczy z domu i ogrodu. Weź własną torbę.',
      startsAt: DateTime(2026, 11, 1, 10),
      goingCount: 7,
    ),
    NeighborhoodEvent(
      id: 'cleanup',
      title: 'Akcja sprzątania laska',
      place: 'Lasek osiedlowy',
      description: 'Worki i rękawice zapewnia wspólnota. Start przy bramie.',
      startsAt: DateTime(2026, 11, 8, 9),
      goingCount: 14,
    ),
  ];
}
