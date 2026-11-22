enum PcvSeason { winter, summer }

extension PcvSeasonX on PcvSeason {
  String get label => switch (this) {
    PcvSeason.winter => 'Regulacja zimowa',
    PcvSeason.summer => 'Regulacja letnia',
  };
}

class PcvWindowTip {
  final String id;
  final PcvSeason season;
  final String title;
  final String body;
  final String authorName;

  const PcvWindowTip({
    required this.id,
    required this.season,
    required this.title,
    required this.body,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'season': season.name,
    'title': title,
    'body': body,
    'authorName': authorName,
  };

  factory PcvWindowTip.fromJson(Map<String, dynamic> json) {
    return PcvWindowTip(
      id: json['id'] as String? ?? '',
      season: json['season'] == PcvSeason.summer.name
          ? PcvSeason.summer
          : PcvSeason.winter,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Fachowiec',
    );
  }

  static List<PcvWindowTip> seeded() => const [
    PcvWindowTip(
      id: 'pcv-zima',
      season: PcvSeason.winter,
      title: 'Okucia na zimę — mimośród w stronę uszczelki',
      body:
          'Przed mrozem: klamka w dół, docisk. Pomogę na klatce II, osiedle wschodnie.',
      authorName: 'Pan Marek',
    ),
    PcvWindowTip(
      id: 'pcv-lato',
      season: PcvSeason.summer,
      title: 'Lato: luz na okuciach, żeby nie zgniatać uszczelek',
      body: 'Regulacja 15 min na skrzydło. Klucz imbus 4 mm.',
      authorName: 'Arek',
    ),
  ];
}
