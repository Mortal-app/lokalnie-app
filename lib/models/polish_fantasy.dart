enum FantasyKind { kajko, thorgal, relax, scifi }

extension FantasyKindX on FantasyKind {
  String get label => switch (this) {
    FantasyKind.kajko => 'Kajko i Kokosz',
    FantasyKind.thorgal => 'Thorgal',
    FantasyKind.relax => 'Relax',
    FantasyKind.scifi => 'SF / fantasy',
  };
}

class PolishFantasyOffer {
  final String id;
  final FantasyKind kind;
  final String title;
  final String authorName;

  const PolishFantasyOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'authorName': authorName,
  };

  factory PolishFantasyOffer.fromJson(Map<String, dynamic> json) {
    return PolishFantasyOffer(
      id: json['id'] as String? ?? '',
      kind: FantasyKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => FantasyKind.scifi,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Czytelnik',
    );
  }

  static List<PolishFantasyOffer> seeded() => const [
    PolishFantasyOffer(
      id: 'pf-kajko',
      kind: FantasyKind.kajko,
      title: 'Kajko i Kokosz — Szkoła latania, wymienię na Thorgala',
      authorName: 'Piotr',
    ),
    PolishFantasyOffer(
      id: 'pf-relax',
      kind: FantasyKind.relax,
      title: 'Relax nr 3/78 — komiks z epoki, do poczytania na klatce',
      authorName: 'Marek',
    ),
  ];
}
