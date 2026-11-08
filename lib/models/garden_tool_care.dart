enum GardenToolKind { pruner, hedge, mower }

extension GardenToolKindX on GardenToolKind {
  String get label => switch (this) {
    GardenToolKind.pruner => 'Sekator',
    GardenToolKind.hedge => 'Nożyce do żywopłotu',
    GardenToolKind.mower => 'Kosiarka',
  };
}

class GardenToolCareOffer {
  final String id;
  final GardenToolKind kind;
  final String title;
  final String authorName;

  const GardenToolCareOffer({
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

  factory GardenToolCareOffer.fromJson(Map<String, dynamic> json) {
    return GardenToolCareOffer(
      id: json['id'] as String? ?? '',
      kind: GardenToolKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => GardenToolKind.pruner,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Majster',
    );
  }

  static List<GardenToolCareOffer> seeded() => const [
    GardenToolCareOffer(
      id: 'gt-sek',
      kind: GardenToolKind.pruner,
      title: 'Ostrzę sekatory przed sezonem — klatka III',
      authorName: 'Zbyszek',
    ),
    GardenToolCareOffer(
      id: 'gt-kos',
      kind: GardenToolKind.mower,
      title: 'Konserwacja kosiarki i wymiana oleju, działki przy Rokicińskiej',
      authorName: 'Arek',
    ),
  ];
}
