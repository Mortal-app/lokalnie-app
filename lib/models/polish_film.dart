enum PolishFilmKind { dvd, classic, tvTheater, screening }

extension PolishFilmKindX on PolishFilmKind {
  String get label => switch (this) {
    PolishFilmKind.dvd => 'Płyta DVD',
    PolishFilmKind.classic => 'Klasyka kina polskiego',
    PolishFilmKind.tvTheater => 'Teatr TV',
    PolishFilmKind.screening => 'Seans w domu kultury',
  };
}

class PolishFilmPost {
  final String id;
  final PolishFilmKind kind;
  final String title;
  final String body;
  final String authorName;

  const PolishFilmPost({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'body': body,
    'authorName': authorName,
  };

  factory PolishFilmPost.fromJson(Map<String, dynamic> json) {
    return PolishFilmPost(
      id: json['id'] as String? ?? '',
      kind: PolishFilmKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => PolishFilmKind.dvd,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Widz',
    );
  }

  static List<PolishFilmPost> seeded() => const [
    PolishFilmPost(
      id: 'pf-dvd',
      kind: PolishFilmKind.dvd,
      title: 'DVD — polskie klasyki do wymiany',
      body: 'Wajda, Kieślowski. Nie indie i nie opera.',
      authorName: 'Piotr',
    ),
    PolishFilmPost(
      id: 'pf-dk',
      kind: PolishFilmKind.screening,
      title: 'Seans Teatru TV w domu kultury',
      body: 'Niedziela, sala widowiskowa. Wejściówki we własnym zakresie.',
      authorName: 'Marek',
    ),
  ];
}
