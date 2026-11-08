class GardenFurnitureTip {
  final String id;
  final String title;
  final String body;
  final String authorName;

  const GardenFurnitureTip({
    required this.id,
    required this.title,
    required this.body,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'authorName': authorName,
  };

  factory GardenFurnitureTip.fromJson(Map<String, dynamic> json) {
    return GardenFurnitureTip(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Fachowiec',
    );
  }

  static List<GardenFurnitureTip> seeded() => const [
    GardenFurnitureTip(
      id: 'gf-teak',
      title: 'Olejowanie drewna teakowego na balkonie',
      body: 'Szlif 180, olej teak 2 warstwy. Pomogę w niedzielę rano.',
      authorName: 'Pan Marek',
    ),
    GardenFurnitureTip(
      id: 'gf-osl',
      title: 'Osłony balkonowe i odnawianie krzeseł',
      body: 'Montaż mat na balustradę, farba kredowa na krzesła.',
      authorName: 'Arek',
    ),
  ];
}
