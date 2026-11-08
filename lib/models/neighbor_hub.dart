import 'package:flutter/material.dart';

enum NeighborHubCategory { mobility, home, community, ecology, culture, settings }

extension NeighborHubCategoryX on NeighborHubCategory {
  String get label => switch (this) {
    NeighborHubCategory.mobility => 'Mobilność i Transport',
    NeighborHubCategory.home => 'Dom i Majsterkowanie',
    NeighborHubCategory.community => 'Społeczność i Wymiana',
    NeighborHubCategory.ecology => 'Ekologia i Balkon',
    NeighborHubCategory.culture => 'Kultura, Hobby i Historia',
    NeighborHubCategory.settings => 'Ustawienia i Narzędzia',
  };

  IconData get icon => switch (this) {
    NeighborHubCategory.mobility => Icons.directions_car_outlined,
    NeighborHubCategory.home => Icons.handyman_outlined,
    NeighborHubCategory.community => Icons.handshake_outlined,
    NeighborHubCategory.ecology => Icons.eco_outlined,
    NeighborHubCategory.culture => Icons.palette_outlined,
    NeighborHubCategory.settings => Icons.settings_outlined,
  };
}

class NeighborHubEntry {
  final String id;
  final NeighborHubCategory category;
  final String title;
  final String keywords;

  const NeighborHubEntry({
    required this.id,
    required this.category,
    required this.title,
    this.keywords = '',
  });

  bool matches(String query) {
    if (query.isEmpty) return true;
    final haystack = '$title $keywords ${category.label}'.toLowerCase();
    return haystack.contains(query.toLowerCase());
  }
}

class NeighborHubCatalog {
  static const defaultFavoriteIds = [
    'carpool',
    'handy-jobs',
    'flea-market',
  ];

  static const entries = <NeighborHubEntry>[
    NeighborHubEntry(
      id: 'carpool',
      category: NeighborHubCategory.mobility,
      title: 'Jedziemy Razem / Carpooling',
      keywords:
          'carpool auto dojazd transport noc weekend zima lotnisko '
          'studenci galeria cargo bieszczady termy kajak sudety '
          'dalekobieżny paliwo cel opis olej oc ac przegląd ładowanie ev',
    ),
    NeighborHubEntry(
      id: 'garage',
      category: NeighborHubCategory.mobility,
      title: 'Parking, garaże i miejsca',
      keywords: 'parking garaz piwnica linie koperta tablice rejestracyjne',
    ),
    NeighborHubEntry(
      id: 'bike-help',
      category: NeighborHubCategory.mobility,
      title: 'Rowery i hulajnogi',
      keywords: 'rower hulajnoga pompka stacje fotelik przyczepa',
    ),
    NeighborHubEntry(
      id: 'handy-jobs',
      category: NeighborHubCategory.home,
      title: 'Sąsiedzkie Pogotowie Domowe',
      keywords:
          'złota rączka awaria majster kran zamek rolety żaluzje '
          'kaloryfer termostat wideodomofon unifon okna pcv uszczelki '
          'wkladka cisnienie wody czujnik dymu hydraulik elektryk remont '
          'gaz piec rtv agd narzędzia wiertarka drabina filtr hepa',
    ),
    NeighborHubEntry(
      id: 'eco-patrol',
      category: NeighborHubCategory.home,
      title: 'Eko-Patrol i odpady',
      keywords:
          'śmieci wysypisko pszok elektro gabaryty meble mpo '
          'odzież liście gałęzie czysty widzew balkon ogród kompost '
          'rośliny sadzonki zioła działka rod',
    ),
    NeighborHubEntry(
      id: 'sound-alerts',
      category: NeighborHubCategory.home,
      title: 'Powiadomienia i alerty',
      keywords:
          'dźwięk ciche godziny blok klatka scam oszustwo '
          'kontrast czcionka backup cache diagnostyka',
    ),
    NeighborHubEntry(
      id: 'flea-market',
      category: NeighborHubCategory.community,
      title: 'Wymiana, targ i dary',
      keywords:
          'gielda barter starocie odziez pck uśmiech kontener '
          'ksiazka polka lego puzzle bank czasu godziny',
    ),
    NeighborHubEntry(
      id: 'pet-sit',
      category: NeighborHubCategory.community,
      title: 'Zwierzęta i fauna',
      keywords:
          'pies kot opieka zaginione akwarium terrarium papugi '
          'dzik fauna ratunek',
    ),
    NeighborHubEntry(
      id: 'time-bank',
      category: NeighborHubCategory.community,
      title: 'Sąsiedzki Bank Czasu',
      keywords:
          'wymiana godzin pomoc rodzice dzieci wózki sport fitness '
          'wypożyczalnia kluby grupy jadłodzielnia chleb zakwas',
    ),
  ];

  static NeighborHubEntry? byId(String id) {
    for (final entry in entries) {
      if (entry.id == id) return entry;
    }
    return null;
  }
}
