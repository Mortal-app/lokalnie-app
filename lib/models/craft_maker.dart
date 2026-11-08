enum CraftKind { crochet, woodwork, baking, jewelry }

extension CraftKindX on CraftKind {
  String get label => switch (this) {
    CraftKind.crochet => 'Szydełkowanie',
    CraftKind.woodwork => 'Stolarstwo',
    CraftKind.baking => 'Domowe wypieki',
    CraftKind.jewelry => 'Ręcznie robiona biżuteria',
  };
}

class CraftMaker {
  final String id;
  final String name;
  final CraftKind kind;
  final String description;
  final String subDistrict;
  final String contact;

  const CraftMaker({
    required this.id,
    required this.name,
    required this.kind,
    required this.description,
    required this.subDistrict,
    this.contact = '',
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'kind': kind.name,
    'description': description,
    'subDistrict': subDistrict,
    'contact': contact,
  };

  factory CraftMaker.fromJson(Map<String, dynamic> json) {
    return CraftMaker(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      kind: CraftKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => CraftKind.crochet,
      ),
      description: json['description'] as String? ?? '',
      subDistrict: json['subDistrict'] as String? ?? 'Widzew Wschód',
      contact: json['contact'] as String? ?? '',
    );
  }

  static List<CraftMaker> seeded() => const [
    CraftMaker(
      id: 'craft-crochet',
      name: 'Pani Krysia',
      kind: CraftKind.crochet,
      description: 'Czapki, serwety i zabawki na szydełku.',
      subDistrict: 'Stary Widzew',
      contact: 'Klatka I, po 17:00',
    ),
    CraftMaker(
      id: 'craft-wood',
      name: 'Warsztat u Marka',
      kind: CraftKind.woodwork,
      description: 'Półki, skrzynki na kwiaty, drobne naprawy mebli.',
      subDistrict: 'Widzew Wschód',
    ),
    CraftMaker(
      id: 'craft-bake',
      name: 'Domowe wypieki Ani',
      kind: CraftKind.baking,
      description: 'Sernik, drożdżówki, torty na urodziny klatki.',
      subDistrict: 'Olechów',
    ),
    CraftMaker(
      id: 'craft-jewel',
      name: 'Biżuteria z koralików',
      kind: CraftKind.jewelry,
      description: 'Kolczyki i bransoletki z recyklingu.',
      subDistrict: 'Janów',
    ),
  ];
}
