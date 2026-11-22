class ParkingShareOffer {
  final String id;
  final String title;
  final String hours;
  final String place;
  final String authorName;

  const ParkingShareOffer({
    required this.id,
    required this.title,
    required this.hours,
    required this.place,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'hours': hours,
    'place': place,
    'authorName': authorName,
  };

  factory ParkingShareOffer.fromJson(Map<String, dynamic> json) {
    return ParkingShareOffer(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      hours: json['hours'] as String? ?? '8:00 - 16:00',
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static const shareTitle =
      'Udostępnię moje miejsce parkingowe w godzinach pracy (np. 8:00 - 16:00)';

  static List<ParkingShareOffer> seeded() => const [
    ParkingShareOffer(
      id: 'pk-praca',
      title: shareTitle,
      hours: '8:00 - 16:00',
      place: 'Przy bloku, osiedle wschodnie',
      authorName: 'Tomek',
    ),
    ParkingShareOffer(
      id: 'pk-olech',
      title: shareTitle,
      hours: '7:30 - 15:30',
      place: 'okolica, przy szkole podstawowej',
      authorName: 'Kasia',
    ),
  ];
}
