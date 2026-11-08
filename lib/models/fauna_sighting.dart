enum FaunaKind { boar, fox, other }

extension FaunaKindX on FaunaKind {
  String get label => switch (this) {
    FaunaKind.boar => 'Dziki',
    FaunaKind.fox => 'Lis',
    FaunaKind.other => 'Inne dzikie zwierzę',
  };
}

class FaunaSighting {
  final String id;
  final FaunaKind kind;
  final String place;
  final String subDistrict;
  final String note;
  final String authorName;
  final DateTime seenAt;

  const FaunaSighting({
    required this.id,
    required this.kind,
    required this.place,
    required this.subDistrict,
    required this.note,
    required this.authorName,
    required this.seenAt,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'place': place,
    'subDistrict': subDistrict,
    'note': note,
    'authorName': authorName,
    'seenAt': seenAt.toIso8601String(),
  };

  factory FaunaSighting.fromJson(Map<String, dynamic> json) {
    return FaunaSighting(
      id: json['id'] as String? ?? '',
      kind: FaunaKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => FaunaKind.boar,
      ),
      place: json['place'] as String? ?? '',
      subDistrict: json['subDistrict'] as String? ?? 'Olechów',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      seenAt: DateTime.tryParse(json['seenAt'] as String? ?? '') ??
          DateTime(2026, 10, 28, 19),
    );
  }

  static List<FaunaSighting> seeded() => [
    FaunaSighting(
      id: 'fn-park',
      kind: FaunaKind.boar,
      place: 'Park Górka Widzewska — skraj zadrzewienia',
      subDistrict: 'Olechów',
      note: 'Wataha wieczorem przy blokach. Nie dokarmiać.',
      authorName: 'Sąsiadka z Olechowa',
      seenAt: DateTime(2026, 10, 28, 19, 10),
    ),
    FaunaSighting(
      id: 'fn-fox',
      kind: FaunaKind.fox,
      place: 'Park Baden-Powella',
      subDistrict: 'Stary Widzew',
      note: 'Lis przy alejce, spokojny.',
      authorName: 'Piotr',
      seenAt: DateTime(2026, 10, 27, 21),
    ),
  ];
}
