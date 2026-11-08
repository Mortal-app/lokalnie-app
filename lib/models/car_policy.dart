class CarPolicyReminder {
  final String id;
  final String plateHint;
  final String ocAcUntil;
  final String reviewUntil;
  final String authorName;

  const CarPolicyReminder({
    required this.id,
    required this.plateHint,
    required this.ocAcUntil,
    required this.reviewUntil,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'plateHint': plateHint,
    'ocAcUntil': ocAcUntil,
    'reviewUntil': reviewUntil,
    'authorName': authorName,
  };

  factory CarPolicyReminder.fromJson(Map<String, dynamic> json) {
    return CarPolicyReminder(
      id: json['id'] as String? ?? '',
      plateHint: json['plateHint'] as String? ?? '',
      ocAcUntil: json['ocAcUntil'] as String? ?? '',
      reviewUntil: json['reviewUntil'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Kierowca',
    );
  }

  static List<CarPolicyReminder> seeded() => const [
    CarPolicyReminder(
      id: 'cp-oc',
      plateHint: 'EL ••• 12 (pod blokiem)',
      ocAcUntil: 'OC/AC do 12.12.2026',
      reviewUntil: 'Przegląd do 03.03.2027',
      authorName: 'Tomek',
    ),
    CarPolicyReminder(
      id: 'cp-rev',
      plateHint: 'EL ••• 44',
      ocAcUntil: 'OC do 20.01.2027',
      reviewUntil: 'Przegląd rejestracyjny 15.11.2026',
      authorName: 'Kasia',
    ),
  ];
}
