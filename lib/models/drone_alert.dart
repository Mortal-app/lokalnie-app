class DroneAlert {
  final String id;
  final String title;
  final String place;
  final String details;
  final String authorName;
  final int operatorSpots;
  final bool found;

  const DroneAlert({
    required this.id,
    required this.title,
    required this.place,
    required this.details,
    required this.authorName,
    this.operatorSpots = 0,
    this.found = false,
  });

  DroneAlert copyWith({int? operatorSpots, bool? found}) {
    return DroneAlert(
      id: id,
      title: title,
      place: place,
      details: details,
      authorName: authorName,
      operatorSpots: operatorSpots ?? this.operatorSpots,
      found: found ?? this.found,
    );
  }

  DroneAlert spot() => copyWith(operatorSpots: operatorSpots + 1);

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'place': place,
    'details': details,
    'authorName': authorName,
    'operatorSpots': operatorSpots,
    'found': found,
  };

  factory DroneAlert.fromJson(Map<String, dynamic> json) {
    return DroneAlert(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? '',
      details: json['details'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      operatorSpots: json['operatorSpots'] as int? ?? 0,
      found: json['found'] as bool? ?? false,
    );
  }

  static List<DroneAlert> seeded() => const [
    DroneAlert(
      id: 'drone-bp',
      title: 'Zaginął dron / model RC w koronie drzew w Parku Baden-Powella',
      place: 'Park Baden-Powella',
      details:
          'DJI Mini, biały — zawisł w koronie lipy przy alei. Operatorzy z Widzewa: namierzcie pisk / światełko.',
      authorName: 'Piotr',
      operatorSpots: 1,
    ),
  ];
}
