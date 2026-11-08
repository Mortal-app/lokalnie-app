enum PuzzleKind { pieces500, pieces1000, pieces3000, logic }

extension PuzzleKindX on PuzzleKind {
  String get label => switch (this) {
    PuzzleKind.pieces500 => 'Puzzle 500',
    PuzzleKind.pieces1000 => 'Puzzle 1000',
    PuzzleKind.pieces3000 => 'Puzzle 3000',
    PuzzleKind.logic => 'Gra logiczna',
  };
}

class PuzzleSwapOffer {
  final String id;
  final PuzzleKind kind;
  final String title;
  final String authorName;

  const PuzzleSwapOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'authorName': authorName,
  };

  factory PuzzleSwapOffer.fromJson(Map<String, dynamic> json) {
    return PuzzleSwapOffer(
      id: json['id'] as String? ?? '',
      kind: PuzzleKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => PuzzleKind.pieces1000,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<PuzzleSwapOffer> seeded() => const [
    PuzzleSwapOffer(
      id: 'pz-1k',
      kind: PuzzleKind.pieces1000,
      title: 'Puzzle 1000 — zamek, ułożone, komplet',
      authorName: 'Hania',
    ),
    PuzzleSwapOffer(
      id: 'pz-log',
      kind: PuzzleKind.logic,
      title: 'Układanka logiczna po ułożeniu — oddam dalej',
      authorName: 'Piotr',
    ),
  ];
}
