enum BikeHelpKind { pump, crankKey, wheelTrue }

extension BikeHelpKindX on BikeHelpKind {
  String get label => switch (this) {
    BikeHelpKind.pump => 'Pompka',
    BikeHelpKind.crankKey => 'Klucz do suportu',
    BikeHelpKind.wheelTrue => 'Centrowanie koła',
  };
}

class BikeHelpRequest {
  final String id;
  final BikeHelpKind kind;
  final String note;
  final String authorName;
  final String staircase;
  final bool offered;

  const BikeHelpRequest({
    required this.id,
    required this.kind,
    required this.note,
    required this.authorName,
    required this.staircase,
    this.offered = false,
  });

  BikeHelpRequest copyWith({bool? offered}) {
    return BikeHelpRequest(
      id: id,
      kind: kind,
      note: note,
      authorName: authorName,
      staircase: staircase,
      offered: offered ?? this.offered,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'note': note,
    'authorName': authorName,
    'staircase': staircase,
    'offered': offered,
  };

  factory BikeHelpRequest.fromJson(Map<String, dynamic> json) {
    return BikeHelpRequest(
      id: json['id'] as String? ?? '',
      kind: BikeHelpKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => BikeHelpKind.pump,
      ),
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      staircase: json['staircase'] as String? ?? 'Klatka I',
      offered: json['offered'] as bool? ?? false,
    );
  }

  static List<BikeHelpRequest> seeded() => const [
    BikeHelpRequest(
      id: 'bike-pump',
      kind: BikeHelpKind.pump,
      note: 'Kto pożyczy pompkę? Dziś wieczór, klatka II.',
      authorName: 'Ola',
      staircase: 'Klatka II',
    ),
    BikeHelpRequest(
      id: 'bike-crank',
      kind: BikeHelpKind.crankKey,
      note: 'Klucz do suportu na chwilę — serwis na klatce.',
      authorName: 'Bartek',
      staircase: 'Klatka IV',
    ),
    BikeHelpRequest(
      id: 'bike-wheel',
      kind: BikeHelpKind.wheelTrue,
      note: 'Pomoże ktoś w centrowaniu koła po krawężniku?',
      authorName: 'Michał',
      staircase: 'Klatka I',
    ),
  ];
}

class BikeRack {
  final String id;
  final String name;
  final String place;
  final String hint;

  const BikeRack({
    required this.id,
    required this.name,
    required this.place,
    required this.hint,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'place': place,
    'hint': hint,
  };

  factory BikeRack.fromJson(Map<String, dynamic> json) {
    return BikeRack(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      place: json['place'] as String? ?? '',
      hint: json['hint'] as String? ?? '',
    );
  }

  static List<BikeRack> seeded() => const [
    BikeRack(
      id: 'rack-batorego',
      name: 'Stojak przy DH Widzew',
      place: 'al. Piłsudskiego / Batorego',
      hint: 'Zadaszony, monitoring z galerii.',
    ),
    BikeRack(
      id: 'rack-olechow',
      name: 'Stojak przy SP 141',
      place: 'Olechów, przy boisku',
      hint: 'U-racki, najlepiej zapiąć ramę.',
    ),
    BikeRack(
      id: 'rack-park',
      name: 'Park Baden-Powella',
      place: 'Wejście od Puszkina',
      hint: 'Dwa rzędy, wieczorem oświetlone.',
    ),
  ];
}
