enum FleaCategory { vinyl, games, furniture, collection, other }

enum FleaCondition { brandNew, veryGood, collectorOrRenovation }

extension FleaCategoryX on FleaCategory {
  String get label => switch (this) {
    FleaCategory.vinyl => 'Płyty winylowe',
    FleaCategory.games => 'Stare gry',
    FleaCategory.furniture => 'Meble z duszą',
    FleaCategory.collection => 'Kolekcje',
    FleaCategory.other => 'Rzadkie przedmioty',
  };
}

extension FleaConditionX on FleaCondition {
  String get label => switch (this) {
    FleaCondition.brandNew => 'Nowy',
    FleaCondition.veryGood => 'Bardzo dobry',
    FleaCondition.collectorOrRenovation => 'Stan kolekcjonerski / do renowacji',
  };
}

class FleaMarketItem {
  final String id;
  final String title;
  final String description;
  final FleaCategory category;
  final FleaCondition condition;
  final String price;
  final String authorName;
  final String subDistrict;

  const FleaMarketItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.condition,
    required this.price,
    required this.authorName,
    required this.subDistrict,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category.name,
    'condition': condition.name,
    'price': price,
    'authorName': authorName,
    'subDistrict': subDistrict,
  };

  factory FleaMarketItem.fromJson(Map<String, dynamic> json) {
    return FleaMarketItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: FleaCategory.values.firstWhere(
        (item) => item.name == json['category'],
        orElse: () => FleaCategory.other,
      ),
      condition: FleaCondition.values.firstWhere(
        (item) => item.name == json['condition'],
        orElse: () => FleaCondition.veryGood,
      ),
      price: json['price'] as String? ?? 'Do uzgodnienia',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Widzew Wschód',
    );
  }

  static List<FleaMarketItem> seeded() => const [
    FleaMarketItem(
      id: 'flea-vinyl',
      title: 'Winyle jazz / rock, lata 70.',
      description: 'Kilka płyt z kolekcji, okładki kompletne.',
      category: FleaCategory.vinyl,
      condition: FleaCondition.veryGood,
      price: '40 zł / szt.',
      authorName: 'Sąsiad ze Starego Widzewa',
      subDistrict: 'Stary Widzew',
    ),
    FleaMarketItem(
      id: 'flea-game',
      title: 'Stare gry na Pegasus',
      description: 'Kartridże po naszym dzieciństwie, działają.',
      category: FleaCategory.games,
      condition: FleaCondition.collectorOrRenovation,
      price: 'Wymiana lub 25 zł',
      authorName: 'Sąsiad z Janowa',
      subDistrict: 'Janów',
    ),
    FleaMarketItem(
      id: 'flea-table',
      title: 'Stół dębowy z duszą',
      description: 'Solidny, ślady użytkowania, do odświeżenia blatu.',
      category: FleaCategory.furniture,
      condition: FleaCondition.collectorOrRenovation,
      price: '350 zł',
      authorName: 'Sąsiadka z Olechowa',
      subDistrict: 'Olechów',
    ),
    FleaMarketItem(
      id: 'flea-pins',
      title: 'Kolekcja znaczków Widzew Łódź',
      description: 'Rzadkie przypinki z meczów, stan wystawowy.',
      category: FleaCategory.collection,
      condition: FleaCondition.brandNew,
      price: 'Do uzgodnienia',
      authorName: 'Sąsiad z Widzewa Wschód',
      subDistrict: 'Widzew Wschód',
    ),
  ];
}
