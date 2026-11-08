enum GarageOfferKind { rent, lend }

enum GarageSpaceKind { underground, basement }

extension GarageOfferKindX on GarageOfferKind {
  String get label => switch (this) {
    GarageOfferKind.rent => 'Wynajmę',
    GarageOfferKind.lend => 'Dam w użytkowanie',
  };
}

extension GarageSpaceKindX on GarageSpaceKind {
  String get label => switch (this) {
    GarageSpaceKind.underground => 'Garaż podziemny / miejsce postojowe',
    GarageSpaceKind.basement => 'Box w piwnicy',
  };
}

class GarageListing {
  final String id;
  final GarageOfferKind offer;
  final GarageSpaceKind space;
  final String title;
  final String place;
  final String details;
  final String authorName;

  const GarageListing({
    required this.id,
    required this.offer,
    required this.space,
    required this.title,
    required this.place,
    required this.details,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'offer': offer.name,
    'space': space.name,
    'title': title,
    'place': place,
    'details': details,
    'authorName': authorName,
  };

  factory GarageListing.fromJson(Map<String, dynamic> json) {
    return GarageListing(
      id: json['id'] as String? ?? '',
      offer: json['offer'] == GarageOfferKind.lend.name
          ? GarageOfferKind.lend
          : GarageOfferKind.rent,
      space: json['space'] == GarageSpaceKind.basement.name
          ? GarageSpaceKind.basement
          : GarageSpaceKind.underground,
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? 'Widzew',
      details: json['details'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<GarageListing> seeded() => const [
    GarageListing(
      id: 'gar-podziemny',
      offer: GarageOfferKind.rent,
      space: GarageSpaceKind.underground,
      title: 'Wynajmę miejsce w garażu podziemnym',
      place: 'ul. Rokicińska, Widzew Wschód',
      details: 'Boks 12, wjazd z pilota, od listopada.',
      authorName: 'Sąsiad z Wschodu',
    ),
    GarageListing(
      id: 'gar-piwnica',
      offer: GarageOfferKind.lend,
      space: GarageSpaceKind.basement,
      title: 'Dam w użytkowanie box w piwnicy na Widzewie',
      place: 'Stary Widzew, klatka V',
      details: 'Na rowery i opony, bez wilgoci, zamek własny.',
      authorName: 'Pani Halina',
    ),
  ];
}
