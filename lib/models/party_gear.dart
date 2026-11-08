enum PartyGearKind { projector, speaker, table, tent }

extension PartyGearKindX on PartyGearKind {
  String get label => switch (this) {
    PartyGearKind.projector => 'Projektor',
    PartyGearKind.speaker => 'Głośnik Bluetooth',
    PartyGearKind.table => 'Stół cateringowy',
    PartyGearKind.tent => 'Namiot',
  };
}

class PartyGear {
  final String id;
  final PartyGearKind kind;
  final String title;
  final String owner;
  final bool borrowed;

  const PartyGear({
    required this.id,
    required this.kind,
    required this.title,
    required this.owner,
    this.borrowed = false,
  });

  PartyGear copyWith({bool? borrowed}) {
    return PartyGear(
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

  factory PartyGear.fromJson(Map<String, dynamic> json) {
    return PartyGear(
      id: json['id'] as String? ?? '',
      kind: PartyGearKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => PartyGearKind.speaker,
      ),
      title: json['title'] as String? ?? '',
      owner: json['owner'] as String? ?? 'Klub mieszkańca',
      borrowed: json['borrowed'] as bool? ?? false,
    );
  }

  static List<PartyGear> seeded() => const [
    PartyGear(
      id: 'pg-proj',
      kind: PartyGearKind.projector,
      title: 'Projektor Full HD + ekran 100"',
      owner: 'Klub osiedlowy',
    ),
    PartyGear(
      id: 'pg-bt',
      kind: PartyGearKind.speaker,
      title: 'Głośnik Bluetooth JBL Party',
      owner: 'Sąsiad z klatki III',
    ),
    PartyGear(
      id: 'pg-table',
      kind: PartyGearKind.table,
      title: '2 stoły cateringowe 180 cm',
      owner: 'Spółdzielnia',
    ),
    PartyGear(
      id: 'pg-tent',
      kind: PartyGearKind.tent,
      title: 'Namiot 3×6 na grill klatki',
      owner: 'Rada osiedla',
    ),
  ];
}
