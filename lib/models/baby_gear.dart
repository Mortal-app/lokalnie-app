enum BabyGearKind { carSeat, pram, stroller, carrier }

extension BabyGearKindX on BabyGearKind {
  String get label => switch (this) {
    BabyGearKind.carSeat => 'Fotelik samochodowy',
    BabyGearKind.pram => 'Wózek głęboki',
    BabyGearKind.stroller => 'Spacerówka',
    BabyGearKind.carrier => 'Nosidełko',
  };
}

class BabyGearItem {
  final String id;
  final BabyGearKind kind;
  final String title;
  final String authorName;
  final bool forSale;

  const BabyGearItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.authorName,
    this.forSale = false,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'authorName': authorName,
    'forSale': forSale,
  };

  factory BabyGearItem.fromJson(Map<String, dynamic> json) {
    return BabyGearItem(
      id: json['id'] as String? ?? '',
      kind: BabyGearKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => BabyGearKind.stroller,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Rodzic',
      forSale: json['forSale'] as bool? ?? false,
    );
  }

  static List<BabyGearItem> seeded() => const [
    BabyGearItem(
      id: 'bg-fotel',
      kind: BabyGearKind.carSeat,
      title: 'Fotelik 9–18 kg, bez wypadków — oddam',
      authorName: 'Ola',
    ),
    BabyGearItem(
      id: 'bg-wozek',
      kind: BabyGearKind.pram,
      title: 'Wózek głęboki, Olechów — symboliczna kwota',
      authorName: 'Kasia',
      forSale: true,
    ),
  ];
}
