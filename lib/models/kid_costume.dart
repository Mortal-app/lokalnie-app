enum CostumeOccasion { carnival, schoolPlay, halloween }

extension CostumeOccasionX on CostumeOccasion {
  String get label => switch (this) {
    CostumeOccasion.carnival => 'Bal karnawałowy',
    CostumeOccasion.schoolPlay => 'Przedstawienie szkolne',
    CostumeOccasion.halloween => 'Halloween',
  };
}

class KidCostumeOffer {
  final String id;
  final CostumeOccasion occasion;
  final String title;
  final String size;
  final String authorName;

  const KidCostumeOffer({
    required this.id,
    required this.occasion,
    required this.title,
    required this.size,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'occasion': occasion.name,
    'title': title,
    'size': size,
    'authorName': authorName,
  };

  factory KidCostumeOffer.fromJson(Map<String, dynamic> json) {
    return KidCostumeOffer(
      id: json['id'] as String? ?? '',
      occasion: CostumeOccasion.values.firstWhere(
        (item) => item.name == json['occasion'],
        orElse: () => CostumeOccasion.carnival,
      ),
      title: json['title'] as String? ?? '',
      size: json['size'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Rodzic',
    );
  }

  static List<KidCostumeOffer> seeded() => const [
    KidCostumeOffer(
      id: 'kc-smok',
      occasion: CostumeOccasion.carnival,
      title: 'Smok Wawelski — wypożyczę na bal',
      size: '122–128',
      authorName: 'Hania',
    ),
    KidCostumeOffer(
      id: 'kc-hal',
      occasion: CostumeOccasion.halloween,
      title: 'Dynia i czarodziej — wymiana strojów',
      size: '110–116',
      authorName: 'Kasia',
    ),
  ];
}
