enum FireHazardKind { blockedExit, basementClutter }

extension FireHazardKindX on FireHazardKind {
  String get label => switch (this) {
    FireHazardKind.blockedExit => 'Zablokowane wyjście ewakuacyjne',
    FireHazardKind.basementClutter => 'Zagracony korytarz piwniczny',
  };
}

class FireSafetyReport {
  final String id;
  final FireHazardKind kind;
  final String place;
  final String note;
  final String authorName;

  const FireSafetyReport({
    required this.id,
    required this.kind,
    required this.place,
    required this.note,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'place': place,
    'note': note,
    'authorName': authorName,
  };

  factory FireSafetyReport.fromJson(Map<String, dynamic> json) {
    return FireSafetyReport(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == FireHazardKind.basementClutter.name
          ? FireHazardKind.basementClutter
          : FireHazardKind.blockedExit,
      place: json['place'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<FireSafetyReport> seeded() => const [
    FireSafetyReport(
      id: 'fs-wyjscie',
      kind: FireHazardKind.blockedExit,
      place: 'Klatka II, osiedle wschodnie — parter',
      note: 'Rowery przy drzwiach ewakuacyjnych — proszę o interwencję.',
      authorName: 'Pan Marek',
    ),
  ];

  static const tips = [
    'Nie zastawiaj klatek i piwnic — to droga ewakuacji.',
    'Czujnik dymu w mieszkaniu: test raz w miesiącu.',
    'Gaśnica ABC na klatce — znać lokalizację.',
    'W razie dymu: schody, nie winda.',
  ];
}
