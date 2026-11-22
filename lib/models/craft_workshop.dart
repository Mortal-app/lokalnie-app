enum CraftMaterial { leather, wood, fabric }

extension CraftMaterialX on CraftMaterial {
  String get label => switch (this) {
    CraftMaterial.leather => 'Skóra',
    CraftMaterial.wood => 'Drewno',
    CraftMaterial.fabric => 'Tkaniny artystyczne',
  };
}

class CraftWorkshopOffer {
  final String id;
  final CraftMaterial material;
  final String title;
  final String area;
  final String authorName;

  const CraftWorkshopOffer({
    required this.id,
    required this.material,
    required this.title,
    required this.area,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'material': material.name,
    'title': title,
    'area': area,
    'authorName': authorName,
  };

  factory CraftWorkshopOffer.fromJson(Map<String, dynamic> json) {
    return CraftWorkshopOffer(
      id: json['id'] as String? ?? '',
      material: CraftMaterial.values.firstWhere(
        (item) => item.name == json['material'],
        orElse: () => CraftMaterial.fabric,
      ),
      title: json['title'] as String? ?? '',
      area: json['area'] as String? ?? 'Twoja okolica',
      authorName: json['authorName'] as String? ?? 'Twórca',
    );
  }

  static List<CraftWorkshopOffer> seeded() => const [
    CraftWorkshopOffer(
      id: 'cw-skora',
      material: CraftMaterial.leather,
      title: 'Paski i etui ze skóry — warsztat na klatce',
      area: 'Twoja okolica',
      authorName: 'Arek',
    ),
    CraftWorkshopOffer(
      id: 'cw-drewno',
      material: CraftMaterial.wood,
      title: 'Deski do krojenia z resztek dębu',
      area: 'Twoja okolica',
      authorName: 'Pani Halina',
    ),
  ];
}
