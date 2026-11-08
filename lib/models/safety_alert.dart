enum SafetyAlertKind { burglary, intercom, vehicle, other }

extension SafetyAlertKindX on SafetyAlertKind {
  String get label => switch (this) {
    SafetyAlertKind.burglary => 'Próba włamania / piwnica',
    SafetyAlertKind.intercom => 'Uszkodzony domofon',
    SafetyAlertKind.vehicle => 'Dziwny pojazd',
    SafetyAlertKind.other => 'Inna aktywność',
  };
}

class SafetyAlert {
  final String id;
  final String title;
  final String description;
  final SafetyAlertKind kind;
  final String place;
  final String authorName;
  final String subDistrict;
  final int witnessCount;
  final bool iWitnessed;

  const SafetyAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.place,
    required this.authorName,
    required this.subDistrict,
    this.witnessCount = 1,
    this.iWitnessed = false,
  });

  SafetyAlert confirmWitness() {
    if (iWitnessed) return this;
    return copyWith(iWitnessed: true, witnessCount: witnessCount + 1);
  }

  SafetyAlert copyWith({int? witnessCount, bool? iWitnessed}) {
    return SafetyAlert(
      id: id,
      title: title,
      description: description,
      kind: kind,
      place: place,
      authorName: authorName,
      subDistrict: subDistrict,
      witnessCount: witnessCount ?? this.witnessCount,
      iWitnessed: iWitnessed ?? this.iWitnessed,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'kind': kind.name,
    'place': place,
    'authorName': authorName,
    'subDistrict': subDistrict,
    'witnessCount': witnessCount,
    'iWitnessed': iWitnessed,
  };

  factory SafetyAlert.fromJson(Map<String, dynamic> json) {
    return SafetyAlert(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      kind: SafetyAlertKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => SafetyAlertKind.other,
      ),
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Widzew Wschód',
      witnessCount: json['witnessCount'] as int? ?? 1,
      iWitnessed: json['iWitnessed'] as bool? ?? false,
    );
  }

  static List<SafetyAlert> seeded() => const [
    SafetyAlert(
      id: 'safe-cellar',
      title: 'Próba włamania do piwnic',
      description: 'W nocy słychać było dobijanie do kratek przy śmietniku.',
      kind: SafetyAlertKind.burglary,
      place: 'Klatka III, Olechów',
      authorName: 'Sąsiadka z Olechowa',
      subDistrict: 'Olechów',
      witnessCount: 2,
    ),
    SafetyAlert(
      id: 'safe-intercom',
      title: 'Uszkodzony domofon',
      description: 'Nie działa unifon, drzwi zostają uchylone.',
      kind: SafetyAlertKind.intercom,
      place: 'ul. Przybyszewskiego',
      authorName: 'Sąsiad ze Starego Widzewa',
      subDistrict: 'Stary Widzew',
    ),
    SafetyAlert(
      id: 'safe-car',
      title: 'Dziwny pojazd krąży po osiedlu',
      description: 'Ciemny van bez tablic, stoi przy klatce po 22:00.',
      kind: SafetyAlertKind.vehicle,
      place: 'ul. Rokicińska',
      authorName: 'Sąsiad z Widzewa Wschód',
      subDistrict: 'Widzew Wschód',
      witnessCount: 3,
    ),
  ];
}
