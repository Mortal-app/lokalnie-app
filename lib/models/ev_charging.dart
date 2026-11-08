enum EvChargeKind { streetSpot, balconyCable }

extension EvChargeKindX on EvChargeKind {
  String get label => switch (this) {
    EvChargeKind.streetSpot => 'Ładowanie przy bloku / miejscu',
    EvChargeKind.balconyCable => 'Kabel balkonowy (parter / niskie piętro)',
  };
}

class EvChargingOffer {
  final String id;
  final EvChargeKind kind;
  final String title;
  final String place;
  final String hours;
  final bool neighborConsent;
  final String authorName;

  const EvChargingOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.place,
    required this.hours,
    required this.authorName,
    this.neighborConsent = false,
  });

  EvChargingOffer copyWith({bool? neighborConsent}) {
    return EvChargingOffer(
      id: id,
      kind: kind,
      title: title,
      place: place,
      hours: hours,
      authorName: authorName,
      neighborConsent: neighborConsent ?? this.neighborConsent,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'place': place,
    'hours': hours,
    'neighborConsent': neighborConsent,
    'authorName': authorName,
  };

  factory EvChargingOffer.fromJson(Map<String, dynamic> json) {
    return EvChargingOffer(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == EvChargeKind.balconyCable.name
          ? EvChargeKind.balconyCable
          : EvChargeKind.streetSpot,
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? 'Widzew',
      hours: json['hours'] as String? ?? '18:00–22:00',
      neighborConsent: json['neighborConsent'] as bool? ?? false,
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<EvChargingOffer> seeded() => const [
    EvChargingOffer(
      id: 'ev-miejsce',
      kind: EvChargeKind.streetSpot,
      title: 'Gniazdo 230 V przy hali garażowej — wieczorem',
      place: 'Widzew Wschód, klatka II',
      hours: '18:00–22:00',
      authorName: 'Marek',
      neighborConsent: true,
    ),
    EvChargingOffer(
      id: 'ev-balkon',
      kind: EvChargeKind.balconyCable,
      title: 'Kabel z balkonu parteru do hybrydy',
      place: 'Olechów, klatka I',
      hours: 'Po 19:00',
      authorName: 'Ola',
    ),
  ];
}
