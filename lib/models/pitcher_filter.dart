class PitcherFilterLog {
  final String id;
  final String brand;
  final int daysSinceChange;
  final String note;
  final String authorName;

  const PitcherFilterLog({
    required this.id,
    required this.brand,
    required this.daysSinceChange,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'brand': brand,
    'daysSinceChange': daysSinceChange,
    'note': note,
    'authorName': authorName,
  };

  factory PitcherFilterLog.fromJson(Map<String, dynamic> json) {
    return PitcherFilterLog(
      id: json['id'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      daysSinceChange: json['daysSinceChange'] as int? ?? 0,
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<PitcherFilterLog> seeded() => const [
    PitcherFilterLog(
      id: 'pf-dzb',
      brand: 'Dzbanek filtrujący — kuchnia',
      daysSinceChange: 18,
      note: 'Wkład do wody pitnej — wymiana co 28 dni.',
      authorName: 'Ewa',
    ),
  ];
}
