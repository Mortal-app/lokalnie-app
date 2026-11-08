enum RetroItKind { parts, cooling, service }

extension RetroItKindX on RetroItKind {
  String get label => switch (this) {
    RetroItKind.parts => 'Wymiana podzespołów',
    RetroItKind.cooling => 'Czyszczenie chłodzenia',
    RetroItKind.service => 'Serwis laptopa / PC',
  };
}

class RetroItOffer {
  final String id;
  final String title;
  final String description;
  final RetroItKind kind;
  final String authorName;
  final String place;

  const RetroItOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.authorName,
    required this.place,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'kind': kind.name,
    'authorName': authorName,
    'place': place,
  };

  factory RetroItOffer.fromJson(Map<String, dynamic> json) {
    return RetroItOffer(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      kind: RetroItKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => RetroItKind.parts,
      ),
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      place: json['place'] as String? ?? 'Widzew',
    );
  }

  static List<RetroItOffer> seeded() => const [
    RetroItOffer(
      id: 'it-ram',
      title: 'Oddam DDR3 2×4 GB',
      description: 'Po upgrade stacjonarki. Odbiór klatka III, Przybyszewskiego.',
      kind: RetroItKind.parts,
      authorName: 'Tomek',
      place: 'Stary Widzew',
    ),
    RetroItOffer(
      id: 'it-cool',
      title: 'Czyszczenie laptopów po pracy',
      description: 'Pasta + sprężone powietrze, wieczorami w piwnicy warsztatowej.',
      kind: RetroItKind.cooling,
      authorName: 'Arek',
      place: 'Olechów',
    ),
    RetroItOffer(
      id: 'it-pc',
      title: 'Diagnostyka PC i wymiana dysku',
      description: 'Klonowanie HDD→SSD, Windows, drobne naprawy na miejscu.',
      kind: RetroItKind.service,
      authorName: 'Sąsiad z Janowa',
      place: 'Janów',
    ),
  ];
}
