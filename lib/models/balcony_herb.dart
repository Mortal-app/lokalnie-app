enum HerbKind { mint, basil, rosemary, seed }

extension HerbKindX on HerbKind {
  String get label => switch (this) {
    HerbKind.mint => 'Mięta',
    HerbKind.basil => 'Bazylia',
    HerbKind.rosemary => 'Rozmaryn',
    HerbKind.seed => 'Nasiona / szczepka',
  };
}

class BalconyHerbOffer {
  final String id;
  final HerbKind kind;
  final String title;
  final String care;
  final String authorName;

  const BalconyHerbOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.care,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'care': care,
    'authorName': authorName,
  };

  factory BalconyHerbOffer.fromJson(Map<String, dynamic> json) {
    return BalconyHerbOffer(
      id: json['id'] as String? ?? '',
      kind: HerbKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => HerbKind.mint,
      ),
      title: json['title'] as String? ?? '',
      care: json['care'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<BalconyHerbOffer> seeded() => const [
    BalconyHerbOffer(
      id: 'bh-mieta',
      kind: HerbKind.mint,
      title: 'Mięta z balkonu — oddam szczepkę',
      care: 'Dużo wody, doniczka z odpływem, cień po południu.',
      authorName: 'Ewa',
    ),
    BalconyHerbOffer(
      id: 'bh-baz',
      kind: HerbKind.basil,
      title: 'Bazylia i rozmaryn — nasiona',
      care: 'Słońce na loggii od południa, nie przelać rozmarynu.',
      authorName: 'Pani Krysia',
    ),
  ];
}
