class CarpoolRide {
  final String id;
  final String title;
  final String fromPlace;
  final String toPlace;
  final String time;
  final int seats;
  final bool seekingSeat;
  final String authorName;
  final String subDistrict;
  final String note;

  const CarpoolRide({
    required this.id,
    required this.title,
    required this.fromPlace,
    required this.toPlace,
    required this.time,
    required this.seats,
    required this.authorName,
    required this.subDistrict,
    this.seekingSeat = false,
    this.note = '',
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'fromPlace': fromPlace,
    'toPlace': toPlace,
    'time': time,
    'seats': seats,
    'seekingSeat': seekingSeat,
    'authorName': authorName,
    'subDistrict': subDistrict,
    'note': note,
  };

  factory CarpoolRide.fromJson(Map<String, dynamic> json) {
    return CarpoolRide(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      fromPlace: json['fromPlace'] as String? ?? '',
      toPlace: json['toPlace'] as String? ?? '',
      time: json['time'] as String? ?? '7:30',
      seats: json['seats'] as int? ?? 1,
      seekingSeat: json['seekingSeat'] as bool? ?? false,
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Twoja okolica',
      note: json['note'] as String? ?? '',
    );
  }

  static List<CarpoolRide> seeded() => const [
    CarpoolRide(
      id: 'ride-olechow',
      title: 'Codzienny dojazd do centrum miasta z okolicy o 7:30',
      fromPlace: 'Twoja okolica',
      toPlace: 'Centrum Łodzi',
      time: '7:30',
      seats: 2,
      authorName: 'Sąsiadka',
      subDistrict: 'Twoja okolica',
      note: 'Poniedziałek–piątek, parking przy galerii.',
    ),
    CarpoolRide(
      id: 'ride-seat',
      title: 'Szukam kogoś na wolne miejsce w aucie',
      fromPlace: 'Twoja okolica',
      toPlace: 'Manufaktura / Śródmieście',
      time: '8:00',
      seats: 1,
      seekingSeat: true,
      authorName: 'Sąsiad',
      subDistrict: 'Twoja okolica',
      note: 'Mogę dołożyć się do paliwa.',
    ),
  ];
}
