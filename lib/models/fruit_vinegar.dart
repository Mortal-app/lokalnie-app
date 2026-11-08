enum VinegarKind { appleCider, ferment, probiotic }

extension VinegarKindX on VinegarKind {
  String get label => switch (this) {
    VinegarKind.appleCider => 'Ocet z obierek',
    VinegarKind.ferment => 'Fermentacja',
    VinegarKind.probiotic => 'Probiotyki',
  };
}

class FruitVinegarRecipe {
  final String id;
  final VinegarKind kind;
  final String title;
  final String body;
  final String authorName;

  const FruitVinegarRecipe({
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

  factory FruitVinegarRecipe.fromJson(Map<String, dynamic> json) {
    return FruitVinegarRecipe(
      id: json['id'] as String? ?? '',
      kind: VinegarKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => VinegarKind.appleCider,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<FruitVinegarRecipe> seeded() => const [
    FruitVinegarRecipe(
      id: 'fv-oct',
      kind: VinegarKind.appleCider,
      title: 'Ocet z obierek jabłek',
      body: 'Obierki, woda, cukier, gaza — 4 tygodnie na parapecie.',
      authorName: 'Ewa',
    ),
    FruitVinegarRecipe(
      id: 'fv-pro',
      kind: VinegarKind.probiotic,
      title: 'Domowy zakwas probiotyczny',
      body: 'Fermentacja warzyw i octu — nie mylić z zakwasem chlebowym.',
      authorName: 'Pani Krysia',
    ),
  ];
}
