class TimelineEra {
  final String id;
  final String decade;
  final String title;
  final String body;

  const TimelineEra({
    required this.id,
    required this.decade,
    required this.title,
    required this.body,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'decade': decade,
    'title': title,
    'body': body,
  };

  factory TimelineEra.fromJson(Map<String, dynamic> json) {
    return TimelineEra(
      id: json['id'] as String? ?? '',
      decade: json['decade'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  static List<TimelineEra> seeded() => const [
    TimelineEra(
      id: 'tl-70',
      decade: 'lata 70.',
      title: 'Wielka płyta w okolicy',
      body:
          'Pierwsze bloki z wielkiej płyty, szkoła i pawilony. Osiedle rośnie wraz z zakładami.',
    ),
    TimelineEra(
      id: 'tl-80',
      decade: 'lata 80.',
      title: 'Osiedle nabiera kształtu',
      body:
          'Nowe klatki, zieleń między blokami, tramwaj w stronę centrum. Życie osiedlowe w klubach.',
    ),
    TimelineEra(
      id: 'tl-90',
      decade: 'lata 90.',
      title: 'Osiedle i nowe pawilony',
      body:
          'Po transformacji — sklepy w parterach, garaże, pierwsze wspólnoty obok spółdzielni.',
    ),
    TimelineEra(
      id: 'tl-00',
      decade: 'lata 2000.',
      title: 'Docieplenia i place zabaw',
      body:
          'Termomodernizacja elewacji, nowe place i ścieżki. Osiedle spina się z sąsiednimi kwartałami.',
    ),
    TimelineEra(
      id: 'tl-10',
      decade: 'lata 2010.',
      title: 'Rewitalizacja i nowe osiedla',
      body:
          'Inwestycje deweloperskie przy Głównej, remonty szkół, więcej zieleni przy parkach.',
    ),
  ];
}
