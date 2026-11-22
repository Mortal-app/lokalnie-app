enum PramRackKind { freeSlot, abandonedBike, abandonedPram }

extension PramRackKindX on PramRackKind {
  String get label => switch (this) {
    PramRackKind.freeSlot => 'Wolne miejsce',
    PramRackKind.abandonedBike => 'Porzucony rower',
    PramRackKind.abandonedPram => 'Porzucony wózek',
  };
}

class PramRackNotice {
  final String id;
  final PramRackKind kind;
  final String place;
  final String note;
  final String authorName;

  const PramRackNotice({
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

  factory PramRackNotice.fromJson(Map<String, dynamic> json) {
    return PramRackNotice(
      id: json['id'] as String? ?? '',
      kind: PramRackKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => PramRackKind.freeSlot,
      ),
      place: json['place'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<PramRackNotice> seeded() => const [
    PramRackNotice(
      id: 'pr-wolne',
      kind: PramRackKind.freeSlot,
      place: 'Wózkownia klatka I, osiedle wschodnie',
      note: 'Dwa haki wolne przy lewej ścianie.',
      authorName: 'Marek',
    ),
    PramRackNotice(
      id: 'pr-rower',
      kind: PramRackKind.abandonedBike,
      place: 'Stojak przy osiedlu, blok 12',
      note: 'Rower bez kół od tygodni — do uporządkowania.',
      authorName: 'Ola',
    ),
  ];
}
