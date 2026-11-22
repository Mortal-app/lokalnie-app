class BikeTrip {
  final String id;
  final String title;
  final String route;
  final String whenLabel;
  final String host;
  final int going;

  const BikeTrip({
    required this.id,
    required this.title,
    required this.route,
    required this.whenLabel,
    required this.host,
    this.going = 1,
  });

  BikeTrip copyWith({int? going}) {
    return BikeTrip(
      id: id,
      title: title,
      route: route,
      whenLabel: whenLabel,
      host: host,
      going: going ?? this.going,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'route': route,
    'whenLabel': whenLabel,
    'host': host,
    'going': going,
  };

  factory BikeTrip.fromJson(Map<String, dynamic> json) {
    return BikeTrip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      route: json['route'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      host: json['host'] as String? ?? 'Rowerzysta',
      going: json['going'] as int? ?? 1,
    );
  }

  static List<BikeTrip> seeded() => const [
    BikeTrip(
      id: 'bt-jasien',
      title: 'Wzdłuż rzeki',
      route: 'Park nad rzeką → stawki przy osiedlu',
      whenLabel: 'Sobota 9:00',
      host: 'Klub rowerowy okolica',
      going: 6,
    ),
    BikeTrip(
      id: 'bt-lag',
      title: 'Do lasu',
      route: 'okolica → las (pętla)',
      whenLabel: 'Niedziela 8:30',
      host: 'Bartek',
      going: 4,
    ),
    BikeTrip(
      id: 'bt-stawy',
      title: 'Wokół stawów',
      route: 'Stawy Janowskie i okolice',
      whenLabel: 'Środa 18:00',
      host: 'Ania',
      going: 3,
    ),
  ];
}
