class ArchitectureSpot {
  final String id;
  final String title;
  final String era;
  final String body;

  const ArchitectureSpot({
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

  factory ArchitectureSpot.fromJson(Map<String, dynamic> json) {
    return ArchitectureSpot(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      era: json['era'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  static List<ArchitectureSpot> seeded() => const [
    ArchitectureSpot(
      id: 'ar-plyta',
      title: 'Wielka płyta w okolicy',
      era: 'lata 70.–80.',
      body:
          'Powtarzalne klatki, loggie i pawilony. Układ urbanistyczny z zielenią między blokami.',
    ),
    ArchitectureSpot(
      id: 'ar-punkt',
      title: 'Punktowce przy osiedlu',
      era: 'lata 80.',
      body:
          'Wysokie bloki-punktowce jako dominanty osiedla, klatki z windą i komórkami lokatorskimi.',
    ),
    ArchitectureSpot(
      id: 'ar-modern',
      title: 'Modernizm klatek i witryn',
      era: 'powojnie',
      body:
          'Proste elewacje, pasy okien w pawilonach usługowych, czytelny podział funkcji parteru.',
    ),
  ];
}
