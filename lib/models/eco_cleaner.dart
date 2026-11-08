enum EcoCleanKind { dishwasher, floor, polish }

extension EcoCleanKindX on EcoCleanKind {
  String get label => switch (this) {
    EcoCleanKind.dishwasher => 'Tabletki do zmywarki',
    EcoCleanKind.floor => 'Płyn do podłóg',
    EcoCleanKind.polish => 'Pasta polerska',
  };
}

class EcoCleanRecipe {
  final String id;
  final EcoCleanKind kind;
  final String title;
  final String body;
  final String authorName;

  const EcoCleanRecipe({
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

  factory EcoCleanRecipe.fromJson(Map<String, dynamic> json) {
    return EcoCleanRecipe(
      id: json['id'] as String? ?? '',
      kind: EcoCleanKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => EcoCleanKind.floor,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<EcoCleanRecipe> seeded() => const [
    EcoCleanRecipe(
      id: 'ec-zmyw',
      kind: EcoCleanKind.dishwasher,
      title: 'Tabletki: soda, kwas cytrynowy, sól',
      body: 'Łyżka sody, łyżeczka cytrynowego, szczypta soli — forma na lód.',
      authorName: 'Ewa',
    ),
    EcoCleanRecipe(
      id: 'ec-podl',
      kind: EcoCleanKind.floor,
      title: 'Ocet i soda na panele (ostrożnie ze spoinami)',
      body: 'Ciepła woda, łyżka octu, odrobina sody — bez chloru.',
      authorName: 'Pani Krysia',
    ),
  ];
}
