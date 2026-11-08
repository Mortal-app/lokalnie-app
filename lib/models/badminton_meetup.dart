class BadmintonMeetup {
  final String id;
  final String title;
  final String whenText;
  final String place;
  final String authorName;

  const BadmintonMeetup({
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

  factory BadmintonMeetup.fromJson(Map<String, dynamic> json) {
    return BadmintonMeetup(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Gracz',
    );
  }

  static List<BadmintonMeetup> seeded() => const [
    BadmintonMeetup(
      id: 'bd-traw',
      title: 'Badminton na trawniku — lotki mam',
      whenText: 'Sobota 17:00',
      place: 'Widzew Wschód, boisko otwarte',
      authorName: 'Bartek',
    ),
    BadmintonMeetup(
      id: 'bd-kort',
      title: 'Sparing na korcie osiedlowym',
      whenText: 'Niedziela 10:00',
      place: 'Kort / asfalt przy szkole, Olechów',
      authorName: 'Ola',
    ),
  ];
}
