class StreetArchiveEntry {
  final String id;
  final String currentName;
  final String formerName;
  final String era;
  final String body;

  const StreetArchiveEntry({
    required this.id,
    required this.currentName,
    required this.formerName,
    required this.era,
    required this.body,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'currentName': currentName,
    'formerName': formerName,
    'era': era,
    'body': body,
  };

  factory StreetArchiveEntry.fromJson(Map<String, dynamic> json) {
    return StreetArchiveEntry(
      id: json['id'] as String? ?? '',
      currentName: json['currentName'] as String? ?? '',
      formerName: json['formerName'] as String? ?? '',
      era: json['era'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  static List<StreetArchiveEntry> seeded() => const [
    StreetArchiveEntry(
      id: 'sa-pils',
      currentName: 'al. Piłsudskiego',
      formerName: 'ul. Główna / odcinki przedwojenne',
      era: 'Przed wojną — PRL — III RP',
      body:
          'Oś wschodniej Łodzi zmieniała patronów wraz z epokami. Dziś to główna arteria Widzewa.',
    ),
    StreetArchiveEntry(
      id: 'sa-rok',
      currentName: 'ul. Rokicińska',
      formerName: 'Trakt w stronę Rokicin',
      era: 'XIX w. — dziś',
      body:
          'Historyczny szlak za miasto; nazwa trzyma kierunek, choć osiedla wokół wyrosły od nowa.',
    ),
    StreetArchiveEntry(
      id: 'sa-olech',
      currentName: 'Olechów',
      formerName: 'Wieś Olechów / tereny kolejowe',
      era: 'Wieś — wielka płyta lat 70.–80.',
      body:
          'Z osady przy torach do wielkiego osiedla. Patroni ulic na Olechowie to często kolejarze i inżynierowie.',
    ),
  ];
}
