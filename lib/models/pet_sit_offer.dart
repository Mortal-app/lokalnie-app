enum PetSitKind { lookingForSitter, canHelp, foundPet }

extension PetSitKindX on PetSitKind {
  String get label => switch (this) {
    PetSitKind.lookingForSitter => 'Szukam opiekuna',
    PetSitKind.canHelp => 'Mogę pomóc / wyprowadzić',
    PetSitKind.foundPet => 'Znalazłem zwierzaka',
  };
}

class PetSitOffer {
  final String id;
  final String title;
  final String description;
  final PetSitKind kind;
  final String animal;
  final String whenLabel;
  final String authorName;
  final String subDistrict;

  const PetSitOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.animal,
    required this.whenLabel,
    required this.authorName,
    required this.subDistrict,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'kind': kind.name,
    'animal': animal,
    'whenLabel': whenLabel,
    'authorName': authorName,
    'subDistrict': subDistrict,
  };

  factory PetSitOffer.fromJson(Map<String, dynamic> json) {
    return PetSitOffer(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      kind: PetSitKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => PetSitKind.lookingForSitter,
      ),
      animal: json['animal'] as String? ?? 'pies',
      whenLabel: json['whenLabel'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Widzew Wschód',
    );
  }

  static List<PetSitOffer> seeded() => const [
    PetSitOffer(
      id: 'pet-walk',
      title: 'Kto wyprowadzi psa w środę?',
      description: 'Labradorka, 30 minut spaceru po osiedlu.',
      kind: PetSitKind.lookingForSitter,
      animal: 'pies',
      whenLabel: 'Środa po 17:00',
      authorName: 'Sąsiadka z Olechowa',
      subDistrict: 'Olechów',
    ),
    PetSitOffer(
      id: 'pet-weekend',
      title: 'Szukam opieki nad kotem na czas weekendowego wyjazdu',
      description: 'Karmienie i kuweta, klucze oddam sąsiadom z klatki.',
      kind: PetSitKind.lookingForSitter,
      animal: 'kot',
      whenLabel: 'Piątek–niedziela',
      authorName: 'Sąsiad z Janowa',
      subDistrict: 'Janów',
    ),
    PetSitOffer(
      id: 'pet-help',
      title: 'Mogę wyprowadzić psa po południu',
      description: 'Jestem na home office, chętnie wezmę spacer 15–20 min.',
      kind: PetSitKind.canHelp,
      animal: 'pies',
      whenLabel: 'Pn–pt, 14:00–16:00',
      authorName: 'Sąsiad z Widzewa Wschód',
      subDistrict: 'Widzew Wschód',
    ),
    PetSitOffer(
      id: 'pet-found',
      title: 'Znalazłem zwierzaka w okolicy',
      description: 'Mały pies bez obroży przy parku, szukam właściciela.',
      kind: PetSitKind.foundPet,
      animal: 'pies',
      whenLabel: 'Dziś',
      authorName: 'Sąsiadka ze Starego Widzewa',
      subDistrict: 'Stary Widzew',
    ),
  ];
}
