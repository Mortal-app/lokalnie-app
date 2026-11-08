enum CaretakerKind { fault, cleaning, inspection }

extension CaretakerKindX on CaretakerKind {
  String get label => switch (this) {
    CaretakerKind.fault => 'Usterka',
    CaretakerKind.cleaning => 'Plan sprzątania',
    CaretakerKind.inspection => 'Przegląd techniczny',
  };
}

class CaretakerNote {
  final String id;
  final CaretakerKind kind;
  final String title;
  final String body;
  final String staircase;
  final String whenLabel;

  const CaretakerNote({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.staircase,
    required this.whenLabel,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'body': body,
    'staircase': staircase,
    'whenLabel': whenLabel,
  };

  factory CaretakerNote.fromJson(Map<String, dynamic> json) {
    return CaretakerNote(
      id: json['id'] as String? ?? '',
      kind: CaretakerKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => CaretakerKind.fault,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      staircase: json['staircase'] as String? ?? 'Klatka I',
      whenLabel: json['whenLabel'] as String? ?? '',
    );
  }

  static List<CaretakerNote> seeded() => const [
    CaretakerNote(
      id: 'care-light',
      kind: CaretakerKind.fault,
      title: 'Żarówka na półpiętrze',
      body: 'Klatka II, 3. piętro — zgłoszone do spółdzielni.',
      staircase: 'Klatka II',
      whenLabel: '28.10',
    ),
    CaretakerNote(
      id: 'care-clean',
      kind: CaretakerKind.cleaning,
      title: 'Sprzątanie klatek',
      body: 'Poniedziałek i czwartek, po 9:00. Wycieraczki na zewnątrz.',
      staircase: 'Wszystkie',
      whenLabel: 'Tydzień 44',
    ),
    CaretakerNote(
      id: 'care-insp',
      kind: CaretakerKind.inspection,
      title: 'Przegląd instalacji gazowej',
      body: 'Wejście do mieszkań 9:00–14:00, proszę zostawić kogoś w domu.',
      staircase: 'Klatka I–III',
      whenLabel: '4.11',
    ),
  ];
}
