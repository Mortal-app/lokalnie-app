class MemorialSpot {
  final String id;
  final String title;
  final String era;
  final String body;

  const MemorialSpot({
    required this.id,
    required this.title,
    required this.era,
    required this.body,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'era': era,
    'body': body,
  };

  factory MemorialSpot.fromJson(Map<String, dynamic> json) {
    return MemorialSpot(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      era: json['era'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  static List<MemorialSpot> seeded() => const [
    MemorialSpot(
      id: 'mm-cmentarz',
      title: 'Historyczny cmentarz we wschodniej części miasta',
      era: 'XIX–XX w.',
      body:
          'Miejsce pamięci przy wschodnich osiedlach — spokojny spacer edukacyjny, szacunek dla grobów.',
    ),
    MemorialSpot(
      id: 'mm-pomnik',
      title: 'Miejsce pamięci narodowej — okolica',
      era: 'XX w.',
      body:
          'Tablica i zieleń przy drodze do centrum. Krótka historia osiedla i ofiar wojen.',
    ),
  ];
}
