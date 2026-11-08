class AirPlantGuide {
  final String id;
  final String name;
  final String care;
  final String authorName;

  const AirPlantGuide({
    required this.id,
    required this.name,
    required this.care,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'care': care,
    'authorName': authorName,
  };

  factory AirPlantGuide.fromJson(Map<String, dynamic> json) {
    return AirPlantGuide(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      care: json['care'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<AirPlantGuide> seeded() => const [
    AirPlantGuide(
      id: 'ap-skrz',
      name: 'Skrzydłokwiat',
      care:
          'Wilgotna ziemia, bez ostrego słońca — dobry do wielkiej płyty od północy.',
      authorName: 'Ewa',
    ),
    AirPlantGuide(
      id: 'ap-sans',
      name: 'Sansewieria',
      care: 'Rzadkie podlewanie, znosi suche powietrze przy kaloryferze.',
      authorName: 'Pani Krysia',
    ),
  ];
}
