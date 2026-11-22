class BoardGameNight {
  final String id;
  final String title;
  final String games;
  final String place;
  final String whenLabel;
  final String host;

  const BoardGameNight({
    required this.id,
    required this.title,
    required this.games,
    required this.place,
    required this.whenLabel,
    required this.host,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'games': games,
    'place': place,
    'whenLabel': whenLabel,
    'host': host,
  };

  factory BoardGameNight.fromJson(Map<String, dynamic> json) {
    return BoardGameNight(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      games: json['games'] as String? ?? '',
      place: json['place'] as String? ?? 'Świetlica',
      whenLabel: json['whenLabel'] as String? ?? '',
      host: json['host'] as String? ?? 'Sąsiad',
    );
  }

  static List<BoardGameNight> seeded() => const [
    BoardGameNight(
      id: 'bg-swietlica',
      title: 'Wieczór planszówek bez prądu',
      games: 'Catan, Dixit, tysiąc',
      place: 'Świetlica osiedlowa, osiedle wschodnie',
      whenLabel: 'Piątek 18:30',
      host: 'Kasia',
    ),
    BoardGameNight(
      id: 'bg-klatka',
      title: 'Karty u sąsiada — klatka I',
      games: 'Uno, makao, brydż',
      place: 'okolica, klatka I',
      whenLabel: 'Sobota 19:00',
      host: 'Pan Józef',
    ),
  ];
}
