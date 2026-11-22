import 'bike_station.dart';

class FarmStall {
  final String id;
  final String name;
  final String whenText;
  final String place;
  final StationAlign pos;

  const FarmStall({
    required this.id,
    required this.name,
    required this.whenText,
    required this.place,
    required this.pos,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'whenText': whenText,
    'place': place,
    'pos': pos.name,
  };

  factory FarmStall.fromJson(Map<String, dynamic> json) {
    return FarmStall(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      whenText: json['whenText'] as String? ?? '',
      place: json['place'] as String? ?? '',
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<FarmStall> seeded() => const [
    FarmStall(
      id: 'fs-baz',
      name: 'Bazarek przy pętli',
      whenText: 'Wtorek i piątek 7:00–12:00',
      place: 'osiedle wschodnie — warzywa od rolnika',
      pos: StationAlign.topLeft,
    ),
    FarmStall(
      id: 'fs-bus',
      name: 'Mobilny punkt — bus z owocami',
      whenText: 'Sobota 8:00–11:00',
      place: 'okolica, przy szkole',
      pos: StationAlign.bottomRight,
    ),
  ];
}
