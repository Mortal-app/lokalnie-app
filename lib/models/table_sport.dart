enum TableSportKind { pingPong, foosball }

extension TableSportKindX on TableSportKind {
  String get label => switch (this) {
    TableSportKind.pingPong => 'Tenis stołowy',
    TableSportKind.foosball => 'Piłkarzyki',
  };
}

class TableSportMeetup {
  final String id;
  final TableSportKind kind;
  final String title;
  final String whenText;
  final String place;
  final String authorName;

  const TableSportMeetup({
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

  factory TableSportMeetup.fromJson(Map<String, dynamic> json) {
    return TableSportMeetup(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == TableSportKind.foosball.name
          ? TableSportKind.foosball
          : TableSportKind.pingPong,
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Gracz',
    );
  }

  static List<TableSportMeetup> seeded() => const [
    TableSportMeetup(
      id: 'ts-pp',
      kind: TableSportKind.pingPong,
      title: 'Sparing ping-pong — każdy poziom',
      whenText: 'Środa 18:00',
      place: 'Świetlica spółdzielni, Widzew Wschód',
      authorName: 'Bartek',
    ),
    TableSportMeetup(
      id: 'ts-pil',
      kind: TableSportKind.foosball,
      title: 'Piłkarzyki w klubie osiedlowym',
      whenText: 'Sobota 16:00',
      place: 'Klub osiedlowy, Olechów',
      authorName: 'Ola',
    ),
  ];
}
