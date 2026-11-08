class FoodReview {
  final String authorName;
  final int stars;
  final String text;
  final DateTime createdAt;

  const FoodReview({
    required this.authorName,
    required this.stars,
    required this.text,
    required this.createdAt,
  });

  Map<String, Object?> toJson() => {
    'authorName': authorName,
    'stars': stars,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
  };

  factory FoodReview.fromJson(Map<String, dynamic> json) {
    return FoodReview(
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      stars: json['stars'] as int? ?? 5,
      text: json['text'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime(2026, 10, 13),
    );
  }
}

class FoodSpot {
  final String id;
  final String name;
  final String kind;
  final String subDistrict;
  final String description;
  final List<FoodReview> reviews;

  const FoodSpot({
    required this.id,
    required this.name,
    required this.kind,
    required this.subDistrict,
    required this.description,
    this.reviews = const [],
  });

  double get neighborTaste {
    if (reviews.isEmpty) return 0;
    final sum = reviews.fold<int>(0, (total, item) => total + item.stars);
    return sum / reviews.length;
  }

  FoodSpot copyWith({List<FoodReview>? reviews}) {
    return FoodSpot(
      id: id,
      name: name,
      kind: kind,
      subDistrict: subDistrict,
      description: description,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'kind': kind,
    'subDistrict': subDistrict,
    'description': description,
    'reviews': reviews.map((item) => item.toJson()).toList(),
  };

  factory FoodSpot.fromJson(Map<String, dynamic> json) {
    return FoodSpot(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      kind: json['kind'] as String? ?? 'Kawiarnia',
      subDistrict: json['subDistrict'] as String? ?? 'Widzew Wschód',
      description: json['description'] as String? ?? '',
      reviews: (json['reviews'] as List<dynamic>? ?? const [])
          .map(
            (item) => FoodReview.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
    );
  }

  static List<FoodSpot> seeded() => [
    FoodSpot(
      id: 'pizza-widzew',
      name: 'Osiedlowa pizzeria przy Rokicińskiej',
      kind: 'Pizzeria',
      subDistrict: 'Widzew Wschód',
      description: 'Duże okrągłe, sos czosnkowy, szybki odbiór dla sąsiadów.',
      reviews: [
        FoodReview(
          authorName: 'Sąsiad z Widzewa',
          stars: 5,
          text: 'Capricciosa jak trzeba. Sąsiedzki Smak 5/5.',
          createdAt: DateTime(2026, 10, 18),
        ),
      ],
    ),
    FoodSpot(
      id: 'paczki-janow',
      name: 'Pączkarnia na Janowie',
      kind: 'Pączkarnia',
      subDistrict: 'Janów',
      description: 'Tradycyjne pączki i faworki, kolejka w tłusty czwartek.',
    ),
    FoodSpot(
      id: 'kawa-olechow',
      name: 'Kawiarnia na Olechowie',
      kind: 'Kawiarnia',
      subDistrict: 'Olechów',
      description: 'Przelew, ciasta domowe, wózki dziecięce wchodzą bez problemu.',
    ),
    FoodSpot(
      id: 'kawa-wschod',
      name: 'Kawiarnia Widzew Wschód',
      kind: 'Kawiarnia',
      subDistrict: 'Widzew Wschód',
      description: 'Śniadania i laptop-friendly stoliki przy Górce.',
    ),
  ];
}
