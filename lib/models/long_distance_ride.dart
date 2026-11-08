enum LongHaulDest { fabryczna, kaliska, airport }

extension LongHaulDestX on LongHaulDest {
  String get label => switch (this) {
    LongHaulDest.fabryczna => 'Łódź Fabryczna',
    LongHaulDest.kaliska => 'Łódź Kaliska',
    LongHaulDest.airport => 'Lotnisko Łódź / Lodz Airport',
  };
}

class LongDistanceRide {
  final String id;
  final LongHaulDest destination;
  final String fromPlace;
  final String time;
  final int seats;
  final double fuelShare;
  final String authorName;
  final String note;

  const LongDistanceRide({
    required this.id,
    required this.destination,
    required this.fromPlace,
    required this.time,
    required this.seats,
    required this.fuelShare,
    required this.authorName,
    this.note = '',
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'destination': destination.name,
    'fromPlace': fromPlace,
    'time': time,
    'seats': seats,
    'fuelShare': fuelShare,
    'authorName': authorName,
    'note': note,
  };

  factory LongDistanceRide.fromJson(Map<String, dynamic> json) {
    return LongDistanceRide(
      id: json['id'] as String? ?? '',
      destination: LongHaulDest.values.firstWhere(
        (item) => item.name == json['destination'],
        orElse: () => LongHaulDest.fabryczna,
      ),
      fromPlace: json['fromPlace'] as String? ?? 'Widzew',
      time: json['time'] as String? ?? '6:00',
      seats: json['seats'] as int? ?? 1,
      fuelShare: (json['fuelShare'] as num?)?.toDouble() ?? 20,
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      note: json['note'] as String? ?? '',
    );
  }

  static List<LongDistanceRide> seeded() => const [
    LongDistanceRide(
      id: 'ld-fab',
      destination: LongHaulDest.fabryczna,
      fromPlace: 'Olechów',
      time: '5:40',
      seats: 2,
      fuelShare: 12,
      authorName: 'Marek',
      note: 'Pociąg IC 6:12. Dzielimy paliwo po równo.',
    ),
    LongDistanceRide(
      id: 'ld-kal',
      destination: LongHaulDest.kaliska,
      fromPlace: 'Widzew Wschód',
      time: '6:10',
      seats: 1,
      fuelShare: 10,
      authorName: 'Ola',
    ),
    LongDistanceRide(
      id: 'ld-air',
      destination: LongHaulDest.airport,
      fromPlace: 'Stary Widzew',
      time: '4:30',
      seats: 3,
      fuelShare: 25,
      authorName: 'Tomek',
      note: 'Wylot 6:55 Wizz. Bagaż w bagażniku.',
    ),
  ];
}
