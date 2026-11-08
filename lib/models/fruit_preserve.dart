enum FruitPreserveKind { konfitura, powidla, kompot }

extension FruitPreserveKindX on FruitPreserveKind {
  String get label => switch (this) {
    FruitPreserveKind.konfitura => 'Konfitura',
    FruitPreserveKind.powidla => 'Powidła śliwkowe',
    FruitPreserveKind.kompot => 'Kompot',
  };
}

class FruitPreserveRecipe {
  final String id;
  final FruitPreserveKind kind;
  final String title;
  final String body;
  final String authorName;

  const FruitPreserveRecipe({
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

  factory FruitPreserveRecipe.fromJson(Map<String, dynamic> json) {
    return FruitPreserveRecipe(
      id: json['id'] as String? ?? '',
      kind: FruitPreserveKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => FruitPreserveKind.konfitura,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Działkowiec',
    );
  }

  static List<FruitPreserveRecipe> seeded() => const [
    FruitPreserveRecipe(
      id: 'fp-pow',
      kind: FruitPreserveKind.powidla,
      title: 'Powidła ze śliwek z ROD',
      body: 'Śliwki węgierki, cukier 1:4, wolne warzenie — bez dżemu z giełdy słoików.',
      authorName: 'Pani Krysia',
    ),
    FruitPreserveRecipe(
      id: 'fp-kom',
      kind: FruitPreserveKind.kompot,
      title: 'Kompot jabłkowo-gruszkowy z działki',
      body: 'Owoce z ROD, goździk, bez konserwantów. Słoiki 0,9 l.',
      authorName: 'Ewa',
    ),
  ];
}
