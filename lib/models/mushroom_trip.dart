class MushroomTrip {
  final String id;
  final String title;
  final String whenText;
  final String meetingPoint;
  final String forest;
  final String authorName;

  const MushroomTrip({
    required this.id,
    required this.title,
    required this.whenText,
    required this.meetingPoint,
    required this.forest,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'whenText': whenText,
    'meetingPoint': meetingPoint,
    'forest': forest,
    'authorName': authorName,
  };

  factory MushroomTrip.fromJson(Map<String, dynamic> json) {
    return MushroomTrip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      meetingPoint: json['meetingPoint'] as String? ?? '',
      forest: json['forest'] as String? ?? 'Las okolicy',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<MushroomTrip> seeded() => const [
    MushroomTrip(
      id: 'mt-lag',
      title: 'Grzybobranie w lesie',
      whenText: 'Sobota, zbiórka 7:30',
      meetingPoint: 'Pętla tramwajowa osiedle wschodnie',
      forest: 'Las okolicy',
      authorName: 'Basia',
    ),
    MushroomTrip(
      id: 'mt-spacer',
      title: 'Spacer leśny (bez koszy — tylko zdjęcia)',
      whenText: 'Niedziela 10:00',
      meetingPoint: 'Parking przy Arturówku',
      forest: 'Kompleks leśny',
      authorName: 'Piotr',
    ),
  ];
}
