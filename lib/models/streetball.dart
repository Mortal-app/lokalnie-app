enum CourtKind { school, orlik }

extension CourtKindX on CourtKind {
  String get label => switch (this) {
    CourtKind.school => 'Boisko szkolne',
    CourtKind.orlik => 'Orlik',
  };
}

class StreetballMeetup {
  final String id;
  final CourtKind court;
  final String title;
  final String whenText;
  final String place;
  final String authorName;

  const StreetballMeetup({
    required this.id,
    required this.court,
    required this.title,
    required this.whenText,
    required this.place,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'court': court.name,
    'title': title,
    'whenText': whenText,
    'place': place,
    'authorName': authorName,
  };

  factory StreetballMeetup.fromJson(Map<String, dynamic> json) {
    return StreetballMeetup(
      id: json['id'] as String? ?? '',
      court: json['court'] == CourtKind.orlik.name
          ? CourtKind.orlik
          : CourtKind.school,
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      place: json['place'] as String? ?? 'Widzew Wschód',
      authorName: json['authorName'] as String? ?? 'Gracz',
    );
  }

  static List<StreetballMeetup> seeded() => const [
    StreetballMeetup(
      id: 'bb-orlik',
      court: CourtKind.orlik,
      title: 'Luźny streetball 3x3',
      whenText: 'Sobota 16:00',
      place: 'Orlik, Widzew Wschód',
      authorName: 'Bartek',
    ),
    StreetballMeetup(
      id: 'bb-szk',
      court: CourtKind.school,
      title: 'Mecz po lekcjach — każdy poziom',
      whenText: 'Wtorek 17:30',
      place: 'Boisko przy SP, Widzew Wschód',
      authorName: 'Ola',
    ),
  ];
}
