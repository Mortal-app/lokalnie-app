class ThermalTrip {
  final String id;
  final String title;
  final String place;
  final String whenText;
  final String seats;
  final String costShare;
  final String authorName;

  const ThermalTrip({
    required this.id,
    required this.title,
    required this.place,
    required this.whenText,
    required this.seats,
    required this.costShare,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'place': place,
    'whenText': whenText,
    'seats': seats,
    'costShare': costShare,
    'authorName': authorName,
  };

  factory ThermalTrip.fromJson(Map<String, dynamic> json) {
    return ThermalTrip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      seats: json['seats'] as String? ?? '',
      costShare: json['costShare'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Kierowca',
    );
  }

  static List<ThermalTrip> seeded() => const [
    ThermalTrip(
      id: 'th-uni',
      title: 'Weekend — termy Uniejów',
      place: 'Uniejów',
      whenText: 'Sobota 7:30',
      seats: '3 miejsca z pętli okolica',
      costShare: 'Paliwo na 4 osoby',
      authorName: 'Tomek',
    ),
    ThermalTrip(
      id: 'th-msz',
      title: 'Mszczonów — baseny termalne',
      place: 'Mszczonów',
      whenText: 'Niedziela 8:00',
      seats: '2 miejsca',
      costShare: 'Dzielimy bilet parkingowy',
      authorName: 'Basia',
    ),
  ];
}
