enum SafetyClassKind { firstAid, homeDefense, burglary }

extension SafetyClassKindX on SafetyClassKind {
  String get label => switch (this) {
    SafetyClassKind.firstAid => 'Pierwsza pomoc',
    SafetyClassKind.homeDefense => 'Obrona domowa',
    SafetyClassKind.burglary => 'Zabezpieczenie przed włamaniem',
  };
}

class SafetyWorkshop {
  final String id;
  final SafetyClassKind kind;
  final String title;
  final String whenLabel;
  final String place;
  final String host;

  const SafetyWorkshop({
    required this.id,
    required this.kind,
    required this.title,
    required this.whenLabel,
    required this.place,
    required this.host,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'whenLabel': whenLabel,
    'place': place,
    'host': host,
  };

  factory SafetyWorkshop.fromJson(Map<String, dynamic> json) {
    return SafetyWorkshop(
      id: json['id'] as String? ?? '',
      kind: SafetyClassKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => SafetyClassKind.firstAid,
      ),
      title: json['title'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      place: json['place'] as String? ?? 'Klub osiedlowy',
      host: json['host'] as String? ?? 'Prowadzący',
    );
  }

  static List<SafetyWorkshop> seeded() => const [
    SafetyWorkshop(
      id: 'ss-pp',
      kind: SafetyClassKind.firstAid,
      title: 'Darmowa pierwsza pomoc — RKO i krwotoki',
      whenLabel: 'Sobota 10:00',
      place: 'Klub osiedlowy, Widzew Wschód',
      host: 'Ratownik Kuba',
    ),
    SafetyWorkshop(
      id: 'ss-dom',
      kind: SafetyClassKind.burglary,
      title: 'Drzwi, łańcuch, oświetlenie klatki',
      whenLabel: 'Czwartek 18:00',
      place: 'Świetlica',
      host: 'Straż Miejska — gość',
    ),
  ];
}
