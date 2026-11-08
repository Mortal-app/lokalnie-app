enum ModelKind { kit, miniature, diorama }

extension ModelKindX on ModelKind {
  String get label => switch (this) {
    ModelKind.kit => 'Model redukcyjny',
    ModelKind.miniature => 'Figurka',
    ModelKind.diorama => 'Makieta',
  };
}

class ModelFairItem {
  final String id;
  final ModelKind kind;
  final String title;
  final String authorName;

  const ModelFairItem({
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

  factory ModelFairItem.fromJson(Map<String, dynamic> json) {
    return ModelFairItem(
      id: json['id'] as String? ?? '',
      kind: ModelKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => ModelKind.kit,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Modelarz',
    );
  }

  static List<ModelFairItem> seeded() => const [
    ModelFairItem(
      id: 'mf-tram',
      kind: ModelKind.kit,
      title: 'Tramwaj 805Na w skali 1:87 — po malowaniu',
      authorName: 'Piotr',
    ),
    ModelFairItem(
      id: 'mf-widz',
      kind: ModelKind.diorama,
      title: 'Makieta bloku z wielkiej płyty, Olechów',
      authorName: 'Marek',
    ),
  ];
}
