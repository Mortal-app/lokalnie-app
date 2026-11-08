enum SkateKind { hockey, roller, inline, helmet }

extension SkateKindX on SkateKind {
  String get label => switch (this) {
    SkateKind.hockey => 'Łyżwy hokejowe',
    SkateKind.roller => 'Wrotki',
    SkateKind.inline => 'Rolki',
    SkateKind.helmet => 'Kask ochronny',
  };
}

class SeasonalSkateOffer {
  final String id;
  final SkateKind kind;
  final String title;
  final String authorName;

  const SeasonalSkateOffer({
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

  factory SeasonalSkateOffer.fromJson(Map<String, dynamic> json) {
    return SeasonalSkateOffer(
      id: json['id'] as String? ?? '',
      kind: SkateKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => SkateKind.inline,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Rodzic',
    );
  }

  static List<SeasonalSkateOffer> seeded() => const [
    SeasonalSkateOffer(
      id: 'ss-hok',
      kind: SkateKind.hockey,
      title: 'Łyżwy hokejowe 32 — dziecko wyrosło',
      authorName: 'Hania',
    ),
    SeasonalSkateOffer(
      id: 'ss-rol',
      kind: SkateKind.inline,
      title: 'Rolki 35 + kask — sezon letni',
      authorName: 'Kasia',
    ),
  ];
}
