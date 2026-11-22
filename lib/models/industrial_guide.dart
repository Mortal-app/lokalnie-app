class IndustrialSpot {
  final String id;
  final String title;
  final String era;
  final String body;
  final String walk;

  const IndustrialSpot({
    required this.id,
    required this.title,
    required this.era,
    required this.body,
    required this.walk,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'era': era,
    'body': body,
    'walk': walk,
  };

  factory IndustrialSpot.fromJson(Map<String, dynamic> json) {
    return IndustrialSpot(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      era: json['era'] as String? ?? '',
      body: json['body'] as String? ?? '',
      walk: json['walk'] as String? ?? '',
    );
  }

  static List<IndustrialSpot> seeded() => const [
    IndustrialSpot(
      id: 'ind-km',
      title: 'Twoja okolica',
      era: 'XIX w., osada fabryczna',
      body:
          'Osada fabryczna Scheiblera: cegła, bruki i familoki. Graniczy z trasami z okolicy w stronę centrum.',
      walk: 'Trasa 1: osiedle → osada fabryczna (ok. 40 min pieszo / tramwaj).',
    ),
    IndustrialSpot(
      id: 'ind-scheib',
      title: 'Zespół fabryczny — kominy i bramy',
      era: 'przemysł włókienniczy',
      body:
          'Zachowane bramy wjazdowe i kominy — punkt startu spaceru industrialnego.',
      walk: 'Trasa 2: pętla wokół dawnych hal, 2,5 km.',
    ),
    IndustrialSpot(
      id: 'ind-widzew',
      title: 'Osiedlowa nitka do fabryk',
      era: 'XX w.',
      body:
          'Kolej i bocznice łączące osiedla wschodnie z kompleksem Księżego Młyna.',
      walk: 'Trasa 3: rower wzdłuż torów, powrót Głównej.',
    ),
  ];
}
