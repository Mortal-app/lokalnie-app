enum AquaStockKind { fry, fastPlant, substrate }

extension AquaStockKindX on AquaStockKind {
  String get label => switch (this) {
    AquaStockKind.fry => 'Narybek',
    AquaStockKind.fastPlant => 'Rośliny szybko rosnące',
    AquaStockKind.substrate => 'Podłoże aktywne',
  };
}

class AquaStockOffer {
  final String id;
  final AquaStockKind kind;
  final String title;
  final String authorName;

  const AquaStockOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'authorName': authorName,
  };

  factory AquaStockOffer.fromJson(Map<String, dynamic> json) {
    return AquaStockOffer(
      id: json['id'] as String? ?? '',
      kind: AquaStockKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => AquaStockKind.fry,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Akwarysta',
    );
  }

  static List<AquaStockOffer> seeded() => const [
    AquaStockOffer(
      id: 'as-nar',
      kind: AquaStockKind.fry,
      title: 'Narybek neonów — oddam za podłoże',
      authorName: 'Piotr',
    ),
    AquaStockOffer(
      id: 'as-rosl',
      kind: AquaStockKind.fastPlant,
      title: 'Hygrophila — nadwyżka z 60 l',
      authorName: 'Kasia',
    ),
  ];
}
