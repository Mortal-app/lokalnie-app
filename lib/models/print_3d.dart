enum Print3dKind { holder, gasket, agdPart }

extension Print3dKindX on Print3dKind {
  String get label => switch (this) {
    Print3dKind.holder => 'Uchwyt',
    Print3dKind.gasket => 'Uszczelka',
    Print3dKind.agdPart => 'Element AGD',
  };
}

class Print3dOffer {
  final String id;
  final Print3dKind kind;
  final String title;
  final String authorName;

  const Print3dOffer({
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

  factory Print3dOffer.fromJson(Map<String, dynamic> json) {
    return Print3dOffer(
      id: json['id'] as String? ?? '',
      kind: Print3dKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => Print3dKind.holder,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Drukarz',
    );
  }

  static List<Print3dOffer> seeded() => const [
    Print3dOffer(
      id: 'p3-hak',
      kind: Print3dKind.holder,
      title: 'Druknę uchwyt na wąż odkurzacza — PLA, klatka II',
      authorName: 'Piotr',
    ),
    Print3dOffer(
      id: 'p3-agd',
      kind: Print3dKind.agdPart,
      title: 'Brakująca nóżka do suszarki — TPU na życzenie',
      authorName: 'Ola',
    ),
  ];
}
