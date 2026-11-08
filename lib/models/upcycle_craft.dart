enum UpcycleKind { clothes, bannerBag, decor }

extension UpcycleKindX on UpcycleKind {
  String get label => switch (this) {
    UpcycleKind.clothes => 'Przeróbka ubrań',
    UpcycleKind.bannerBag => 'Torba z banneru',
    UpcycleKind.decor => 'Dekoracja z odzysku',
  };
}

class UpcycleOffer {
  final String id;
  final UpcycleKind kind;
  final String title;
  final String authorName;

  const UpcycleOffer({
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

  factory UpcycleOffer.fromJson(Map<String, dynamic> json) {
    return UpcycleOffer(
      id: json['id'] as String? ?? '',
      kind: UpcycleKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => UpcycleKind.clothes,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiadka',
    );
  }

  static List<UpcycleOffer> seeded() => const [
    UpcycleOffer(
      id: 'uc-torba',
      kind: UpcycleKind.bannerBag,
      title: 'Szyję torby ekologiczne z bannerów po festynie',
      authorName: 'Ewa',
    ),
    UpcycleOffer(
      id: 'uc-jeans',
      kind: UpcycleKind.clothes,
      title: 'Przerabiam dżinsy na fartuchy i worki na zakupy',
      authorName: 'Magda',
    ),
  ];
}
