enum WorkwearKind { clothes, steelToe, helmet }

extension WorkwearKindX on WorkwearKind {
  String get label => switch (this) {
    WorkwearKind.clothes => 'Odzież robocza',
    WorkwearKind.steelToe => 'Buty z metalowym noskiem',
    WorkwearKind.helmet => 'Kask BHP',
  };
}

class WorkwearItem {
  final String id;
  final WorkwearKind kind;
  final String title;
  final String size;
  final String authorName;

  const WorkwearItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.size,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'size': size,
    'authorName': authorName,
  };

  factory WorkwearItem.fromJson(Map<String, dynamic> json) {
    return WorkwearItem(
      id: json['id'] as String? ?? '',
      kind: WorkwearKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => WorkwearKind.clothes,
      ),
      title: json['title'] as String? ?? '',
      size: json['size'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<WorkwearItem> seeded() => const [
    WorkwearItem(
      id: 'ww-spod',
      kind: WorkwearKind.clothes,
      title: 'Spodnie robocze po remoncie klatki — czyste',
      size: 'L / 52',
      authorName: 'Tomek',
    ),
    WorkwearItem(
      id: 'ww-buty',
      kind: WorkwearKind.steelToe,
      title: 'Buty z noskiem, rozmiar 43',
      size: '43',
      authorName: 'Arek',
    ),
    WorkwearItem(
      id: 'ww-kask',
      kind: WorkwearKind.helmet,
      title: 'Kask BHP po budowie — oddam',
      size: 'uniwersalny',
      authorName: 'Ekipa z Olechowa',
    ),
  ];
}
