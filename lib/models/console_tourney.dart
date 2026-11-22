enum ConsolePlatform { ps, xbox, pc }

extension ConsolePlatformX on ConsolePlatform {
  String get label => switch (this) {
    ConsolePlatform.ps => 'PlayStation',
    ConsolePlatform.xbox => 'Xbox',
    ConsolePlatform.pc => 'PC',
  };
}

class ConsoleTourney {
  final String id;
  final ConsolePlatform platform;
  final String title;
  final String game;
  final String place;
  final String whenLabel;
  final String host;

  const ConsoleTourney({
    required this.id,
    required this.platform,
    required this.title,
    required this.game,
    required this.place,
    required this.whenLabel,
    required this.host,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'platform': platform.name,
    'title': title,
    'game': game,
    'place': place,
    'whenLabel': whenLabel,
    'host': host,
  };

  factory ConsoleTourney.fromJson(Map<String, dynamic> json) {
    return ConsoleTourney(
      id: json['id'] as String? ?? '',
      platform: ConsolePlatform.values.firstWhere(
        (item) => item.name == json['platform'],
        orElse: () => ConsolePlatform.ps,
      ),
      title: json['title'] as String? ?? '',
      game: json['game'] as String? ?? '',
      place: json['place'] as String? ?? 'Klub osiedlowy',
      whenLabel: json['whenLabel'] as String? ?? '',
      host: json['host'] as String? ?? 'Organizator',
    );
  }

  static List<ConsoleTourney> seeded() => const [
    ConsoleTourney(
      id: 'ct-fc',
      platform: ConsolePlatform.ps,
      title: 'Turniej FC — puchar klatki',
      game: 'EA FC',
      place: 'Świetlica, TV 55"',
      whenLabel: 'Sobota 17:00',
      host: 'Bartek',
    ),
    ConsoleTourney(
      id: 'ct-tekken',
      platform: ConsolePlatform.xbox,
      title: 'Tekken / Mortal Kombat',
      game: 'Bijatyk',
      place: 'Klub osiedlowy, okolica',
      whenLabel: 'Niedziela 16:00',
      host: 'Arek',
    ),
  ];
}
