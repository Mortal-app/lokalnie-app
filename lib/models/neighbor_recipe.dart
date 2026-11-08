enum RecipeKind { dinner, preserves, cake }

extension RecipeKindX on RecipeKind {
  String get label => switch (this) {
    RecipeKind.dinner => 'Obiad',
    RecipeKind.preserves => 'Przetwory',
    RecipeKind.cake => 'Ciasto',
  };
}

class NeighborRecipe {
  final String id;
  final RecipeKind kind;
  final String title;
  final String body;
  final String authorName;

  const NeighborRecipe({
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

  factory NeighborRecipe.fromJson(Map<String, dynamic> json) {
    return NeighborRecipe(
      id: json['id'] as String? ?? '',
      kind: RecipeKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => RecipeKind.cake,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<NeighborRecipe> seeded() => const [
    NeighborRecipe(
      id: 'rec-sernik',
      kind: RecipeKind.cake,
      title: 'Sernik z wiśniami pani Krysi',
      body: '1 kg twarogu, 5 jaj, puszka wiśni. 160 °C, 50 min. Na klatkę zawsze schodzi.',
      authorName: 'Pani Krysia',
    ),
    NeighborRecipe(
      id: 'rec-ogorki',
      kind: RecipeKind.preserves,
      title: 'Ogórki małosolne z balkonu',
      body: 'Koperek, czosnek, chrzan. 2 dni w słoiku na parapecie od strony podwórka.',
      authorName: 'Pan Józef',
    ),
    NeighborRecipe(
      id: 'rec-zurek',
      kind: RecipeKind.dinner,
      title: 'Żurek na zakwasie z Olechowa',
      body: 'Zakwas 3 dni, kiełbasa z osiedlowego, majeranek. Na 6 talerzy.',
      authorName: 'Kasia',
    ),
  ];
}
