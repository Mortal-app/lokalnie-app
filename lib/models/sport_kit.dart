enum SportKitKind { peKit, boots, pads }

extension SportKitKindX on SportKitKind {
  String get label => switch (this) {
    SportKitKind.peKit => 'Strój na WF',
    SportKitKind.boots => 'Korki piłkarskie',
    SportKitKind.pads => 'Ochraniacze',
  };
}

class SportKitOffer {
  final String id;
  final SportKitKind kind;
  final String title;
  final String size;
  final String authorName;

  const SportKitOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.size,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'size': size,
    'authorName': authorName,
  };

  factory SportKitOffer.fromJson(Map<String, dynamic> json) {
    return SportKitOffer(
      id: json['id'] as String? ?? '',
      kind: SportKitKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => SportKitKind.peKit,
      ),
      title: json['title'] as String? ?? '',
      size: json['size'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Rodzic',
    );
  }

  static List<SportKitOffer> seeded() => const [
    SportKitOffer(
      id: 'sk-wf',
      kind: SportKitKind.peKit,
      title: 'Granatowy strój na WF — dziecko wyrosło',
      size: '134–140',
      authorName: 'Hania',
    ),
    SportKitOffer(
      id: 'sk-korki',
      kind: SportKitKind.boots,
      title: 'Korki 33 — oddam za ochraniacze 140',
      size: '33',
      authorName: 'Tomek',
    ),
  ];
}
