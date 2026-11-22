class SudetyTrip {
  final String id;
  final String title;
  final String whenText;
  final String meetingPoint;
  final String seats;
  final String fuelShare;
  final String authorName;

  const SudetyTrip({
    required this.id,
    required this.title,
    required this.whenText,
    required this.meetingPoint,
    required this.seats,
    required this.fuelShare,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'whenText': whenText,
    'meetingPoint': meetingPoint,
    'seats': seats,
    'fuelShare': fuelShare,
    'authorName': authorName,
  };

  factory SudetyTrip.fromJson(Map<String, dynamic> json) {
    return SudetyTrip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      meetingPoint: json['meetingPoint'] as String? ?? '',
      seats: json['seats'] as String? ?? '',
      fuelShare: json['fuelShare'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Kierowca',
    );
  }

  static List<SudetyTrip> seeded() => const [
    SudetyTrip(
      id: 'su-karp',
      title: 'Karkonosze — Karpacz / Śnieżka',
      whenText: 'Sobota 5:00',
      meetingPoint: 'Pętla osiedlowa',
      seats: '3 miejsca',
      fuelShare: 'Paliwo na 4 osoby, autostrada A1/A4',
      authorName: 'Tomek',
    ),
    SudetyTrip(
      id: 'su-sud',
      title: 'Sudety — pętla wokół Szklarskiej',
      whenText: 'Niedziela 4:45',
      meetingPoint: 'okolica, pawilon',
      seats: '2 miejsca, plecak i kijki',
      fuelShare: 'Dzielimy tankowanie w Łodzi',
      authorName: 'Basia',
    ),
  ];
}
