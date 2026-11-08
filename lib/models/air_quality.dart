import 'bike_station.dart';

class AirSensorReading {
  final String id;
  final String name;
  final String place;
  final double pm25;
  final double pm10;
  final StationAlign pos;

  const AirSensorReading({
    required this.id,
    required this.name,
    required this.place,
    required this.pm25,
    required this.pm10,
    required this.pos,
  });

  bool get alert => pm25 > 25 || pm10 > 50;

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'place': place,
    'pm25': pm25,
    'pm10': pm10,
    'pos': pos.name,
  };

  factory AirSensorReading.fromJson(Map<String, dynamic> json) {
    return AirSensorReading(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      place: json['place'] as String? ?? 'Widzew',
      pm25: (json['pm25'] as num?)?.toDouble() ?? 0,
      pm10: (json['pm10'] as num?)?.toDouble() ?? 0,
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<AirSensorReading> seeded() => const [
    AirSensorReading(
      id: 'aq-wschod',
      name: 'Czujnik Widzew Wschód',
      place: 'al. Piłsudskiego',
      pm25: 18,
      pm10: 32,
      pos: StationAlign.topLeft,
    ),
    AirSensorReading(
      id: 'aq-olech',
      name: 'Czujnik Olechów',
      place: 'Przy SP 141',
      pm25: 31,
      pm10: 58,
      pos: StationAlign.bottomRight,
    ),
  ];
}
