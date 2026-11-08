class TradespersonTrade {
  static const values = [
    'Hydraulika',
    'Remonty',
    'Zamek w drzwiach',
    'Elektryka',
    'Złota rączka',
  ];
}

class PortfolioPhoto {
  final String id;
  final String path;
  final String caption;
  final String phase;

  const PortfolioPhoto({
    required this.id,
    this.path = '',
    this.caption = '',
    this.phase = 'po',
  });

  String get phaseLabel => phase == 'przed' ? 'Przed' : 'Po';

  Map<String, Object?> toJson() => {
    'id': id,
    'path': path,
    'caption': caption,
    'phase': phase,
  };

  factory PortfolioPhoto.fromJson(Map<String, dynamic> json) {
    return PortfolioPhoto(
      id: json['id'] as String? ?? '',
      path: json['path'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      phase: json['phase'] as String? ?? 'po',
    );
  }
}

class TradespersonReview {
  final String listingId;
  final String authorName;
  final int stars;
  final String text;
  final DateTime createdAt;

  const TradespersonReview({
    required this.listingId,
    required this.authorName,
    required this.stars,
    required this.text,
    required this.createdAt,
  });

  bool get isPositive => stars >= 4;

  Map<String, Object?> toJson() => {
    'listingId': listingId,
    'authorName': authorName,
    'stars': stars,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
  };

