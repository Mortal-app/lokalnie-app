class AmateurTheaterMeetup {
  final String id;
  final String title;
  final String whenText;
  final String place;
  final String authorName;

  const AmateurTheaterMeetup({
    required this.id,
    required this.title,
    required this.whenText,
    required this.place,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'whenText': whenText,
    'place': place,
    'authorName': authorName,
  };

  factory AmateurTheaterMeetup.fromJson(Map<String, dynamic> json) {
    return AmateurTheaterMeetup(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Aktor',
    );
  }

  static List<AmateurTheaterMeetup> seeded() => const [
    AmateurTheaterMeetup(
      id: 'at-poe',
      title: 'Czytanie poezji — wieczór w świetlicy',
      whenText: 'Piątek 18:00',
      place: 'Świetlica spółdzielni, osiedle wschodnie',
      authorName: 'Ola',
    ),
    AmateurTheaterMeetup(
      id: 'at-eti',
      title: 'Małe formy — etiudy amatorskie',
      whenText: 'Środa 17:30',
      place: 'Klub osiedlowy, okolica',
      authorName: 'Bartek',
    ),
  ];
}
