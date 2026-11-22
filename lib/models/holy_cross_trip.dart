class HolyCrossTrip {
  final String id;
  final String title;
  final String whenText;
  final String meetingPoint;
  final String seats;
  final String authorName;

  const HolyCrossTrip({
    required this.id,
    required this.title,
    required this.whenText,
    required this.meetingPoint,
    required this.seats,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'whenText': whenText,
    'meetingPoint': meetingPoint,
    'seats': seats,
    'authorName': authorName,
  };

  factory HolyCrossTrip.fromJson(Map<String, dynamic> json) {
    return HolyCrossTrip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      meetingPoint: json['meetingPoint'] as String? ?? '',
      seats: json['seats'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Kierowca',
    );
  }

  static List<HolyCrossTrip> seeded() => const [
    HolyCrossTrip(
      id: 'hc-lys',
      title: 'Weekend: Łysica i Święty Krzyż',
      whenText: 'Sobota 6:00',
      meetingPoint: 'Pętla osiedlowa',
      seats: '3 miejsca — piesze wędrówki, plecak',
      authorName: 'Tomek',
    ),
    HolyCrossTrip(
      id: 'hc-nida',
      title: 'Góry Świętokrzyskie — pętla wokół Nowej Słupi',
      whenText: 'Niedziela 5:30',
      meetingPoint: 'okolica, przy pawilonie',
      seats: '2 miejsca, dzielimy paliwo',
      authorName: 'Basia',
    ),
  ];
}
