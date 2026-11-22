class ServiceReview {
  final String authorName;
  final int stars;
  final String text;
  final DateTime createdAt;

  const ServiceReview({
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

  factory ServiceReview.fromJson(Map<String, dynamic> json) {
    return ServiceReview(
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      stars: json['stars'] as int? ?? 5,
      text: json['text'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime(2026, 10, 13),
    );
  }
}

class NeighborService {
  static const categories = [
    'Hydraulik',
    'Elektryk',
    'Złota rączka',
    'Opieka nad dziećmi',
    'Pielęgnacja ogrodu',
  ];

  final String id;
  final String title;
  final String category;
  final String providerName;
  final String subDistrict;
  final String description;
  final bool isCertified;
  final bool isRecommended;
  final List<ServiceReview> reviews;

  const NeighborService({
    required this.id,
    required this.title,
    required this.category,
    required this.providerName,
    required this.subDistrict,
    required this.description,
    this.isCertified = false,
    this.isRecommended = false,
    this.reviews = const [],
  });

  double get rating {
    if (reviews.isEmpty) return 0;
    final sum = reviews.fold<int>(0, (total, item) => total + item.stars);
    return sum / reviews.length;
  }

  NeighborService copyWith({
    bool? isRecommended,
    List<ServiceReview>? reviews,
  }) {
    return NeighborService(
      id: id,
      title: title,
      category: category,
      providerName: providerName,
      subDistrict: subDistrict,
      description: description,
      isCertified: isCertified,
      isRecommended: isRecommended ?? this.isRecommended,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'providerName': providerName,
    'subDistrict': subDistrict,
    'description': description,
    'isCertified': isCertified,
    'isRecommended': isRecommended,
    'reviews': reviews.map((item) => item.toJson()).toList(),
  };

  factory NeighborService.fromJson(Map<String, dynamic> json) {
    return NeighborService(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? categories.first,
      providerName: json['providerName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Twoja okolica',
      description: json['description'] as String? ?? '',
      isCertified: json['isCertified'] as bool? ?? false,
      isRecommended: json['isRecommended'] as bool? ?? false,
      reviews: (json['reviews'] as List<dynamic>? ?? const [])
          .map(
            (item) =>
                ServiceReview.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
    );
  }

  static List<NeighborService> seeded() => [
    NeighborService(
      id: 'hydraulik-rokicinska',
      title: 'Hydraulik – awarie i wymiana baterii',
      category: 'Hydraulik',
      providerName: 'Marek',
      subDistrict: 'Twoja okolica',
      description:
          'Cieknące krany, spłuczki, wodomierze. Dojazd w okolicy.',
      isCertified: true,
      isRecommended: true,
      reviews: [
        ServiceReview(
          authorName: 'Sąsiadka',
          stars: 5,
          text: 'Szybko i uczciwie, polecam na klatkę.',
          createdAt: DateTime(2026, 10, 12, 18),
        ),
      ],
    ),
    NeighborService(
      id: 'elektryk-janow',
      title: 'Elektryk – gniazdka i oświetlenie klatki',
      category: 'Elektryk',
      providerName: 'Ania z okolicy',
      subDistrict: 'Twoja okolica',
      description: 'Instalacje, lampy na klatce, bezpieczniki. Certyfikat SEP.',
      isCertified: true,
    ),
    NeighborService(
      id: 'zlota-raczka',
      title: 'Złota rączka – drobne naprawy',
      category: 'Złota rączka',
      providerName: 'Tomek',
      subDistrict: 'Twoja okolica',
      description: 'Półki, drzwi, meble, uszczelki. Wieczorami po pracy.',
      isRecommended: true,
    ),
    NeighborService(
      id: 'opieka-olechow',
      title: 'Opieka nad dziećmi – popołudnia',
      category: 'Opieka nad dziećmi',
      providerName: 'Kasia',
      subDistrict: 'Twoja okolica',
      description: 'Opieka 2–10 lat, spacery w parku.',
    ),
    NeighborService(
      id: 'ogrod-puszkina',
      title: 'Pielęgnacja ogrodu i trawnika',
      category: 'Pielęgnacja ogrodu',
      providerName: 'Paweł z Parkowa',
      subDistrict: 'Twoja okolica',
      description: 'Koszenie, żywopłoty, sezonowe porządki przy blokach.',
      isCertified: true,
    ),
  ];
}
