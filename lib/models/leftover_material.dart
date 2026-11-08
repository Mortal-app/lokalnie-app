enum LeftoverKind { glue, panels, paint, tiles }

extension LeftoverKindX on LeftoverKind {
  String get label => switch (this) {
    LeftoverKind.glue => 'Klej / zaprawa',
    LeftoverKind.panels => 'Panele',
    LeftoverKind.paint => 'Farba',
    LeftoverKind.tiles => 'Płytki ceramiczne',
  };
}

class LeftoverMaterial {
  final String id;
  final LeftoverKind kind;
  final String title;
  final String priceLabel;
  final String place;
  final String authorName;

  const LeftoverMaterial({
    required this.id,
    required this.kind,
    required this.title,
    required this.priceLabel,
    required this.place,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'priceLabel': priceLabel,
    'place': place,
    'authorName': authorName,
  };

  factory LeftoverMaterial.fromJson(Map<String, dynamic> json) {
    return LeftoverMaterial(
      id: json['id'] as String? ?? '',
      kind: LeftoverKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => LeftoverKind.paint,
      ),
      title: json['title'] as String? ?? '',
      priceLabel: json['priceLabel'] as String? ?? 'Za grosze',
      place: json['place'] as String? ?? 'Widzew',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<LeftoverMaterial> seeded() => const [
    LeftoverMaterial(
      id: 'lm-klej',
      kind: LeftoverKind.glue,
      title: 'Pół worka kleju do płytek',
      priceLabel: 'Oddam',
      place: 'Olechów',
      authorName: 'Bartek',
    ),
    LeftoverMaterial(
      id: 'lm-panele',
      kind: LeftoverKind.panels,
      title: 'Resztki paneli dąb — 4 szt.',
      priceLabel: '10 zł',
      place: 'Widzew Wschód',
      authorName: 'Arek',
    ),
    LeftoverMaterial(
      id: 'lm-farba',
      kind: LeftoverKind.paint,
      title: 'Puszka farby lateksowej biała 2,5 l',
      priceLabel: 'Za grosze',
      place: 'Stary Widzew',
      authorName: 'Ania',
    ),
    LeftoverMaterial(
      id: 'lm-plytki',
      kind: LeftoverKind.tiles,
      title: 'Płytki ceramiczne 30×60 — karton',
      priceLabel: 'Oddam',
      place: 'Janów',
      authorName: 'Sąsiad z Janowa',
    ),
  ];
}
