class BulkBuy {
  final String id;
  final String title;
  final String item;
  final int unitSize;
  final String unit;
  final int joined;
  final int targetPeople;
  final bool iJoined;

  const BulkBuy({
    required this.id,
    required this.title,
    required this.item,
    required this.unitSize,
    required this.unit,
    required this.joined,
    required this.targetPeople,
    this.iJoined = false,
  });

  int get totalOrder => joined * unitSize;

  BulkBuy copyWith({int? joined, bool? iJoined}) {
    return BulkBuy(
      id: id,
      title: title,
      item: item,
      unitSize: unitSize,
      unit: unit,
      joined: joined ?? this.joined,
      targetPeople: targetPeople,
      iJoined: iJoined ?? this.iJoined,
    );
  }

  BulkBuy toggleJoin() {
    if (iJoined) {
      return copyWith(iJoined: false, joined: (joined - 1).clamp(0, 999));
    }
    return copyWith(iJoined: true, joined: joined + 1);
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'item': item,
    'unitSize': unitSize,
    'unit': unit,
    'joined': joined,
    'targetPeople': targetPeople,
    'iJoined': iJoined,
  };

  factory BulkBuy.fromJson(Map<String, dynamic> json) {
    return BulkBuy(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      item: json['item'] as String? ?? '',
      unitSize: json['unitSize'] as int? ?? 1,
      unit: json['unit'] as String? ?? 'szt.',
      joined: json['joined'] as int? ?? 0,
      targetPeople: json['targetPeople'] as int? ?? 10,
      iJoined: json['iJoined'] as bool? ?? false,
    );
  }

  static List<BulkBuy> seeded() => const [
    BulkBuy(
      id: 'bulk-pellet',
      title: 'Ekologiczny opał / pellet',
      item: 'Pellet',
      unitSize: 15,
      unit: 'kg',
      joined: 8,
      targetPeople: 12,
    ),
    BulkBuy(
      id: 'bulk-soil',
      title: 'Ziemia ogrodowa na klatki',
      item: 'Ziemia',
      unitSize: 50,
      unit: 'l',
      joined: 5,
      targetPeople: 10,
    ),
    BulkBuy(
      id: 'bulk-kids',
      title: 'Hurtowe artykuły dziecięce',
      item: 'Pieluchy / chusteczki',
      unitSize: 1,
      unit: 'paczka',
      joined: 11,
      targetPeople: 15,
    ),
  ];
}
