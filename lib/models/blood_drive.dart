class BloodDrive {
  final String id;
  final String place;
  final String whenLabel;
  final String hours;
  final bool urgent;
  final String note;

  const BloodDrive({
    required this.id,
    required this.place,
    required this.whenLabel,
    required this.hours,
    this.urgent = false,
    this.note = '',
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'place': place,
    'whenLabel': whenLabel,
    'hours': hours,
    'urgent': urgent,
    'note': note,
  };

  factory BloodDrive.fromJson(Map<String, dynamic> json) {
    return BloodDrive(
      id: json['id'] as String? ?? '',
      place: json['place'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      hours: json['hours'] as String? ?? '',
      urgent: json['urgent'] as bool? ?? false,
      note: json['note'] as String? ?? '',
    );
  }

  static List<BloodDrive> seeded() => const [
    BloodDrive(
      id: 'blood-pt',
      place: 'Parking CH Ptak / al. Piłsudskiego',
      whenLabel: 'Piątek 31.10',
      hours: '10:00–16:00',
      note: 'Krwiobus RCKiK, grupa 0 Rh− mile widziana.',
    ),
    BloodDrive(
      id: 'blood-manu',
      place: 'Manufaktura — zjazd od Widzewa (punkt mobilny)',
      whenLabel: 'Środa 5.11',
      hours: '9:00–15:00',
    ),
    BloodDrive(
      id: 'blood-urgent',
      place: 'Pilne zapotrzebowanie — stacja Łódź-Widzew',
      whenLabel: 'Dziś–jutro',
      hours: '7:00–18:00',
      urgent: true,
      note: 'Brakuje płytek i grupy A Rh−. Honorowi dawcy z Widzewa — prosimy o kontakt.',
    ),
  ];
}
