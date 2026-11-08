class CarOilReminder {
  final String id;
  final String plateHint;
  final String mileage;
  final String nextService;
  final String authorName;

  const CarOilReminder({
    required this.id,
    required this.plateHint,
    required this.mileage,
    required this.nextService,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'plateHint': plateHint,
    'mileage': mileage,
    'nextService': nextService,
    'authorName': authorName,
  };

  factory CarOilReminder.fromJson(Map<String, dynamic> json) {
    return CarOilReminder(
      id: json['id'] as String? ?? '',
      plateHint: json['plateHint'] as String? ?? '',
      mileage: json['mileage'] as String? ?? '',
      nextService: json['nextService'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Kierowca',
    );
  }

  static List<CarOilReminder> seeded() => const [
    CarOilReminder(
      id: 'co-1',
      plateHint: 'EL ••• 21 (pod blokiem)',
      mileage: '148 200 km',
      nextService: 'Olej i filtr do 150 000 km / 12.11.2026',
      authorName: 'Tomek',
    ),
    CarOilReminder(
      id: 'co-2',
      plateHint: 'EL ••• 08',
      mileage: '97 400 km',
      nextService: 'Wymiana oleju za 600 km',
      authorName: 'Kasia',
    ),
  ];
}
