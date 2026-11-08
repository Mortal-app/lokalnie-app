enum BreadKind { starter, loaf, ovenTip }

extension BreadKindX on BreadKind {
  String get label => switch (this) {
    BreadKind.starter => 'Zakwas / starter',
    BreadKind.loaf => 'Wypiek chleba',
    BreadKind.ovenTip => 'Piekarnik domowy',
  };
}

class SourdoughRecipe {
  final String id;
  final BreadKind kind;
  final String title;
  final String body;
  final String authorName;

  const SourdoughRecipe({
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

  factory SourdoughRecipe.fromJson(Map<String, dynamic> json) {
    return SourdoughRecipe(
      id: json['id'] as String? ?? '',
      kind: BreadKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => BreadKind.loaf,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<SourdoughRecipe> seeded() => const [
    SourdoughRecipe(
      id: 'sd-zak',
      kind: BreadKind.starter,
      title: 'Zakwas żytni — oddam łyżkę startera',
      body: 'Karmiony mąką żytnią. Odbiór na klatce, słoik 200 ml.',
      authorName: 'Ewa',
    ),
    SourdoughRecipe(
      id: 'sd-chl',
      kind: BreadKind.loaf,
      title: 'Chleb w piekarniku z kamieniem',
      body: 'Para w brytfannie, 230°C, 20+25 min. Sprawdza się w bloku.',
      authorName: 'Pani Krysia',
    ),
  ];
}
