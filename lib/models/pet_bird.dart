enum BirdKind { parrot, food, accessory, behaviour }

extension BirdKindX on BirdKind {
  String get label => switch (this) {
    BirdKind.parrot => 'Papuga / ptak ozdobny',
    BirdKind.food => 'Karma',
    BirdKind.accessory => 'Akcesoria',
    BirdKind.behaviour => 'Porada behawioralna',
  };
}

class PetBirdOffer {
  final String id;
  final BirdKind kind;
  final String title;
  final String authorName;

  const PetBirdOffer({
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

  factory PetBirdOffer.fromJson(Map<String, dynamic> json) {
    return PetBirdOffer(
      id: json['id'] as String? ?? '',
      kind: BirdKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => BirdKind.parrot,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Hodowca',
    );
  }

  static List<PetBirdOffer> seeded() => const [
    PetBirdOffer(
      id: 'pb-kar',
      kind: BirdKind.food,
      title: 'Karma dla papug — nadwyżka peletek',
      authorName: 'Piotr',
    ),
    PetBirdOffer(
      id: 'pb-beh',
      kind: BirdKind.behaviour,
      title: 'Nimfa krzyczy rano — porady z bloku',
      authorName: 'Kasia',
    ),
  ];
}
