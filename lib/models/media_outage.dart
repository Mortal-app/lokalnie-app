enum MediaOutageKind { water, power, heat }

extension MediaOutageKindX on MediaOutageKind {
  String get label => switch (this) {
    MediaOutageKind.water => 'Woda',
    MediaOutageKind.power => 'Prąd',
    MediaOutageKind.heat => 'Ciepło',
  };
}

class MediaOutage {
  final String id;
  final String title;
  final String body;
  final MediaOutageKind kind;
  final String place;
  final bool isActive;

  const MediaOutage({
    required this.id,
    required this.title,
    required this.body,
    required this.kind,
    required this.place,
    this.isActive = true,
  });

  MediaOutage copyWith({bool? isActive}) {
    return MediaOutage(
      id: id,
      title: title,
      body: body,
      kind: kind,
      place: place,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'kind': kind.name,
    'place': place,
    'isActive': isActive,
  };

  factory MediaOutage.fromJson(Map<String, dynamic> json) {
    return MediaOutage(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      kind: MediaOutageKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => MediaOutageKind.water,
      ),
      place: json['place'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  static List<MediaOutage> seeded() => const [
    MediaOutage(
      id: 'media-water',
      title: 'Brak wody na ul. Puszkina',
      body: 'Awaria sieci, szacowana naprawa do wieczora.',
      kind: MediaOutageKind.water,
      place: 'ul. Puszkina',
    ),
    MediaOutage(
      id: 'media-power',
      title: 'Wyłączenie prądu w bloku nr 12',
      body: 'Planowane prace, godz. 10–14.',
      kind: MediaOutageKind.power,
      place: 'blok nr 12',
    ),
  ];
}
