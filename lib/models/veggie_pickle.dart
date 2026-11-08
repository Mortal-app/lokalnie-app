enum PickleKind { cauliflower, radish, kimchi, brine }

extension PickleKindX on PickleKind {
  String get label => switch (this) {
    PickleKind.cauliflower => 'Kiszony kalafior',
    PickleKind.radish => 'Kiszona rzodkiewka',
    PickleKind.kimchi => 'Kimchi',
    PickleKind.brine => 'Solanka / starter',
  };
}

class VeggiePickleRecipe {
  final String id;
  final PickleKind kind;
  final String title;
  final String body;
  final String authorName;

  const VeggiePickleRecipe({
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

  factory VeggiePickleRecipe.fromJson(Map<String, dynamic> json) {
    return VeggiePickleRecipe(
      id: json['id'] as String? ?? '',
      kind: PickleKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => PickleKind.cauliflower,
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<VeggiePickleRecipe> seeded() => const [
    VeggiePickleRecipe(
      id: 'vp-kal',
      kind: PickleKind.cauliflower,
      title: 'Kalafior w solance — 5 dni',
      body: 'Sól niejodowana, czosnek, liść laurowy. Nie mylić z octem owocowym.',
      authorName: 'Pani Krysia',
    ),
    VeggiePickleRecipe(
      id: 'vp-kim',
      kind: PickleKind.kimchi,
      title: 'Kimchi i wymiana startera mlekowego',
      body: 'Oddam łyżkę startera z poprzedniej warki. Rzodkiew osobno.',
      authorName: 'Ewa',
    ),
  ];
}
