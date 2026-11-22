enum KidsCreationKind { drawing, bricks, schoolwork }

extension KidsCreationKindX on KidsCreationKind {
  String get label => switch (this) {
    KidsCreationKind.drawing => 'Rysunek',
    KidsCreationKind.bricks => 'Projekt z klocków',
    KidsCreationKind.schoolwork => 'Praca szkolna',
  };
}

class KidsCreation {
  final String id;
  final KidsCreationKind kind;
  final String title;
  final String caption;
  final String childName;
  final String authorName;

  const KidsCreation({
    required this.id,
    required this.kind,
    required this.title,
    required this.caption,
    required this.childName,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'caption': caption,
    'childName': childName,
    'authorName': authorName,
  };

  factory KidsCreation.fromJson(Map<String, dynamic> json) {
    return KidsCreation(
      id: json['id'] as String? ?? '',
      kind: KidsCreationKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => KidsCreationKind.drawing,
      ),
      title: json['title'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      childName: json['childName'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Rodzic',
    );
  }

  static List<KidsCreation> seeded() => const [
    KidsCreation(
      id: 'kid-rys',
      kind: KidsCreationKind.drawing,
      title: 'okolica w barwach klubu',
      caption: 'Kredki, format A3 — wystawa w klatce III.',
      childName: 'Zosia, 8 lat',
      authorName: 'Mama Zosi',
    ),
    KidsCreation(
      id: 'kid-lego',
      kind: KidsCreationKind.bricks,
      title: 'Stadion z klocków',
      caption: 'Model trybun i bramki, 1200 klocków.',
      childName: 'Kuba, 11 lat',
      authorName: 'Tata Kuby',
    ),
    KidsCreation(
      id: 'kid-szkola',
      kind: KidsCreationKind.schoolwork,
      title: 'Makieta osiedla na geografię',
      caption: 'Szkoła — bloki z kartonu i zielone podwórka.',
      childName: 'Maja, 12 lat',
      authorName: 'Mama Mai',
    ),
  ];
}
