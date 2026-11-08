enum SportHubKind { tip, esport, chess }

extension SportHubKindX on SportHubKind {
  String get label => switch (this) {
    SportHubKind.tip => 'Typer meczowy',
    SportHubKind.esport => 'Turniej e-sport',
    SportHubKind.chess => 'Szachy',
  };
}

class SportHubItem {
  final String id;
  final SportHubKind kind;
  final String title;
  final String whenLabel;
  final String host;
  final String userPick;

  const SportHubItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.whenLabel,
    required this.host,
    this.userPick = '',
  });

  SportHubItem copyWith({String? userPick}) {
    return SportHubItem(
      id: id,
      kind: kind,
      title: title,
      whenLabel: whenLabel,
      host: host,
      userPick: userPick ?? this.userPick,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'whenLabel': whenLabel,
    'host': host,
    'userPick': userPick,
  };

  factory SportHubItem.fromJson(Map<String, dynamic> json) {
    return SportHubItem(
      id: json['id'] as String? ?? '',
      kind: SportHubKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => SportHubKind.tip,
      ),
      title: json['title'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      host: json['host'] as String? ?? 'Organizator',
      userPick: json['userPick'] as String? ?? '',
    );
  }

  static List<SportHubItem> seeded() => const [
    SportHubItem(
      id: 'sl-widzew',
      kind: SportHubKind.tip,
      title: 'Widzew — mecz ligowy (typer osiedla)',
      whenLabel: 'Sobota 15:00',
      host: 'Liga klatek',
    ),
    SportHubItem(
      id: 'sl-esport',
      kind: SportHubKind.esport,
      title: 'Amatorski puchar FIFA / FC — świetlica',
      whenLabel: 'Niedziela 17:00',
      host: 'Bartek',
    ),
    SportHubItem(
      id: 'sl-szachy',
      kind: SportHubKind.chess,
      title: 'Simultanka szachowa na klatce I',
      whenLabel: 'Czwartek 18:00',
      host: 'Pan Józef',
    ),
  ];
}
