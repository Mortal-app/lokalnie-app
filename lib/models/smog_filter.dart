enum SmogFilterKind { purifier, mask }

extension SmogFilterKindX on SmogFilterKind {
  String get label => switch (this) {
    SmogFilterKind.purifier => 'Filtr do oczyszczacza',
    SmogFilterKind.mask => 'Maska antysmogowa',
  };
}

class SmogFilterOffer {
  final String id;
  final SmogFilterKind kind;
  final String title;
  final String authorName;

  const SmogFilterOffer({
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

  factory SmogFilterOffer.fromJson(Map<String, dynamic> json) {
    return SmogFilterOffer(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == SmogFilterKind.mask.name
          ? SmogFilterKind.mask
          : SmogFilterKind.purifier,
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<SmogFilterOffer> seeded() => const [
    SmogFilterOffer(
      id: 'sf-hepa',
      kind: SmogFilterKind.purifier,
      title: 'Zbiorczy zakup filtrów HEPA — 4 sztuki, Olechów',
      authorName: 'Kasia',
    ),
    SmogFilterOffer(
      id: 'sf-mask',
      kind: SmogFilterKind.mask,
      title: 'Oddam 2 maski FFP2, wymienię na filtry do Xiaomi',
      authorName: 'Tomek',
    ),
  ];
}
