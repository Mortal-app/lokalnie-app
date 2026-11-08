import 'bike_station.dart';

enum SodaCylinder { pink, blue }

extension SodaCylinderX on SodaCylinder {
  String get label => switch (this) {
    SodaCylinder.pink => 'Różowy cylinder',
    SodaCylinder.blue => 'Niebieski cylinder',
  };
}

class SodaCo2Spot {
  final String id;
  final String name;
  final String place;
  final SodaCylinder cylinder;
  final StationAlign pos;

  const SodaCo2Spot({
    required this.id,
    required this.name,
    required this.place,
    required this.cylinder,
    required this.pos,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'place': place,
    'cylinder': cylinder.name,
    'pos': pos.name,
  };

  factory SodaCo2Spot.fromJson(Map<String, dynamic> json) {
    return SodaCo2Spot(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      place: json['place'] as String? ?? '',
      cylinder: json['cylinder'] == SodaCylinder.blue.name
          ? SodaCylinder.blue
          : SodaCylinder.pink,
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<SodaCo2Spot> seeded() => const [
    SodaCo2Spot(
      id: 'sc-paw',
      name: 'Wymiana SodaStream — pawilon',
      place: 'Widzew Wschód, sklep spożywczy',
      cylinder: SodaCylinder.pink,
      pos: StationAlign.topLeft,
    ),
    SodaCo2Spot(
      id: 'sc-ole',
      name: 'Nabijanie CO2 — saturatory',
      place: 'Olechów, punkt wymiany cylindrów',
      cylinder: SodaCylinder.blue,
      pos: StationAlign.bottomRight,
    ),
  ];
}
