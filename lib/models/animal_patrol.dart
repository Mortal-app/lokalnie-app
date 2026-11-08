enum AnimalPatrolKind { welfare, shelter, feralCat }

extension AnimalPatrolKindX on AnimalPatrolKind {
  String get label => switch (this) {
    AnimalPatrolKind.welfare => 'Interwencja — dobrostan',
    AnimalPatrolKind.shelter => 'Współpraca ze schroniskiem',
    AnimalPatrolKind.feralCat => 'Dokarmianie kotów wolno żyjących',
  };
}

class AnimalPatrolReport {
  final String id;
  final AnimalPatrolKind kind;
  final String place;
  final String note;
  final String authorName;

  const AnimalPatrolReport({
    required this.id,
    required this.kind,
    required this.place,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'place': place,
    'note': note,
    'authorName': authorName,
  };

  factory AnimalPatrolReport.fromJson(Map<String, dynamic> json) {
    return AnimalPatrolReport(
      id: json['id'] as String? ?? '',
      kind: AnimalPatrolKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => AnimalPatrolKind.feralCat,
      ),
      place: json['place'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Patrol',
    );
  }

  static List<AnimalPatrolReport> seeded() => const [
    AnimalPatrolReport(
      id: 'ap-koty',
      kind: AnimalPatrolKind.feralCat,
      place: 'Piwnica klatki IV, Olechów',
      note: 'Budka i karma sucha — dyżur wieczorny.',
      authorName: 'Pani Krysia',
    ),
    AnimalPatrolReport(
      id: 'ap-schron',
      kind: AnimalPatrolKind.shelter,
      place: 'Zbiórka koców — schronisko partnerskie',
      note: 'Koce i miski w sobotę przy DH Widzew.',
      authorName: 'Ania',
    ),
  ];
}