  factory TradespersonReview.fromJson(Map<String, dynamic> json) {
    return TradespersonReview(
      listingId: json['listingId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      stars: (json['stars'] as num?)?.toInt() ?? 5,
      text: json['text'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime(2026, 10, 13),
    );
  }
}

class PriceListItem {
  final String service;
  final String rate;

  const PriceListItem({required this.service, required this.rate});

  Map<String, Object?> toJson() => {'service': service, 'rate': rate};

  factory PriceListItem.fromJson(Map<String, dynamic> json) {
    return PriceListItem(
      service: json['service'] as String? ?? '',
      rate: json['rate'] as String? ?? '',
    );
  }
}

class TradespersonCard {
  final String displayName;
  final String trade;
  final String description;
  final String rateLabel;
  final String phone;
  final String nip;

  const TradespersonCard({
    this.displayName = '',
    this.trade = 'Złota rączka',
    this.description = '',
    this.rateLabel = '',
    this.phone = '',
    this.nip = '',
  });

  bool get isComplete =>
      displayName.trim().isNotEmpty &&
      description.trim().isNotEmpty &&
      rateLabel.trim().isNotEmpty;

  TradespersonCard copyWith({
    String? displayName,
    String? trade,
    String? description,
    String? rateLabel,
    String? phone,
    String? nip,
  }) {
    return TradespersonCard(
      displayName: displayName ?? this.displayName,
      trade: trade ?? this.trade,
      description: description ?? this.description,
      rateLabel: rateLabel ?? this.rateLabel,
      phone: phone ?? this.phone,
      nip: nip ?? this.nip,
    );
  }

  Map<String, Object?> toJson() => {
    'displayName': displayName,
    'trade': trade,
    'description': description,
    'rateLabel': rateLabel,
    'phone': phone,
    'nip': nip,
  };

  factory TradespersonCard.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TradespersonCard();
    return TradespersonCard(
      displayName: json['displayName'] as String? ?? '',
      trade: json['trade'] as String? ?? TradespersonTrade.values.last,
      description: json['description'] as String? ?? '',
      rateLabel: json['rateLabel'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      nip: json['nip'] as String? ?? '',
    );
  }
}

class TradespersonAccount {
  final bool isTradesperson;
  final bool isPro;
  final TradespersonCard card;
  final DateTime? subscriptionExpiryDate;
  final bool listingPublished;
  final bool companyVerified;
  final List<PortfolioPhoto> portfolio;
  final List<PriceListItem> priceList;
  final List<TradespersonReview> reviews;

  const TradespersonAccount({
    this.isTradesperson = false,
    this.isPro = false,
    this.card = const TradespersonCard(),
    DateTime? subscriptionExpiryDate,
    DateTime? subscriptionExpiresAt,
    this.listingPublished = false,
    this.companyVerified = false,
    this.portfolio = const [],
    this.priceList = const [],
    this.reviews = const [],
  }) : subscriptionExpiryDate = subscriptionExpiryDate ?? subscriptionExpiresAt;

  DateTime? get subscriptionExpiresAt => subscriptionExpiryDate;

  bool get isProActive {
    if (!isTradesperson || !isPro) return false;
    final end = subscriptionExpiryDate;
    if (end == null) return true;
    return end.isAfter(DateTime.now());
  }

  String get subscriptionStatusLabel {
    if (isProActive) return 'Aktywny';
    if (subscriptionExpiryDate != null) return 'Wygasł';
    return 'Nieaktywny';
  }

  bool get canPublishListing => isProActive && card.isComplete;

  bool get showsDirectPhone => isProActive && listingPublished;

  bool get showsVerifiedBadge => isProActive;

  int get remainingDays {
    final end = subscriptionExpiryDate;
    if (end == null) return 0;
    final delta = end.difference(DateTime.now());
    if (delta.isNegative) return 0;
    return delta.inDays;
  }

  String get expiryDateLabel {
    final end = subscriptionExpiryDate;
    if (end == null) return 'brak pakietu';
    final day = end.day.toString().padLeft(2, '0');
    final month = end.month.toString().padLeft(2, '0');
    return '$day.$month.${end.year}';
  }

  TradespersonAccount copyWith({
    bool? isTradesperson,
    bool? isPro,
    TradespersonCard? card,
    DateTime? subscriptionExpiryDate,
    DateTime? subscriptionExpiresAt,
    bool clearSubscription = false,
    bool? listingPublished,
    bool? companyVerified,
    List<PortfolioPhoto>? portfolio,
    List<PriceListItem>? priceList,
    List<TradespersonReview>? reviews,
  }) {
    return TradespersonAccount(
      isTradesperson: isTradesperson ?? this.isTradesperson,
      isPro: clearSubscription ? false : (isPro ?? this.isPro),
      card: card ?? this.card,
      subscriptionExpiryDate: clearSubscription
          ? null
          : (subscriptionExpiryDate ??
                subscriptionExpiresAt ??
                this.subscriptionExpiryDate),
      listingPublished: listingPublished ?? this.listingPublished,
      companyVerified: companyVerified ?? this.companyVerified,
      portfolio: portfolio ?? this.portfolio,
      priceList: priceList ?? this.priceList,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, Object?> toJson() => {
    'isTradesperson': isTradesperson,
    'isPro': isPro,
    'card': card.toJson(),
    'subscriptionExpiryDate': subscriptionExpiryDate?.toIso8601String(),
    'subscriptionExpiresAt': subscriptionExpiryDate?.toIso8601String(),
    'listingPublished': listingPublished,
    'companyVerified': companyVerified,
    'portfolio': portfolio.map((item) => item.toJson()).toList(),
    'priceList': priceList.map((item) => item.toJson()).toList(),
    'reviews': reviews.map((item) => item.toJson()).toList(),
  };

  factory TradespersonAccount.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TradespersonAccount();
    final expiry = DateTime.tryParse(
      json['subscriptionExpiryDate'] as String? ??
          json['subscriptionExpiresAt'] as String? ??
          '',
    );
    final storedPro = json['isPro'] as bool?;
    return TradespersonAccount(
      isTradesperson: json['isTradesperson'] as bool? ?? false,
      isPro: storedPro ?? (expiry != null && expiry.isAfter(DateTime.now())),
      card: TradespersonCard.fromJson(
        json['card'] is Map
            ? Map<String, dynamic>.from(json['card'] as Map)
            : null,
      ),
      subscriptionExpiryDate: expiry,
      listingPublished: json['listingPublished'] as bool? ?? false,
      companyVerified: json['companyVerified'] as bool? ?? false,
      portfolio: (json['portfolio'] as List<dynamic>? ?? const [])
          .map(
            (item) => PortfolioPhoto.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      priceList: (json['priceList'] as List<dynamic>? ?? const [])
          .map(
            (item) => PriceListItem.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      reviews: (json['reviews'] as List<dynamic>? ?? const [])
          .map(
            (item) => TradespersonReview.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}

class TradespersonListing {
  final String id;
  final String displayName;
  final String trade;
  final String description;
  final String rateLabel;
  final String phone;
  final String subDistrict;
  final bool verified;
  final bool isPro;
  final bool isMine;
  final bool companyVerified;
  final List<PortfolioPhoto> portfolio;
  final List<PriceListItem> priceList;
  final List<TradespersonReview> reviews;
  final List<String> serviceAreas;

  const TradespersonListing({
    required this.id,
    required this.displayName,
    required this.trade,
    required this.description,
    required this.rateLabel,
    required this.phone,
    required this.subDistrict,
    this.verified = true,
    bool isPro = true,
    bool? subscriptionActive,
    this.isMine = false,
    this.companyVerified = false,
    this.portfolio = const [],
    this.priceList = const [],
    this.reviews = const [],
    this.serviceAreas = const [],
  }) : isPro = subscriptionActive ?? isPro;

  bool get subscriptionActive => isPro;

  List<String> get areasServed =>
      serviceAreas.isNotEmpty ? serviceAreas : [subDistrict];

  bool servesDistrict(String? district) {
    if (district == null ||
        district.isEmpty ||
        district == 'Wszystkie' ||
        district == 'Wszystkie osiedla') {
      return true;
    }
    return areasServed.contains(district);
  }

  bool get showsDirectPhone => subscriptionActive;

  bool get showsVerifiedBadge => subscriptionActive;

  double get rating {
    if (reviews.isEmpty) return 0;
    final sum = reviews.fold<int>(0, (total, item) => total + item.stars);
    return sum / reviews.length;
  }

  int get positiveReviewCount =>
      reviews.where((item) => item.isPositive).length;

  bool get hasQualityGuarantee =>
      rating > 4.8 && positiveReviewCount >= 5;
}

class TradespersonJobRequest {
  final String id;
  final String listingId;
  final String tradespersonName;
  final String clientName;
  final String title;
  final String description;
  final String clientPhone;
  final DateTime createdAt;
  final String preferredDay;
  final String photoPath;
  final bool isQuote;

  const TradespersonJobRequest({
    required this.id,
    required this.listingId,
    required this.tradespersonName,
    required this.clientName,
    required this.title,
    required this.description,
    required this.clientPhone,
    required this.createdAt,
    this.preferredDay = '',
    this.photoPath = '',
    this.isQuote = false,
  });

  bool isActive({DateTime? now}) =>
      NeighborHelpPost.isFresh(createdAt, now: now);

  Map<String, Object?> toJson() => {
    'id': id,
    'listingId': listingId,
    'tradespersonName': tradespersonName,
    'clientName': clientName,
    'title': title,
    'description': description,
    'clientPhone': clientPhone,
    'createdAt': createdAt.toIso8601String(),
    'preferredDay': preferredDay,
    'photoPath': photoPath,
    'isQuote': isQuote,
  };

  factory TradespersonJobRequest.fromJson(Map<String, dynamic> json) {
    return TradespersonJobRequest(
      id: json['id'] as String? ?? '',
      listingId: json['listingId'] as String? ?? '',
      tradespersonName: json['tradespersonName'] as String? ?? '',
      clientName: json['clientName'] as String? ?? 'Sąsiad',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      clientPhone: json['clientPhone'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime(2026, 10, 13),
      preferredDay: json['preferredDay'] as String? ?? '',
      photoPath: json['photoPath'] as String? ?? '',
      isQuote: json['isQuote'] as bool? ?? false,
    );
  }
}

class NeighborHelpPost {
  final String id;
  final String title;
  final String description;
  final String subDistrict;
  final String clientName;
  final String clientPhone;
  final DateTime createdAt;
  final String? acceptedBy;
  final bool isUrgent;

  const NeighborHelpPost({
    required this.id,
    required this.title,
    required this.description,
    required this.subDistrict,
    required this.clientName,
    this.clientPhone = '',
    required this.createdAt,
    this.acceptedBy,
    this.isUrgent = false,
  });

  static const boardMaxAge = Duration(days: 30);

  bool get isOpen => acceptedBy == null || acceptedBy!.isEmpty;

  static bool isFresh(DateTime createdAt, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    return !createdAt.isBefore(reference.subtract(boardMaxAge));
  }

  bool isActive({DateTime? now}) => isFresh(createdAt, now: now);

  NeighborHelpPost copyWith({String? acceptedBy, bool? isUrgent}) {
    return NeighborHelpPost(
      id: id,
      title: title,
      description: description,
      subDistrict: subDistrict,
      clientName: clientName,
      clientPhone: clientPhone,
      createdAt: createdAt,
      acceptedBy: acceptedBy ?? this.acceptedBy,
      isUrgent: isUrgent ?? this.isUrgent,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'subDistrict': subDistrict,
    'clientName': clientName,
    'clientPhone': clientPhone,
    'createdAt': createdAt.toIso8601String(),
    'acceptedBy': acceptedBy,
    'isUrgent': isUrgent,
  };

  factory NeighborHelpPost.fromJson(Map<String, dynamic> json) {
    return NeighborHelpPost(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      subDistrict: json['subDistrict'] as String? ?? 'Widzew Wschód',
      clientName: json['clientName'] as String? ?? 'Sąsiad',
      clientPhone: json['clientPhone'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime(2026, 10, 13),
      acceptedBy: json['acceptedBy'] as String?,
      isUrgent: json['isUrgent'] as bool? ?? false,
    );
  }

  static List<NeighborHelpPost> seeded() => [
    NeighborHelpPost(
      id: 'help-kran-olechow',
      title: 'Cieknący kran w kuchni',
      description:
          'Bateria kuchenna cieknie od tygodnia. Szukam hydraulika na Olechowie, wieczór po 17.',
      subDistrict: 'Olechów',
      clientName: 'Kasia z Olechowa',
      clientPhone: '+48 512 100 200',
      createdAt: DateTime(2026, 10, 13, 9),
    ),
    NeighborHelpPost(
      id: 'help-zamek-janow',
      title: 'Zamek w drzwiach mieszkania',
      description:
          'Wkładka zacina się, klucz obraca się luzem. Potrzebna wymiana jeszcze dziś.',
      subDistrict: 'Janów',
      clientName: 'Marek z Janowa',
      clientPhone: '+48 512 300 400',
      createdAt: DateTime(2026, 10, 13, 11),
      isUrgent: true,
    ),
    NeighborHelpPost(
      id: 'help-malowanie-widzew',
      title: 'Malowanie pokoju 12 m²',
      description:
          'Szukam ekipy na jeden pokój + drobne szpachlowanie. Termin w weekend.',
      subDistrict: 'Widzew Wschód',
      clientName: 'Ania z Widzewa',
      createdAt: DateTime(2026, 10, 13, 14),
    ),
  ];
}

class MarketplaceState {
  final TradespersonAccount account;
  final List<TradespersonJobRequest> jobRequests;
  final List<NeighborHelpPost> helpPosts;
  final List<TradespersonReview> reviews;
  final List<String> favoriteListingIds;
  final List<String> searchHistory;

  const MarketplaceState({
    this.account = const TradespersonAccount(),
    this.jobRequests = const [],
    this.helpPosts = const [],
    this.reviews = const [],
    this.favoriteListingIds = const [],
    this.searchHistory = const [],
  });

  List<NeighborHelpPost> get boardPosts =>
      helpPosts.isEmpty ? NeighborHelpPost.seeded() : helpPosts;

  List<NeighborHelpPost> activeHelpPosts({DateTime? now}) => boardPosts
      .where((post) => post.isActive(now: now))
      .toList();

  MarketplaceState prunedExpired({DateTime? now}) {
    final posts = helpPosts
        .where((post) => post.isActive(now: now))
        .toList();
    final jobs = jobRequests
        .where((job) => job.isActive(now: now))
        .toList();
    return copyWith(helpPosts: posts, jobRequests: jobs);
  }

  bool get hasExpiredBoardItems {
    final pruned = prunedExpired();
    return pruned.helpPosts.length != helpPosts.length ||
        pruned.jobRequests.length != jobRequests.length;
  }

  MarketplaceState copyWith({
    TradespersonAccount? account,
    List<TradespersonJobRequest>? jobRequests,
    List<NeighborHelpPost>? helpPosts,
    List<TradespersonReview>? reviews,
    List<String>? favoriteListingIds,
    List<String>? searchHistory,
  }) {
    return MarketplaceState(
      account: account ?? this.account,
      jobRequests: jobRequests ?? this.jobRequests,
      helpPosts: helpPosts ?? this.helpPosts,
      reviews: reviews ?? this.reviews,
      favoriteListingIds: favoriteListingIds ?? this.favoriteListingIds,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }

  Map<String, Object?> toJson() => {
    'account': account.toJson(),
    'jobRequests': jobRequests.map((item) => item.toJson()).toList(),
    'helpPosts': helpPosts.map((item) => item.toJson()).toList(),
    'reviews': reviews.map((item) => item.toJson()).toList(),
    'favoriteListingIds': favoriteListingIds,
    'searchHistory': searchHistory,
  };

  factory MarketplaceState.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MarketplaceState();
    final posts = (json['helpPosts'] as List<dynamic>? ?? const [])
        .map(
          (item) => NeighborHelpPost.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
    return MarketplaceState(
      account: TradespersonAccount.fromJson(
        json['account'] is Map
            ? Map<String, dynamic>.from(json['account'] as Map)
            : null,
      ),
      jobRequests: (json['jobRequests'] as List<dynamic>? ?? const [])
          .map(
            (item) => TradespersonJobRequest.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      helpPosts: posts.isEmpty ? NeighborHelpPost.seeded() : posts,
      reviews: (json['reviews'] as List<dynamic>? ?? const [])
          .map(
            (item) => TradespersonReview.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      favoriteListingIds: (json['favoriteListingIds'] as List<dynamic>? ??
              const [])
          .map((item) => item.toString())
          .toList(),
      searchHistory: (json['searchHistory'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList(),
    );
  }
}

class TradespersonCatalog {
  static const mineId = 'mine-listing';

  static List<PriceListItem> _prices(String trade) => switch (trade) {
    'Hydraulika' => const [
      PriceListItem(service: 'Uszczelnienie baterii / spłuczki', rate: 'od 80 zł'),
      PriceListItem(service: 'Wymiana baterii', rate: 'od 150 zł'),
      PriceListItem(service: 'Awaria (dojazd Widzew)', rate: 'od 120 zł'),
    ],
    'Remonty' => const [
      PriceListItem(service: 'Malowanie ścian', rate: 'od 25 zł/m²'),
      PriceListItem(service: 'Gładzie gipsowe', rate: 'od 40 zł/m²'),
      PriceListItem(service: 'Drobne tynki klatkowe', rate: 'wycena'),
    ],
    'Zamek w drzwiach' => const [
      PriceListItem(service: 'Awaryjne otwarcie drzwi', rate: 'od 150 zł'),
      PriceListItem(service: 'Wymiana wkładki', rate: 'od 180 zł'),
      PriceListItem(service: 'Dorobienie klucza', rate: 'od 40 zł'),
    ],
    _ => const [
      PriceListItem(service: 'Drobna naprawa (złota rączka)', rate: 'od 90 zł'),
      PriceListItem(service: 'Roboczogodzina', rate: 'od 80 zł'),
    ],
  };

  static List<TradespersonReview> _qualityReviews(String listingId) => [
    TradespersonReview(
      listingId: listingId,
      authorName: 'Sąsiadka z klatki',
      stars: 5,
      text: 'Szybko, czysto, uczciwa cena.',
      createdAt: DateTime(2026, 10, 8),
    ),
    TradespersonReview(
      listingId: listingId,
      authorName: 'Pan z Olechowa',
      stars: 5,
      text: 'Polecam na awarie wieczorne.',
      createdAt: DateTime(2026, 10, 9),
    ),
    TradespersonReview(
      listingId: listingId,
      authorName: 'Kasia z Janowa',
      stars: 5,
      text: 'Punktualnie i po robocie posprzątane.',
      createdAt: DateTime(2026, 10, 10),
    ),
    TradespersonReview(
      listingId: listingId,
      authorName: 'Marek ze Starego Widzewa',
      stars: 5,
      text: 'Fachowo wytłumaczył, co było nie tak.',
      createdAt: DateTime(2026, 10, 11),
    ),
    TradespersonReview(
      listingId: listingId,
      authorName: 'Ania z Widzewa Wschód',
      stars: 5,
      text: 'Najlepsza ekipa z okolicy.',
      createdAt: DateTime(2026, 10, 12),
    ),
  ];

  static List<PortfolioPhoto> _portfolio(String id) => [
    PortfolioPhoto(
      id: '$id-przed',
      caption: 'Stan przed naprawą',
      phase: 'przed',
    ),
    PortfolioPhoto(
      id: '$id-po',
      caption: 'Efekt po realizacji',
      phase: 'po',
    ),
  ];

  static List<TradespersonListing> seeded() => [
    TradespersonListing(
      id: 'pro-hydraulik-olechow',
      displayName: 'Hydraulik Olechów – Marek Nowak',
      trade: 'Hydraulika',
      description:
          'Awarie, uszczelnienia, wymiana baterii i spłuczek. Dojazd Widzew / Olechów / Janów.',
      rateLabel: 'od 120 zł + dojazd',
      phone: '+48 600 111 222',
      subDistrict: 'Olechów',
      companyVerified: true,
      portfolio: _portfolio('pro-hydraulik-olechow'),
      priceList: _prices('Hydraulika'),
      reviews: _qualityReviews('pro-hydraulik-olechow'),
      serviceAreas: ['Olechów', 'Widzew Wschód', 'Janów'],
    ),
    TradespersonListing(
      id: 'pro-remonty-widzew',
      displayName: 'Remonty klatkowe – Ekipa Widzew',
      trade: 'Remonty',
      description:
          'Malowanie, gładzie, drobne tynki. Terminy wieczorne po pracy mieszkańców.',
      rateLabel: 'wycena na miejscu',
      phone: '+48 600 333 444',
      subDistrict: 'Widzew Wschód',
      companyVerified: true,
      portfolio: _portfolio('pro-remonty-widzew'),
      priceList: _prices('Remonty'),
      reviews: _qualityReviews('pro-remonty-widzew'),
      serviceAreas: ['Widzew Wschód', 'Stary Widzew'],
    ),
    TradespersonListing(
      id: 'pro-zamek-janow',
      displayName: 'Awaryjne otwieranie drzwi – Janów',
      trade: 'Zamek w drzwiach',
      description:
          'Wymiana wkładek, otwieranie bez zniszczeń, dorabianie kluczy do klatki.',
      rateLabel: 'od 150 zł',
      phone: '+48 600 555 666',
      subDistrict: 'Janów',
      companyVerified: true,
      portfolio: _portfolio('pro-zamek-janow'),
      priceList: _prices('Zamek w drzwiach'),
      reviews: [
        TradespersonReview(
          listingId: 'pro-zamek-janow',
          authorName: 'Sąsiad z Janowa',
          stars: 5,
          text: 'Otworzył drzwi bez zniszczeń.',
          createdAt: DateTime(2026, 10, 12),
        ),
        TradespersonReview(
          listingId: 'pro-zamek-janow',
          authorName: 'Pani Krysia',
          stars: 4,
          text: 'Trochę czekałam, ale zamek działa.',
          createdAt: DateTime(2026, 10, 13),
        ),
      ],
      serviceAreas: ['Janów'],
    ),
  ];

  static List<TradespersonListing> visible(
    TradespersonAccount account, {
    List<TradespersonReview> extraReviews = const [],
  }) {
    List<TradespersonReview> merged(String id, List<TradespersonReview> base) {
      return [
        ...base,
        ...extraReviews.where((item) => item.listingId == id),
      ];
    }

    final listings = [
      for (final item in seeded())
        TradespersonListing(
          id: item.id,
          displayName: item.displayName,
          trade: item.trade,
          description: item.description,
          rateLabel: item.rateLabel,
          phone: item.phone,
          subDistrict: item.subDistrict,
          verified: item.verified,
          isPro: item.isPro,
          companyVerified: item.companyVerified,
          portfolio: item.portfolio,
          priceList: item.priceList,
          reviews: merged(item.id, item.reviews),
          serviceAreas: item.serviceAreas,
        ),
    ];
    if (account.isTradesperson) {
      final mine = TradespersonListing(
        id: mineId,
        displayName: account.card.displayName.isEmpty
            ? 'Twoja wizytówka fachowca'
            : account.card.displayName,
        trade: account.card.trade,
        description: account.card.description.isEmpty
            ? 'Uzupełnij wizytówkę i aktywuj abonament PRO, żeby publikować ofertę.'
            : account.card.description,
        rateLabel: account.card.rateLabel.isEmpty
            ? 'stawka do uzupełnienia'
            : account.card.rateLabel,
        phone: account.card.phone,
        subDistrict: 'Widzew',
        verified: account.isProActive,
        isPro: account.isProActive,
        isMine: true,
        companyVerified: account.companyVerified,
        portfolio: account.portfolio,
        priceList: account.priceList,
        reviews: merged(mineId, account.reviews),
        serviceAreas: const [
          'Stary Widzew',
          'Widzew Wschód',
          'Olechów',
          'Janów',
        ],
      );
      if (account.isProActive && account.listingPublished) {
        listings.insert(0, mine);
      } else if (!account.isProActive) {
        listings.add(mine);
      }
    }
    listings.sort((a, b) {
      final byPro = (b.isPro ? 1 : 0) - (a.isPro ? 1 : 0);
      if (byPro != 0) return byPro;
      if (a.isMine != b.isMine) return a.isMine ? -1 : 1;
      return 0;
    });
    return listings;
  }
}
