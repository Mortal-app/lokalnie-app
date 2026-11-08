enum StationAlign { topLeft, center, bottomRight }

class BikeRepairStation {
  final String id;
  final String name;
  final String place;
  final bool toolsOk;
  final bool pumpOk;
  final StationAlign pos;

  const BikeRepairStation({
    required this.id,
    required this.name,
    required this.place,
    required this.toolsOk,
    required this.pumpOk,
    required this.pos,
  });

  BikeRepairStation copyWith({bool? toolsOk, bool? pumpOk}) {
    return BikeRepairStation(
      id: id,
      name: name,
      place: place,
      toolsOk: toolsOk ?? this.toolsOk,
      pumpOk: pumpOk ?? this.pumpOk,
      pos: pos,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'place': place,
    'toolsOk': toolsOk,
    'pumpOk': pumpOk,
    'pos': pos.name,
  };

  factory BikeRepairStation.fromJson(Map<String, dynamic> json) {
    return BikeRepairStation(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      place: json['place'] as String? ?? 'Widzew',
      toolsOk: json['toolsOk'] as bool? ?? true,
      pumpOk: json['pumpOk'] as bool? ?? true,
      pos: StationAlign.values.firstWhere(
        (item) => item.name == json['pos'],
        orElse: () => StationAlign.center,
      ),
    );
  }

  static List<BikeRepairStation> seeded() => const [
    BikeRepairStation(
      id: 'bs-rok',
      name: 'Stacja przy DH Widzew',
      place: 'al. Piłsudskiego',
      toolsOk: true,
      pumpOk: true,
      pos: StationAlign.topLeft,
    ),
    BikeRepairStation(
      id: 'bs-olech',
      name: 'Pompka przy SP 141',
      place: 'Olechów',
      toolsOk: false,
      pumpOk: true,
      pos: StationAlign.bottomRight,
    ),
    BikeRepairStation(
      id: 'bs-park',
      name: 'Narzędzia — Park Baden-Powella',
      place: 'Wejście od Puszkina',
      toolsOk: true,
      pumpOk: false,
      pos: StationAlign.center,
    ),
  ];
}
