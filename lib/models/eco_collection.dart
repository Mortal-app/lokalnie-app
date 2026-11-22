enum EcoMaterial { paper, eWaste, cans }

extension EcoMaterialX on EcoMaterial {
  String get label => switch (this) {
    EcoMaterial.paper => 'Makulatura',
    EcoMaterial.eWaste => 'Elektrośmieci',
    EcoMaterial.cans => 'Puszki',
  };
}

class EcoCollectionDrive {
  final String id;
  final String blockName;
  final EcoMaterial material;
  final String whenLabel;
  final double kgCollected;
  final String place;

  const EcoCollectionDrive({
    required this.id,
    required this.blockName,
    required this.material,
    required this.whenLabel,
    required this.kgCollected,
    required this.place,
  });

  EcoCollectionDrive copyWith({double? kgCollected}) {
    return EcoCollectionDrive(
      id: id,
      blockName: blockName,
      material: material,
      whenLabel: whenLabel,
      kgCollected: kgCollected ?? this.kgCollected,
      place: place,
    );
  }

  EcoCollectionDrive addKg(double kg) =>
      copyWith(kgCollected: kgCollected + kg);

  Map<String, Object?> toJson() => {
    'id': id,
    'blockName': blockName,
    'material': material.name,
    'whenLabel': whenLabel,
    'kgCollected': kgCollected,
    'place': place,
  };

  factory EcoCollectionDrive.fromJson(Map<String, dynamic> json) {
    return EcoCollectionDrive(
      id: json['id'] as String? ?? '',
      blockName: json['blockName'] as String? ?? '',
      material: EcoMaterial.values.firstWhere(
        (item) => item.name == json['material'],
        orElse: () => EcoMaterial.paper,
      ),
      whenLabel: json['whenLabel'] as String? ?? '',
      kgCollected: (json['kgCollected'] as num?)?.toDouble() ?? 0,
      place: json['place'] as String? ?? 'Okolica',
    );
  }

  static List<EcoCollectionDrive> seeded() => const [
    EcoCollectionDrive(
      id: 'eco-paper',
      blockName: 'Główna 140',
      material: EcoMaterial.paper,
      whenLabel: 'Sobota 8:00–12:00',
      kgCollected: 84,
      place: 'Kontener przy śmietniku A',
    ),
    EcoCollectionDrive(
      id: 'eco-e',
      blockName: 'Parkowa 77',
      material: EcoMaterial.eWaste,
      whenLabel: 'Niedziela 10:00–14:00',
      kgCollected: 21,
      place: 'Garaż podziemny — boks 2',
    ),
    EcoCollectionDrive(
      id: 'eco-cans',
      blockName: 'okolica przy szkole podstawowej',
      material: EcoMaterial.cans,
      whenLabel: 'Cały tydzień',
      kgCollected: 12.5,
      place: 'Worek przy klatce III',
    ),
  ];
}
