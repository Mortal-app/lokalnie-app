enum SmokeKind { smoke, carbonMonoxide }

extension SmokeKindX on SmokeKind {
  String get label => switch (this) {
    SmokeKind.smoke => 'Czujnik dymu',
    SmokeKind.carbonMonoxide => 'Czujnik czadu',
  };
}

class SmokeAlarmReminder {
  final String id;
  final SmokeKind kind;
  final String nextChange;
  final String note;
  final String authorName;

  const SmokeAlarmReminder({
    required this.id,
    required this.kind,
    required this.nextChange,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'nextChange': nextChange,
    'note': note,
    'authorName': authorName,
  };

  factory SmokeAlarmReminder.fromJson(Map<String, dynamic> json) {
    return SmokeAlarmReminder(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == SmokeKind.carbonMonoxide.name
          ? SmokeKind.carbonMonoxide
          : SmokeKind.smoke,
      nextChange: json['nextChange'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<SmokeAlarmReminder> seeded() => const [
    SmokeAlarmReminder(
      id: 'sa-dym',
      kind: SmokeKind.smoke,
      nextChange: '01.11.2026',
      note: 'Bateria 9V w czujniku na korytarzu — test przyciskiem.',
      authorName: 'Ewa',
    ),
    SmokeAlarmReminder(
      id: 'sa-co',
      kind: SmokeKind.carbonMonoxide,
      nextChange: '15.11.2026',
      note: 'Czujnik czadu przy piecyku — wymiana zasilania i kontrola.',
      authorName: 'Tomek',
    ),
  ];
}
