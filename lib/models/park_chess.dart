class ParkChessMeetup {
  final String id;
  final String title;
  final String whenText;
  final String tablePlace;
  final String authorName;

  const ParkChessMeetup({
    required this.id,
    required this.title,
    required this.whenText,
    required this.tablePlace,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'whenText': whenText,
    'tablePlace': tablePlace,
    'authorName': authorName,
  };

  factory ParkChessMeetup.fromJson(Map<String, dynamic> json) {
    return ParkChessMeetup(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      tablePlace: json['tablePlace'] as String? ?? 'Park, Widzew Wschód',
      authorName: json['authorName'] as String? ?? 'Gracz',
    );
  }

  static List<ParkChessMeetup> seeded() => const [
    ParkChessMeetup(
      id: 'pc-sob',
      title: 'Partia pod chmurką — blitz 5+3',
      whenText: 'Sobota 10:00',
      tablePlace: 'Stoliki parkowe, Widzew Wschód',
      authorName: 'Marek',
    ),
    ParkChessMeetup(
      id: 'pc-nd',
      title: 'Szukam sparingpartnera, poziom klubowy',
      whenText: 'Niedziela 16:00',
      tablePlace: 'Ławka przy szachownicy, park Wschód',
      authorName: 'Ania',
    ),
  ];
}
