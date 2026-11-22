enum StairCleanKind { windows, staircase, common }

extension StairCleanKindX on StairCleanKind {
  String get label => switch (this) {
    StairCleanKind.windows => 'Mycie okien na klatce',
    StairCleanKind.staircase => 'Mycie klatki',
    StairCleanKind.common => 'Wspólna przestrzeń',
  };
}

class StairCleanSlot {
  final String id;
  final StairCleanKind kind;
  final String whenText;
  final String place;
  final String authorName;

  const StairCleanSlot({
    required this.id,
    required this.kind,
    required this.whenText,
    required this.place,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'whenText': whenText,
    'place': place,
    'authorName': authorName,
  };

  factory StairCleanSlot.fromJson(Map<String, dynamic> json) {
    return StairCleanSlot(
      id: json['id'] as String? ?? '',
      kind: StairCleanKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => StairCleanKind.staircase,
      ),
      whenText: json['whenText'] as String? ?? '',
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<StairCleanSlot> seeded() => const [
    StairCleanSlot(
      id: 'sc-okna',
      kind: StairCleanKind.windows,
      whenText: 'Sobota 9:00',
      place: 'Klatka II, osiedle wschodnie',
      authorName: 'Pani Ewa',
    ),
    StairCleanSlot(
      id: 'sc-klatka',
      kind: StairCleanKind.staircase,
      whenText: 'Niedziela 10:00',
      place: 'okolica, klatka I',
      authorName: 'Marek',
    ),
  ];
}
