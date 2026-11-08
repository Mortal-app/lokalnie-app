import 'bike_station.dart';

enum ClothesBinIssue { full, damaged, ok }

extension ClothesBinIssueX on ClothesBinIssue {
  String get label => switch (this) {
    ClothesBinIssue.full => 'Zapełniony',
    ClothesBinIssue.damaged => 'Uszkodzony',
    ClothesBinIssue.ok => 'OK',
  };
}

class ClothesBinSpot {
  final String id;
  final String name;
  final String place;
  final ClothesBinIssue issue;
  final StationAlign pos;

  const ClothesBinSpot({
    required this.id,
    required this.name,
    required this.place,
    required this.issue,
    required this.pos,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'place': place,
    'issue': issue.name,
    'pos': pos.name,
  };

  ClothesBinSpot copyWith({ClothesBinIssue? issue}) => ClothesBinSpot(
    id: id,
    name: name,
    place: place,
    issue: issue ?? this.issue,
    pos: pos,
  );

  factory ClothesBinSpot.fromJson(Map<String, dynamic> json) {
    return ClothesBinSpot(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      place: json['place'] as String? ?? '',
      issue: ClothesBinIssue.values.firstWhere(
        (item) => item.name == json['issue'],
        orElse: () => ClothesBinIssue.ok,
      ),
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<ClothesBinSpot> seeded() => const [
    ClothesBinSpot(
      id: 'cb-pck',
      name: 'Kontener PCK',
      place: 'Widzew Wschód, przy śmietniku',
      issue: ClothesBinIssue.ok,
      pos: StationAlign.topLeft,
    ),
    ClothesBinSpot(
      id: 'cb-pec',
      name: 'Kontener Pecet / odzież używana',
      place: 'Olechów, przy pawilonie',
      issue: ClothesBinIssue.full,
      pos: StationAlign.bottomRight,
    ),
  ];
}
