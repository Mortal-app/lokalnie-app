class WidzewFilmClip {
  final String id;
  final String title;
  final String era;
  final String source;
  final String body;

  const WidzewFilmClip({
    required this.id,
    required this.title,
    required this.era,
    required this.source,
    required this.body,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'era': era,
    'source': source,
    'body': body,
  };

  factory WidzewFilmClip.fromJson(Map<String, dynamic> json) {
    return WidzewFilmClip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      era: json['era'] as String? ?? '',
      source: json['source'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  static List<WidzewFilmClip> seeded() => const [
    WidzewFilmClip(
      id: 'wf-plyta',
      title: 'Kronika: wielka płyta na wschodzie Łodzi',
      era: 'lata 70.–80.',
      source: 'Archiwum PKF / opis odnośnika (bez odtwarzacza)',
      body:
          'Budowa blokowisk okolicy — dźwigi, płyty, nowe klatki.',
    ),
    WidzewFilmClip(
      id: 'wf-knie',
      title: 'Okolica w starym kinie',
      era: 'powojnie',
      source: 'Kronika filmowa — tytuł i opis do wyszukania',
      body: 'Ulice i commuters przy torach, zanim wyrosły osiedla.',
    ),
  ];
}
