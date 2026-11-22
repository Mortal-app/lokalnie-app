enum RacketKind { tennis, squash }

extension RacketKindX on RacketKind {
  String get label => switch (this) {
    RacketKind.tennis => 'Tenis',
    RacketKind.squash => 'Squash',
  };
}

class TennisSquashMeetup {
  final String id;
  final RacketKind kind;
  final String title;
  final String whenText;
  final String place;
  final String authorName;

  const TennisSquashMeetup({
    required this.id,
    required this.kind,
    required this.title,
    required this.whenText,
    required this.place,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'whenText': whenText,
    'place': place,
    'authorName': authorName,
  };

  factory TennisSquashMeetup.fromJson(Map<String, dynamic> json) {
    return TennisSquashMeetup(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == RacketKind.squash.name
          ? RacketKind.squash
          : RacketKind.tennis,
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Gracz',
    );
  }

  static List<TennisSquashMeetup> seeded() => const [
    TennisSquashMeetup(
      id: 'tsq-ten',
      kind: RacketKind.tennis,
      title: 'Sparing tenisowy — amatorzy',
      whenText: 'Sobota 9:00',
      place: 'Korty w okolicy / okolicy',
      authorName: 'Bartek',
    ),
    TennisSquashMeetup(
      id: 'tsq-sq',
      kind: RacketKind.squash,
      title: 'Squash — godzinka na korcie',
      whenText: 'Środa 18:30',
      place: 'Obiekt sportowy',
      authorName: 'Ola',
    ),
  ];
}
