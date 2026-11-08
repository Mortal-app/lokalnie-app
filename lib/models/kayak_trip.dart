class KayakTrip {
  final String id;
  final String title;
  final String river;
  final String whenText;
  final String seats;
  final String gearShare;
  final String authorName;

  const KayakTrip({
    required this.id,
    required this.title,
    required this.river,
    required this.whenText,
    required this.seats,
    required this.gearShare,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'river': river,
    'whenText': whenText,
    'seats': seats,
    'gearShare': gearShare,
    'authorName': authorName,
  };

  factory KayakTrip.fromJson(Map<String, dynamic> json) {
    return KayakTrip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      river: json['river'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      seats: json['seats'] as String? ?? '',
      gearShare: json['gearShare'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sternik',
    );
  }

  static List<KayakTrip> seeded() => const [
    KayakTrip(
      id: 'kt-pil',
      title: 'Weekendowy spływ — Pilica',
      river: 'Pilica',
      whenText: 'Sobota 7:00',
      seats: '3 miejsca w aucie z pętli',
      gearShare: 'Kajaki wypożyczamy — dzielimy kaucję',
      authorName: 'Tomek',
    ),
    KayakTrip(
      id: 'kt-war',
      title: 'Warta — odcinek pod Łodzią',
      river: 'Warta',
      whenText: 'Niedziela 6:30',
      seats: '2 miejsca',
      gearShare: 'Kamizelki mam, kajak do zrzutki',
      authorName: 'Basia',
    ),
  ];
}
