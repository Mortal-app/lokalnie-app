enum ParkingMarkKind { lines, disabledEnvelope }

extension ParkingMarkKindX on ParkingMarkKind {
  String get label => switch (this) {
    ParkingMarkKind.lines => 'Linie stanowisk',
    ParkingMarkKind.disabledEnvelope => 'Koperta dla osób niepełnosprawnych',
  };
}

class ParkingMarkReport {
  final String id;
  final ParkingMarkKind kind;
  final String place;
  final String note;
  final String authorName;

  const ParkingMarkReport({
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

  factory ParkingMarkReport.fromJson(Map<String, dynamic> json) {
    return ParkingMarkReport(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == ParkingMarkKind.disabledEnvelope.name
          ? ParkingMarkKind.disabledEnvelope
          : ParkingMarkKind.lines,
      place: json['place'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<ParkingMarkReport> seeded() => const [
    ParkingMarkReport(
      id: 'pm-lin',
      kind: ParkingMarkKind.lines,
      place: 'Pod blokiem, osiedle wschodnie',
      note: 'Linie wytarte — prośba o odświeżenie farby.',
      authorName: 'Kasia',
    ),
    ParkingMarkReport(
      id: 'pm-kop',
      kind: ParkingMarkKind.disabledEnvelope,
      place: 'okolica, przy klatce II',
      note: 'Koperta bez symbolu — zaplanować malowanie.',
      authorName: 'Marek',
    ),
  ];
}
