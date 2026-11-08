enum FoodShareKind { partyLeftovers, homemadeDinner }

extension FoodShareKindX on FoodShareKind {
  String get label => switch (this) {
    FoodShareKind.partyLeftovers => 'Nadmiar po imprezie',
    FoodShareKind.homemadeDinner => 'Domowy obiad',
  };
}

class FoodShareOffer {
  final String id;
  final FoodShareKind kind;
  final String title;
  final String whenLabel;
  final String place;
  final String authorName;

  const FoodShareOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.whenLabel,
    required this.place,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'whenLabel': whenLabel,
    'place': place,
    'authorName': authorName,
  };

  factory FoodShareOffer.fromJson(Map<String, dynamic> json) {
    return FoodShareOffer(
      id: json['id'] as String? ?? '',
      kind: json['kind'] == FoodShareKind.homemadeDinner.name
          ? FoodShareKind.homemadeDinner
          : FoodShareKind.partyLeftovers,
      title: json['title'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      place: json['place'] as String? ?? 'Widzew',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<FoodShareOffer> seeded() => const [
    FoodShareOffer(
      id: 'food-party',
      kind: FoodShareKind.partyLeftovers,
      title: 'Zostały kanapki i ciasto po imieninach klatki',
      whenLabel: 'Dziś do 21:00',
      place: 'Klatka I, Rokicińska',
      authorName: 'Halina',
    ),
    FoodShareOffer(
      id: 'food-obiad',
      kind: FoodShareKind.homemadeDinner,
      title: 'Garnek barszczu — chętnie podzielę się z sąsiadem',
      whenLabel: 'Jutro 13:00',
      place: 'Stary Widzew',
      authorName: 'Pani Krysia',
    ),
  ];
}
