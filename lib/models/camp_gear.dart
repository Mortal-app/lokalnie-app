enum CampGearKind { tent, sleepingBag, backpack, cooler }

extension CampGearKindX on CampGearKind {
  String get label => switch (this) {
    CampGearKind.tent => 'Namiot',
    CampGearKind.sleepingBag => 'Śpiwór',
    CampGearKind.backpack => 'Plecak turystyczny',
    CampGearKind.cooler => 'Lodówka turystyczna',
  };
}

class CampGearItem {
  final String id;
  final CampGearKind kind;
  final String title;
  final String owner;
  final bool borrowed;

  const CampGearItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.owner,
    this.borrowed = false,
  });

  CampGearItem copyWith({bool? borrowed}) {
    return CampGearItem(
      id: id,
      kind: kind,
      title: title,
      owner: owner,
      borrowed: borrowed ?? this.borrowed,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'owner': owner,
    'borrowed': borrowed,
  };

  factory CampGearItem.fromJson(Map<String, dynamic> json) {
    return CampGearItem(
      id: json['id'] as String? ?? '',
      kind: CampGearKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => CampGearKind.tent,
      ),
      title: json['title'] as String? ?? '',
      owner: json['owner'] as String? ?? 'Sąsiad',
      borrowed: json['borrowed'] as bool? ?? false,
    );
  }

  static List<CampGearItem> seeded() => const [
    CampGearItem(
      id: 'cg-namiot',
      kind: CampGearKind.tent,
      title: 'Namiot 3-os. iglo',
      owner: 'Arek z Olechowa',
    ),
    CampGearItem(
      id: 'cg-spiwor',
      kind: CampGearKind.sleepingBag,
      title: 'Śpiwór do 5 °C',
      owner: 'Kasia',
    ),
    CampGearItem(
      id: 'cg-plecak',
      kind: CampGearKind.backpack,
      title: 'Plecak 60 l',
      owner: 'Tomek',
    ),
    CampGearItem(
      id: 'cg-lodo',
      kind: CampGearKind.cooler,
      title: 'Lodówka turystyczna 24 l',
      owner: 'Sąsiad z Janowa',
    ),
  ];
}
