class PlantHotelStay {
  final String id;
  final String plantName;
  final String whenText;
  final String note;
  final String authorName;
  final bool seekingHost;

  const PlantHotelStay({
    required this.id,
    required this.plantName,
    required this.whenText,
    required this.note,
    required this.authorName,
    this.seekingHost = true,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'plantName': plantName,
    'whenText': whenText,
    'note': note,
    'authorName': authorName,
    'seekingHost': seekingHost,
  };

  factory PlantHotelStay.fromJson(Map<String, dynamic> json) {
    return PlantHotelStay(
      id: json['id'] as String? ?? '',
      plantName: json['plantName'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      seekingHost: json['seekingHost'] as bool? ?? true,
    );
  }

  static List<PlantHotelStay> seeded() => const [
    PlantHotelStay(
      id: 'ph-monst',
      plantName: 'Monstera i dwa storczyki',
      whenText: '12–20 listopada',
      note: 'Urlop — podlewanie raz na 5 dni, jasny parapet.',
      authorName: 'Kasia',
    ),
    PlantHotelStay(
      id: 'ph-host',
      plantName: 'Przyjmę kwiaty na urlop sąsiada',
      whenText: 'Listopad–grudzień',
      note: 'Mam miejsce przy oknie na południe, klatka II.',
      authorName: 'Pani Ewa',
      seekingHost: false,
    ),
  ];
}
