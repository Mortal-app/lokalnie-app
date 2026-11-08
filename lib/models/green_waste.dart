class GreenWastePickup {
  final String id;
  final String place;
  final String whenText;
  final String volume;
  final String authorName;

  const GreenWastePickup({
    required this.id,
    required this.place,
    required this.whenText,
    required this.volume,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'place': place,
    'whenText': whenText,
    'volume': volume,
    'authorName': authorName,
  };

  factory GreenWastePickup.fromJson(Map<String, dynamic> json) {
    return GreenWastePickup(
      id: json['id'] as String? ?? '',
      place: json['place'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      volume: json['volume'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<GreenWastePickup> seeded() => const [
    GreenWastePickup(
      id: 'gw-dzialka',
      place: 'Działki przy Rokicińskiej',
      whenText: 'Sobota rano',
      volume: 'Gałęzie po cięciu krzewów — 3 worki',
      authorName: 'Pan Leszek',
    ),
    GreenWastePickup(
      id: 'gw-blok',
      place: 'Zieleń przy klatce I, Olechów',
      whenText: 'Niedziela 9:00',
      volume: 'Gałęzie z przycinki drzewek',
      authorName: 'Zarząd klatki',
    ),
  ];
}
