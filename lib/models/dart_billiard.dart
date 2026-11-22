enum CueGameKind { darts, billiard }

extension CueGameKindX on CueGameKind {
  String get label => switch (this) {
    CueGameKind.darts => 'Dart (rzutki)',
    CueGameKind.billiard => 'Bilard',
  };
}

class DartBilliardMeetup {
  final String id;
  final CueGameKind kind;
  final String title;
  final String whenText;
  final String place;
  final String authorName;

  const DartBilliardMeetup({
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

  factory DartBilliardMeetup.fromJson(Map<String, dynamic> json) {
    return DartBilliardMeetup(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == CueGameKind.billiard.name
          ? CueGameKind.billiard
          : CueGameKind.darts,
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Gracz',
    );
  }

  static List<DartBilliardMeetup> seeded() => const [
    DartBilliardMeetup(
      id: 'db-dart',
      kind: CueGameKind.darts,
      title: 'Amatorski dart — 501',
      whenText: 'Czwartek 19:00',
      place: 'Świetlica spółdzielni, osiedle wschodnie',
      authorName: 'Bartek',
    ),
    DartBilliardMeetup(
      id: 'db-bil',
      kind: CueGameKind.billiard,
      title: 'Bilard w klubie osiedlowym',
      whenText: 'Sobota 17:00',
      place: 'Pub / klub w okolicy',
      authorName: 'Ola',
    ),
  ];
}
