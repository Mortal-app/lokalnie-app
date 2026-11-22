enum PassageCraftKind { cobbler, keys, knives }

extension PassageCraftKindX on PassageCraftKind {
  String get label => switch (this) {
    PassageCraftKind.cobbler => 'Szewc',
    PassageCraftKind.keys => 'Dorabianie kluczy',
    PassageCraftKind.knives => 'Ostrzenie noży',
  };
}

class CraftPassageService {
  final String id;
  final PassageCraftKind kind;
  final String name;
  final String place;
  final String hours;
  final bool mobile;

  const CraftPassageService({
    required this.id,
    required this.kind,
    required this.name,
    required this.place,
    required this.hours,
    this.mobile = false,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'name': name,
    'place': place,
    'hours': hours,
    'mobile': mobile,
  };

  factory CraftPassageService.fromJson(Map<String, dynamic> json) {
    return CraftPassageService(
      id: json['id'] as String? ?? '',
      kind: PassageCraftKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => PassageCraftKind.cobbler,
      ),
      name: json['name'] as String? ?? '',
      place: json['place'] as String? ?? 'Okolica',
      hours: json['hours'] as String? ?? '',
      mobile: json['mobile'] as bool? ?? false,
    );
  }

  static List<CraftPassageService> seeded() => const [
    CraftPassageService(
      id: 'cp-szewc',
      kind: PassageCraftKind.cobbler,
      name: 'Szewc u Stanisława',
      place: 'Pasaż przy głównej arterii',
      hours: 'Pn–Pt 10–17',
    ),
    CraftPassageService(
      id: 'cp-keys',
      kind: PassageCraftKind.keys,
      name: 'Klucze mobilne — furgonetka',
      place: 'okolica, środy przy sklepie',
      hours: 'Śr 15–19',
      mobile: true,
    ),
    CraftPassageService(
      id: 'cp-knives',
      kind: PassageCraftKind.knives,
      name: 'Ostrzenie noży i nożyczek',
      place: 'stare osiedle, budka przy pętli',
      hours: 'Sob 9–13',
    ),
  ];
}
