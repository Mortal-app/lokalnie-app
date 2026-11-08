enum WaterFilterKind { pitcher, reverseOsmosis }

extension WaterFilterKindX on WaterFilterKind {
  String get label => switch (this) {
    WaterFilterKind.pitcher => 'Dzbanek filtrujący',
    WaterFilterKind.reverseOsmosis => 'RO pod zlewem',
  };
}

class WaterFilterReminder {
  final String id;
  final WaterFilterKind kind;
  final String nextChange;
  final String note;
  final String authorName;

  const WaterFilterReminder({
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

  factory WaterFilterReminder.fromJson(Map<String, dynamic> json) {
    return WaterFilterReminder(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == WaterFilterKind.reverseOsmosis.name
          ? WaterFilterKind.reverseOsmosis
          : WaterFilterKind.pitcher,
      nextChange: json['nextChange'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<WaterFilterReminder> seeded() => const [
    WaterFilterReminder(
      id: 'wf-dzb',
      kind: WaterFilterKind.pitcher,
      nextChange: '08.11.2026',
      note: 'Wkład do dzbanka — wymiana co 4 tygodnie.',
      authorName: 'Ewa',
    ),
    WaterFilterReminder(
      id: 'wf-ro',
      kind: WaterFilterKind.reverseOsmosis,
      nextChange: '01.12.2026',
      note: 'Membrana RO pod zlewem — zamów wkład z wyprzedzeniem.',
      authorName: 'Tomek',
    ),
  ];
}
