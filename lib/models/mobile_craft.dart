enum MobileCraftKind { locksmith, tires, electrician }

extension MobileCraftKindX on MobileCraftKind {
  String get label => switch (this) {
    MobileCraftKind.locksmith => 'Ślusarz 24h',
    MobileCraftKind.tires => 'Mobilny serwis opon',
    MobileCraftKind.electrician => 'Domowy elektryk (polecony)',
  };
}

class MobileCraftPro {
  final String id;
  final MobileCraftKind kind;
  final String name;
  final String area;
  final String endorsedBy;

  const MobileCraftPro({
    required this.id,
    required this.kind,
    required this.name,
    required this.area,
    required this.endorsedBy,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'name': name,
    'area': area,
    'endorsedBy': endorsedBy,
  };

  factory MobileCraftPro.fromJson(Map<String, dynamic> json) {
    return MobileCraftPro(
      id: json['id'] as String? ?? '',
      kind: MobileCraftKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => MobileCraftKind.electrician,
      ),
      name: json['name'] as String? ?? '',
      area: json['area'] as String? ?? 'Okolica',
      endorsedBy: json['endorsedBy'] as String? ?? 'Sąsiad',
    );
  }

  static List<MobileCraftPro> seeded() => const [
    MobileCraftPro(
      id: 'mc-slusarz',
      kind: MobileCraftKind.locksmith,
      name: 'Ślusarz 24h — Arek',
      area: 'osiedle wschodnie / okolica',
      endorsedBy: 'Klatka III, Parkowa',
    ),
    MobileCraftPro(
      id: 'mc-opony',
      kind: MobileCraftKind.tires,
      name: 'Mobilna wymiana opon przy bloku',
      area: 'Twoja okolica',
      endorsedBy: 'Tomek z garażu',
    ),
  ];
}
