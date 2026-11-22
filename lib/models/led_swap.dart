class LedSwapItem {
  final String id;
  final String title;
  final String place;
  final String authorName;

  const LedSwapItem({
    required this.id,
    required this.title,
    required this.place,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'place': place,
    'authorName': authorName,
  };

  factory LedSwapItem.fromJson(Map<String, dynamic> json) {
    return LedSwapItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? 'Okolica',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<LedSwapItem> seeded() => const [
    LedSwapItem(
      id: 'led-e27',
      title: 'Żarówki LED E27 9 W — 4 sztuki po remoncie',
      place: 'Klatka II, osiedle wschodnie',
      authorName: 'Arek',
    ),
    LedSwapItem(
      id: 'led-g4',
      title: 'Pozostałe halogeny LED do szafek kuchennych',
      place: 'Okolica',
      authorName: 'Kasia',
    ),
  ];
}
