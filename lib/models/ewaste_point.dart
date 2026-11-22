import 'bike_station.dart';

enum EwasteKind { battery, electro, smallAgd }

extension EwasteKindX on EwasteKind {
  String get label => switch (this) {
    EwasteKind.battery => 'Baterie',
    EwasteKind.electro => 'Elektroodpady',
    EwasteKind.smallAgd => 'Małe AGD',
  };
}

class EwastePoint {
  final String id;
  final EwasteKind kind;
  final String name;
  final String place;
  final StationAlign pos;

  const EwastePoint({
    required this.id,
    required this.kind,
    required this.name,
    required this.place,
    required this.pos,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'name': name,
    'place': place,
    'pos': pos.name,
  };

  factory EwastePoint.fromJson(Map<String, dynamic> json) {
    return EwastePoint(
      id: json['id'] as String? ?? '',
      kind: EwasteKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => EwasteKind.battery,
      ),
      name: json['name'] as String? ?? '',
      place: json['place'] as String? ?? '',
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<EwastePoint> seeded() => const [
    EwastePoint(
      id: 'ew-bat',
      kind: EwasteKind.battery,
      name: 'Kosz na baterie — market',
      place: 'Przy kasach, osiedle wschodnie',
      pos: StationAlign.topLeft,
    ),
    EwastePoint(
      id: 'ew-agd',
      kind: EwasteKind.smallAgd,
      name: 'Punkt spółdzielni — małe AGD',
      place: 'Administracja okolica',
      pos: StationAlign.bottomRight,
    ),
  ];
}
