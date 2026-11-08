enum JarSwapKind { empty, jam, kompot }

extension JarSwapKindX on JarSwapKind {
  String get label => switch (this) {
    JarSwapKind.empty => 'Puste słoiki',
    JarSwapKind.jam => 'Dżem / konfitura',
    JarSwapKind.kompot => 'Kompot',
  };
}

class JarSwapOffer {
  final String id;
  final JarSwapKind kind;
  final String title;
  final String authorName;

  const JarSwapOffer({
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

  factory JarSwapOffer.fromJson(Map<String, dynamic> json) {
    return JarSwapOffer(
      id: json['id'] as String? ?? '',
      kind: JarSwapKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => JarSwapKind.empty,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<JarSwapOffer> seeded() => const [
    JarSwapOffer(
      id: 'js-puste',
      kind: JarSwapKind.empty,
      title: 'Dam puste słoiki po konfiturach za słoik domowego dżemu lub kompotu',
      authorName: 'Pani Zosia',
    ),
    JarSwapOffer(
      id: 'js-dzem',
      kind: JarSwapKind.jam,
      title: 'Malinowy dżem z ROD — 3 słoiki, chcę puste 0,9 l',
      authorName: 'Pan Józef',
    ),
  ];
}
