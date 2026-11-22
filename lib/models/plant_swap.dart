enum PlantSwapKind { cuttings, seedlings, balcony, guide }

extension PlantSwapKindX on PlantSwapKind {
  String get label => switch (this) {
    PlantSwapKind.cuttings => 'Szczepki',
    PlantSwapKind.seedlings => 'Sadzonki',
    PlantSwapKind.balcony => 'Balkon / ROD',
    PlantSwapKind.guide => 'Porada (klimat Łodzi)',
  };
}

class PlantSwapOffer {
  final String id;
  final String title;
  final String description;
  final PlantSwapKind kind;
  final String authorName;
  final String subDistrict;

  const PlantSwapOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.authorName,
    required this.subDistrict,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'kind': kind.name,
    'authorName': authorName,
    'subDistrict': subDistrict,
  };

  factory PlantSwapOffer.fromJson(Map<String, dynamic> json) {
    return PlantSwapOffer(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      kind: PlantSwapKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => PlantSwapKind.cuttings,
      ),
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Twoja okolica',
    );
  }

  static List<PlantSwapOffer> seeded() => const [
    PlantSwapOffer(
      id: 'plant-monster',
      title: 'Oddam szczepki monstery',
      description: 'Kilka ukorzenionych sadzonek, odbiór na klatce.',
      kind: PlantSwapKind.cuttings,
      authorName: 'Sąsiadka',
      subDistrict: 'Twoja okolica',
    ),
    PlantSwapOffer(
      id: 'plant-tomato',
      title: 'Przekażę nadmiar sadzonek pomidorów',
      description: 'Malinowe i koktajlowe, hartowane na balkonie.',
      kind: PlantSwapKind.seedlings,
      authorName: 'Sąsiad',
      subDistrict: 'Twoja okolica',
    ),
    PlantSwapOffer(
      id: 'plant-guide',
      title: 'Uprawa w łódzkim klimacie — balkony i ROD',
      description:
          'Wiatr ze wschodu, późne przymrozki: hartujcie rozsady, pomidory po 15 maja, zioła przy ścianie południowej.',
      kind: PlantSwapKind.guide,
      authorName: 'Działkowiec z okolicy',
      subDistrict: 'Twoja okolica',
    ),
  ];
}
