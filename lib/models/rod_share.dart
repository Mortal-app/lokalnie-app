enum RodShareKind { tools, harvest, paving }

extension RodShareKindX on RodShareKind {
  String get label => switch (this) {
    RodShareKind.tools => 'Narzędzia ogrodowe',
    RodShareKind.harvest => 'Nadwyżka plonów',
    RodShareKind.paving => 'Kostka brukowa',
  };
}

class RodShare {
  final String id;
  final RodShareKind kind;
  final String title;
  final String garden;
  final String authorName;

  const RodShare({
    required this.id,
    required this.kind,
    required this.title,
    required this.garden,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'garden': garden,
    'authorName': authorName,
  };

  factory RodShare.fromJson(Map<String, dynamic> json) {
    return RodShare(
      id: json['id'] as String? ?? '',
      kind: RodShareKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => RodShareKind.tools,
      ),
      title: json['title'] as String? ?? '',
      garden: json['garden'] as String? ?? 'ROD im. Władysława Reymonta',
      authorName: json['authorName'] as String? ?? 'Działkowiec',
    );
  }

  static List<RodShare> seeded() => const [
    RodShare(
      id: 'rod-lopata',
      kind: RodShareKind.tools,
      title: 'Glebogryzarka na niedzielę — ROD Reymonta',
      garden: 'ROD im. Władysława Reymonta',
      authorName: 'Pan Józef',
    ),
    RodShare(
      id: 'rod-jabka',
      kind: RodShareKind.harvest,
      title: 'Nadwyżka jabłek i cukinii z działki',
      garden: 'ROD im. Władysława Reymonta',
      authorName: 'Pani Zosia',
    ),
    RodShare(
      id: 'rod-kostka',
      kind: RodShareKind.paving,
      title: 'Została kostka brukowa po alejce — oddam na krawężniki',
      garden: 'ROD im. Władysława Reymonta',
      authorName: 'Pan Józef',
    ),
  ];
}
