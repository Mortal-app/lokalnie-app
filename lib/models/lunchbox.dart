enum LunchKind { lunchbox, oatBar, smoothie }

extension LunchKindX on LunchKind {
  String get label => switch (this) {
    LunchKind.lunchbox => 'Lunchbox',
    LunchKind.oatBar => 'Baton owsiany',
    LunchKind.smoothie => 'Koktajl',
  };
}

class LunchboxRecipe {
  final String id;
  final LunchKind kind;
  final String title;
  final String body;
  final String authorName;

  const LunchboxRecipe({
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

  factory LunchboxRecipe.fromJson(Map<String, dynamic> json) {
    return LunchboxRecipe(
      id: json['id'] as String? ?? '',
      kind: LunchKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => LunchKind.lunchbox,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<LunchboxRecipe> seeded() => const [
    LunchboxRecipe(
      id: 'lb-ows',
      kind: LunchKind.oatBar,
      title: 'Batony owsiane na drugie śniadanie',
      body: 'Płatki, miód, bakalie — 15 min w piekarniku, do szkoły i pracy.',
      authorName: 'Ewa',
    ),
    LunchboxRecipe(
      id: 'lb-box',
      kind: LunchKind.lunchbox,
      title: 'Lunchbox: kasza, warzywa, dip jogurtowy',
      body: 'Szybki zestaw z soboty — trzyma się do poniedziałku w lodówce.',
      authorName: 'Pani Krysia',
    ),
  ];
}
