enum PrlPieceKind { armchair366, sideboard, stickChair }

extension PrlPieceKindX on PrlPieceKind {
  String get label => switch (this) {
    PrlPieceKind.armchair366 => 'Fotel 366',
    PrlPieceKind.sideboard => 'Komoda PRL',
    PrlPieceKind.stickChair => 'Krzesło patyczak',
  };
}

class PrlFurniturePost {
  final String id;
  final PrlPieceKind kind;
  final String title;
  final String tip;
  final String authorName;

  const PrlFurniturePost({
    required this.id,
    required this.kind,
    required this.title,
    required this.tip,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'tip': tip,
    'authorName': authorName,
  };

  factory PrlFurniturePost.fromJson(Map<String, dynamic> json) {
    return PrlFurniturePost(
      id: json['id'] as String? ?? '',
      kind: PrlPieceKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => PrlPieceKind.armchair366,
      ),
      title: json['title'] as String? ?? '',
      tip: json['tip'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Renowator',
    );
  }

  static List<PrlFurniturePost> seeded() => const [
    PrlFurniturePost(
      id: 'prl-366',
      kind: PrlPieceKind.armchair366,
      title: 'Fotel 366 — tapicerka wełna',
      tip: 'Odsysanie, potem tkanina wełniana; stelaż — olej lniany, nie chemia żrąca.',
      authorName: 'Jacek',
    ),
    PrlFurniturePost(
      id: 'prl-patyk',
      kind: PrlPieceKind.stickChair,
      title: 'Patyczaki — lakier poliuretanowy',
      tip: 'Szlif 180, podkład, dwa cienkie lakiery. Unikać gąbek z rozpuszczalnikiem na fornirze.',
      authorName: 'Pani Halina',
    ),
  ];
}
