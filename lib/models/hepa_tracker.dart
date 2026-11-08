class HepaTracker {
  final String id;
  final String device;
  final String nextChange;
  final String note;
  final String authorName;

  const HepaTracker({
    required this.id,
    required this.device,
    required this.nextChange,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'device': device,
    'nextChange': nextChange,
    'note': note,
    'authorName': authorName,
  };

  factory HepaTracker.fromJson(Map<String, dynamic> json) {
    return HepaTracker(
      id: json['id'] as String? ?? '',
      device: json['device'] as String? ?? '',
      nextChange: json['nextChange'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<HepaTracker> seeded() => const [
    HepaTracker(
      id: 'hp-xiaomi',
      device: 'Oczyszczacz Xiaomi 4',
      nextChange: '15.11.2026',
      note: 'HEPA — zakup albo czyszczenie prefiltra.',
      authorName: 'Kasia',
    ),
    HepaTracker(
      id: 'hp-phil',
      device: 'Philips w salonie',
      nextChange: '01.12.2026',
      note: 'Filtr ciemny — czas na wymianę.',
      authorName: 'Tomek',
    ),
  ];
}
