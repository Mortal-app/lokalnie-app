enum FoundPlateKind { plate, carKey }

extension FoundPlateKindX on FoundPlateKind {
  String get label => switch (this) {
    FoundPlateKind.plate => 'Tablica rejestracyjna',
    FoundPlateKind.carKey => 'Kluczyk samochodowy',
  };
}

class FoundPlateAlert {
  final String id;
  final FoundPlateKind kind;
  final String place;
  final String note;
  final String authorName;
  final String weather;

  const FoundPlateAlert({
    required this.id,
    required this.kind,
    required this.place,
    required this.note,
    required this.authorName,
    this.weather = 'Po opadach',
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'place': place,
    'note': note,
    'authorName': authorName,
    'weather': weather,
  };

  factory FoundPlateAlert.fromJson(Map<String, dynamic> json) {
    return FoundPlateAlert(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == FoundPlateKind.carKey.name
          ? FoundPlateKind.carKey
          : FoundPlateKind.plate,
      place: json['place'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      weather: json['weather'] as String? ?? 'Po opadach',
    );
  }

  static List<FoundPlateAlert> seeded() => const [
    FoundPlateAlert(
      id: 'fp-tab',
      kind: FoundPlateKind.plate,
      place: 'Parking przy centrum handlowym, przy kałuży',
      note: 'Tablica EL… — bez numeru w ogłoszeniu, odebrać w portierni.',
      authorName: 'Tomek',
      weather: 'Po ulewie',
    ),
    FoundPlateAlert(
      id: 'fp-klucz',
      kind: FoundPlateKind.carKey,
      place: 'Śnieg przy klatce IV, okolica',
      note: 'Kluczyk z brelokiem okolica — w skrzynce zarządu.',
      authorName: 'Pani Halina',
      weather: 'Po śniegu',
    ),
  ];
}
