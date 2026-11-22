enum ParcelLockerStatus { free, occupied }

extension ParcelLockerStatusX on ParcelLockerStatus {
  String get label => switch (this) {
    ParcelLockerStatus.free => 'Miejsca wolne',
    ParcelLockerStatus.occupied => 'Zajęte',
  };
}

class ParcelLocker {
  final String id;
  final String title;
  final String hostName;
  final String place;
  final String hours;
  final String note;
  final String subDistrict;
  final int slots;
  final int occupied;

  const ParcelLocker({
    required this.id,
    required this.title,
    required this.hostName,
    required this.place,
    required this.hours,
    required this.subDistrict,
    this.note = '',
    this.slots = 2,
    this.occupied = 0,
  });

  ParcelLockerStatus get status =>
      occupied >= slots ? ParcelLockerStatus.occupied : ParcelLockerStatus.free;

  int get freeSlots => (slots - occupied).clamp(0, slots);

  ParcelLocker copyWith({int? occupied, int? slots}) {
    return ParcelLocker(
      id: id,
      title: title,
      hostName: hostName,
      place: place,
      hours: hours,
      note: note,
      subDistrict: subDistrict,
      slots: slots ?? this.slots,
      occupied: occupied ?? this.occupied,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'hostName': hostName,
    'place': place,
    'hours': hours,
    'note': note,
    'subDistrict': subDistrict,
    'slots': slots,
    'occupied': occupied,
  };

  factory ParcelLocker.fromJson(Map<String, dynamic> json) {
    return ParcelLocker(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      hostName: json['hostName'] as String? ?? 'Sąsiad',
      place: json['place'] as String? ?? '',
      hours: json['hours'] as String? ?? '',
      note: json['note'] as String? ?? '',
      subDistrict: json['subDistrict'] as String? ?? 'Twoja okolica',
      slots: json['slots'] as int? ?? 2,
      occupied: json['occupied'] as int? ?? 0,
    );
  }

  static List<ParcelLocker> seeded() => [
    const ParcelLocker(
      id: 'locker-maria',
      title: 'Przechowalnia u Pani Marii',
      hostName: 'Pani Maria',
      place: 'klatka III, parter, dzwonek „Maria”',
      hours: '8:00–20:00, poza niedzielą',
      subDistrict: 'Twoja okolica',
      note: 'Paczki kurierskie do 10 kg, odbiór tego samego dnia.',
      slots: 3,
      occupied: 1,
    ),
    const ParcelLocker(
      id: 'locker-janow',
      title: 'Punkt u sąsiada z okolicy',
      hostName: 'Sąsiad',
      place: 'ul. Szkolnej, po pracy',
      hours: '17:00–21:00',
      subDistrict: 'Twoja okolica',
      note: 'Tymczasowe przechowanie, gdy nikogo nie ma w domu.',
      slots: 2,
      occupied: 2,
    ),
  ];
}
