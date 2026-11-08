class GreenPathSpot {
  final String id;
  final String title;
  final String area;
  final String body;

  const GreenPathSpot({
    required this.id,
    required this.title,
    required this.area,
    required this.body,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'area': area,
    'body': body,
  };

  factory GreenPathSpot.fromJson(Map<String, dynamic> json) {
    return GreenPathSpot(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      area: json['area'] as String? ?? 'Widzew',
      body: json['body'] as String? ?? '',
    );
  }

  static List<GreenPathSpot> seeded() => const [
    GreenPathSpot(
      id: 'gp-gorka',
      title: 'Górka Widzewska — cichy stok',
      area: 'Park Górka Widzewska',
      body:
          'Mniej znana ścieżka za alejką główną, karmniki i widok na blokowisko od strony zieleni.',
    ),
    GreenPathSpot(
      id: 'gp-jasien',
      title: 'Meander Jasienia przy Olechowie',
      area: 'Olechów',
      body:
          'Wąska ścieżka wzdłuż rzeki, z dala od Piłsudskiego — czaple wieczorem.',
    ),
    GreenPathSpot(
      id: 'gp-janow',
      title: 'Zadrzewienia przy stawach Janowskich',
      area: 'Janów',
      body:
          'Brzeg stawu od strony ogródków — mniej rowerów, więcej sitowia i żab.',
    ),
  ];
}
