class CarpetVacOffer {
  final String id;
  final String title;
  final String whenText;
  final String place;
  final String authorName;

  const CarpetVacOffer({
    required this.id,
    required this.title,
    required this.whenText,
    required this.place,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'whenText': whenText,
    'place': place,
    'authorName': authorName,
  };

  factory CarpetVacOffer.fromJson(Map<String, dynamic> json) {
    return CarpetVacOffer(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<CarpetVacOffer> seeded() => const [
    CarpetVacOffer(
      id: 'cv-pior',
      title: 'Odkurzacz piorący Karcher — wypożyczę na klatkę',
      whenText: 'Sobota 10:00–14:00',
      place: 'osiedle wschodnie, klatka II',
      authorName: 'Marek',
    ),
    CarpetVacOffer(
      id: 'cv-dywan',
      title: 'Wspólne pranie wykładzin na klatce',
      whenText: 'Niedziela 9:00',
      place: 'okolica, suszarnia',
      authorName: 'Kasia',
    ),
  ];
}
