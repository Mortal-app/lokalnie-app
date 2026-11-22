class CineScreening {
  final String id;
  final String title;
  final String place;
  final String whenLabel;
  final int seats;
  final int reserved;

  const CineScreening({
    required this.id,
    required this.title,
    required this.place,
    required this.whenLabel,
    this.seats = 24,
    this.reserved = 0,
  });

  CineScreening copyWith({int? reserved}) {
    return CineScreening(
      id: id,
      title: title,
      place: place,
      whenLabel: whenLabel,
      seats: seats,
      reserved: reserved ?? this.reserved,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'place': place,
    'whenLabel': whenLabel,
    'seats': seats,
    'reserved': reserved,
  };

  factory CineScreening.fromJson(Map<String, dynamic> json) {
    return CineScreening(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? 'Świetlica',
      whenLabel: json['whenLabel'] as String? ?? '',
      seats: json['seats'] as int? ?? 24,
      reserved: json['reserved'] as int? ?? 0,
    );
  }

  static List<CineScreening> seeded() => const [
    CineScreening(
      id: 'cc-swietlica',
      title: 'Seans studyjny — kino niezależne',
      place: 'Świetlica osiedlowa',
      whenLabel: 'Piątek 19:00',
      seats: 30,
      reserved: 8,
    ),
    CineScreening(
      id: 'cc-plener',
      title: 'Pokaz plenerowy — dziedziniec',
      place: 'osiedle wschodnie, trawnik przy klatce I',
      whenLabel: 'Sobota 20:30 (pogoda)',
      seats: 40,
      reserved: 11,
    ),
  ];
}
