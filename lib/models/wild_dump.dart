import 'bike_station.dart';

enum WildDumpKind { rubble, tires, mixed }

extension WildDumpKindX on WildDumpKind {
  String get label => switch (this) {
    WildDumpKind.rubble => 'Odpady pobudowlane',
    WildDumpKind.tires => 'Opony',
    WildDumpKind.mixed => 'Mieszane / zieleń',
  };
}

class WildDumpReport {
  final String id;
  final WildDumpKind kind;
  final String place;
  final String note;
  final String authorName;
  final StationAlign pos;

  const WildDumpReport({
    required this.id,
    required this.kind,
    required this.place,
    required this.note,
    required this.authorName,
    required this.pos,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'place': place,
    'note': note,
    'authorName': authorName,
    'pos': pos.name,
  };

  factory WildDumpReport.fromJson(Map<String, dynamic> json) {
    return WildDumpReport(
      id: json['id'] as String? ?? '',
      kind: WildDumpKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => WildDumpKind.mixed,
      ),
      place: json['place'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<WildDumpReport> seeded() => const [
    WildDumpReport(
      id: 'wd-opony',
      kind: WildDumpKind.tires,
      place: 'Las przy Olechowie, ścieżka od Puszkina',
      note: 'Stos opon za krzakami.',
      authorName: 'Tomek',
      pos: StationAlign.topLeft,
    ),
    WildDumpReport(
      id: 'wd-gruz',
      kind: WildDumpKind.rubble,
      place: 'Zieleń przy Rokicińskiej',
      note: 'Worki z gruzem i styropian.',
      authorName: 'Kasia',
      pos: StationAlign.bottomRight,
    ),
  ];
}
