enum ScamKind { grandson, official, other }

extension ScamKindX on ScamKind {
  String get label => switch (this) {
    ScamKind.grandson => 'Na wnuczka',
    ScamKind.official => 'Na urzędnika',
    ScamKind.other => 'Inne wyłudzenie',
  };
}

class ScamAlert {
  final String id;
  final ScamKind kind;
  final String title;
  final String body;
  final String authorName;
  final bool urgent;

  const ScamAlert({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.authorName,
    this.urgent = true,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'body': body,
    'authorName': authorName,
    'urgent': urgent,
  };

  factory ScamAlert.fromJson(Map<String, dynamic> json) {
    return ScamAlert(
      id: json['id'] as String? ?? '',
      kind: ScamKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => ScamKind.other,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      urgent: json['urgent'] as bool? ?? true,
    );
  }

  static List<ScamAlert> seeded() => const [
    ScamAlert(
      id: 'sc-wnuk',
      kind: ScamKind.grandson,
      title: 'Telefon „wnuczek w tarapatach” — okolica',
      body:
          'Dzwonią wieczorem, proszą o BLIK. Nie przelewaj, powiadom sąsiadów.',
      authorName: 'Pani Halina',
    ),
    ScamAlert(
      id: 'sc-urz',
      kind: ScamKind.official,
      title: 'Fałszywy „pracownik spółdzielni” przy drzwiach',
      body: 'Chciał wejść „sprawdzić wodomierz” bez legitymacji.',
      authorName: 'Zarząd klatki',
    ),
  ];
}
