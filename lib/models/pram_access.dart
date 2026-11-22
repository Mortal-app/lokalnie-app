import 'bike_station.dart';

class PramAccessSpot {
  final String id;
  final String name;
  final String note;
  final String place;
  final StationAlign pos;

  const PramAccessSpot({
    required this.id,
    required this.name,
    required this.note,
    required this.place,
    required this.pos,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'place': place,
    'note': note,
    'pos': pos.name,
  };

  factory PramAccessSpot.fromJson(Map<String, dynamic> json) {
    return PramAccessSpot(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      note: json['note'] as String? ?? '',
      place: json['place'] as String? ?? '',
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<PramAccessSpot> seeded() => const [
    PramAccessSpot(
      id: 'pa-usc',
      name: 'Urząd — winda bez barier',
      place: 'Budynek użyteczności publicznej, okolica',
      note: 'Podjazd od ulicy, winda do 2. piętra, miejsce na wózek.',
      pos: StationAlign.topLeft,
    ),
    PramAccessSpot(
      id: 'pa-klin',
      name: 'Przychodnia — wejście z podjazdem',
      place: 'Okolica',
      note: 'Szerokie drzwi, winda, stojak na wózki przy recepcji.',
      pos: StationAlign.bottomRight,
    ),
  ];
}
