import 'bike_station.dart';

enum ShelterKind { insectHotel, birdBox }

extension ShelterKindX on ShelterKind {
  String get label => switch (this) {
    ShelterKind.insectHotel => 'Domek dla owadów',
    ShelterKind.birdBox => 'Budka lęgowa',
  };
}

class WildlifeShelter {
  final String id;
  final ShelterKind kind;
  final String place;
  final String note;
  final String authorName;
  final StationAlign pos;

  const WildlifeShelter({
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

  factory WildlifeShelter.fromJson(Map<String, dynamic> json) {
    return WildlifeShelter(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == ShelterKind.birdBox.name
          ? ShelterKind.birdBox
          : ShelterKind.insectHotel,
      place: json['place'] as String? ?? '',
      note: json['note'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<WildlifeShelter> seeded() => const [
    WildlifeShelter(
      id: 'ws-park',
      kind: ShelterKind.insectHotel,
      place: 'Park przy okolicy',
      note: 'Hotel dla pszczół murarek przy żywopłocie.',
      authorName: 'Eko-patrol',
      pos: StationAlign.topLeft,
    ),
    WildlifeShelter(
      id: 'ws-olech',
      kind: ShelterKind.birdBox,
      place: 'Zieleń przy osiedlu',
      note: 'Budka dla sikorek, 3 m nad ziemią.',
      authorName: 'Pani Krysia',
      pos: StationAlign.bottomRight,
    ),
  ];
}
