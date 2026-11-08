enum AquaKind { plant, shrimp, filterGear, terrarium }

extension AquaKindX on AquaKind {
  String get label => switch (this) {
    AquaKind.plant => 'Roślinki akwariowe',
    AquaKind.shrimp => 'Krewetki',
    AquaKind.filterGear => 'Sprzęt filtracyjny',
    AquaKind.terrarium => 'Terrarium',
  };
}

class AquariumSwapOffer {
  final String id;
  final AquaKind kind;
  final String title;
  final String authorName;

  const AquariumSwapOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'authorName': authorName,
  };

  factory AquariumSwapOffer.fromJson(Map<String, dynamic> json) {
    return AquariumSwapOffer(
      id: json['id'] as String? ?? '',
      kind: AquaKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => AquaKind.plant,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Akwarysta',
    );
  }

  static List<AquariumSwapOffer> seeded() => const [
    AquariumSwapOffer(
      id: 'aq-rosl',
      kind: AquaKind.plant,
      title: 'Nadwyżka anubiasa — oddam za krewetki',
      authorName: 'Piotr',
    ),
    AquariumSwapOffer(
      id: 'aq-fil',
      kind: AquaKind.filterGear,
      title: 'Gąbka i wkład do filtra — nadwyżka z 60 l',
      authorName: 'Kasia',
    ),
  ];
}
