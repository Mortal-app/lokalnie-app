import 'bike_station.dart';

class ScooterHub {
  final String id;
  final String name;
  final String place;
  final String operatorName;
  final StationAlign pos;

  const ScooterHub({
    required this.id,
    required this.name,
    required this.place,
    required this.operatorName,
    required this.pos,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'place': place,
    'operatorName': operatorName,
    'pos': pos.name,
  };

  factory ScooterHub.fromJson(Map<String, dynamic> json) {
    return ScooterHub(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      place: json['place'] as String? ?? '',
      operatorName: json['operatorName'] as String? ?? 'Hulajnoga',
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<ScooterHub> seeded() => const [
    ScooterHub(
      id: 'sh-petla',
      name: 'Strefa przy pętli',
      place: 'osiedle wschodnie — pętla tramwajowa',
      operatorName: 'Hulajnogi miejskie',
      pos: StationAlign.topLeft,
    ),
    ScooterHub(
      id: 'sh-olech',
      name: 'Parking przy SP',
      place: 'okolica, przy szkole',
      operatorName: 'Najczęściej 4–8 sztuk wieczorem',
      pos: StationAlign.bottomRight,
    ),
  ];
}
