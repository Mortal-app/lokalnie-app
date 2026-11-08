enum EmergencyGearKind { dehumidifier, wetVac, projector }

extension EmergencyGearKindX on EmergencyGearKind {
  String get label => switch (this) {
    EmergencyGearKind.dehumidifier => 'Osuszacz budowlany',
    EmergencyGearKind.wetVac => 'Odkurzacz piorący',
    EmergencyGearKind.projector => 'Projektor',
  };
}

class EmergencyRentalItem {
  final String id;
  final EmergencyGearKind kind;
  final String terms;
  final String authorName;

  const EmergencyRentalItem({
    required this.id,
    required this.kind,
    required this.terms,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'terms': terms,
    'authorName': authorName,
  };

  factory EmergencyRentalItem.fromJson(Map<String, dynamic> json) {
    return EmergencyRentalItem(
      id: json['id'] as String? ?? '',
      kind: EmergencyGearKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => EmergencyGearKind.dehumidifier,
      ),
      terms: json['terms'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<EmergencyRentalItem> seeded() => const [
    EmergencyRentalItem(
      id: 'er-osusz',
      kind: EmergencyGearKind.dehumidifier,
      terms: 'Po zalaniu — za przysługę / kawę',
      authorName: 'Pan Marek',
    ),
    EmergencyRentalItem(
      id: 'er-pior',
      kind: EmergencyGearKind.wetVac,
      terms: 'Symboliczna opłata 20 zł / dzień',
      authorName: 'Ola',
    ),
    EmergencyRentalItem(
      id: 'er-proj',
      kind: EmergencyGearKind.projector,
      terms: 'Wieczór filmowy na klatce — za przysługę',
      authorName: 'Tomek',
    ),
  ];
}
