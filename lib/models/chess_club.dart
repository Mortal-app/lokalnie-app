class ChessChallenge {
  final String id;
  final String title;
  final String place;
  final String whenLabel;
  final String host;
  final int ratingHint;

  const ChessChallenge({
    required this.id,
    required this.title,
    required this.place,
    required this.whenLabel,
    required this.host,
    this.ratingHint = 1200,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'place': place,
    'whenLabel': whenLabel,
    'host': host,
    'ratingHint': ratingHint,
  };

  factory ChessChallenge.fromJson(Map<String, dynamic> json) {
    return ChessChallenge(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? 'Park',
      whenLabel: json['whenLabel'] as String? ?? '',
      host: json['host'] as String? ?? 'Szachista',
      ratingHint: json['ratingHint'] as int? ?? 1200,
    );
  }

  static List<ChessChallenge> seeded() => const [
    ChessChallenge(
      id: 'ch-park',
      title: 'Sparing weekendowy — blitz 5+3',
      place: 'Park Baden-Powella, stoliki',
      whenLabel: 'Sobota 11:00',
      host: 'Pan Józef',
      ratingHint: 1400,
    ),
    ChessChallenge(
      id: 'ch-swiet',
      title: 'Wyzwanie szachowe w świetlicy',
      place: 'Świetlica osiedlowa',
      whenLabel: 'Niedziela 16:00',
      host: 'Klub logiczny',
      ratingHint: 1100,
    ),
  ];
}
