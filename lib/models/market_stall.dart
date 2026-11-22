enum MarketWeekday { monday, wednesday, friday, saturday }

extension MarketWeekdayX on MarketWeekday {
  String get label => switch (this) {
    MarketWeekday.monday => 'Poniedziałek',
    MarketWeekday.wednesday => 'Środa',
    MarketWeekday.friday => 'Piątek',
    MarketWeekday.saturday => 'Sobota',
  };
}

class MarketStall {
  final String id;
  final String name;
  final String offer;
  final String place;
  final MarketWeekday deliveryDay;
  final String authorName;

  const MarketStall({
    required this.id,
    required this.name,
    required this.offer,
    required this.place,
    required this.deliveryDay,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'offer': offer,
    'place': place,
    'deliveryDay': deliveryDay.name,
    'authorName': authorName,
  };

  factory MarketStall.fromJson(Map<String, dynamic> json) {
    return MarketStall(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      offer: json['offer'] as String? ?? '',
      place: json['place'] as String? ?? 'lokalny ryneczek',
      deliveryDay: MarketWeekday.values.firstWhere(
        (item) => item.name == json['deliveryDay'],
        orElse: () => MarketWeekday.saturday,
      ),
      authorName: json['authorName'] as String? ?? 'Wystawca',
    );
  }

  static List<MarketStall> seeded() => const [
    MarketStall(
      id: 'mkt-eggs',
      name: 'Jaja z zagrody',
      offer: 'Dostawa wiejskich jajek na klatkę',
      place: 'lokalny ryneczek',
      deliveryDay: MarketWeekday.wednesday,
      authorName: 'Gospodarstwo spod Koluszek',
    ),
    MarketStall(
      id: 'mkt-honey',
      name: 'Świeże miody',
      offer: 'Lipowy i wielokwiatowy, słoiki 0,9 kg',
      place: 'Ryneczek okolica',
      deliveryDay: MarketWeekday.saturday,
      authorName: 'Pszczelarz z okolicy',
    ),
    MarketStall(
      id: 'mkt-veg',
      name: 'Ekologiczne warzywa',
      offer: 'Buraki, marchew, kapusta z pola',
      place: 'lokalny ryneczek',
      deliveryDay: MarketWeekday.friday,
      authorName: 'Rolnik z okolic Łodzi',
    ),
  ];
}
