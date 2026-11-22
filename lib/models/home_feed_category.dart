import 'announcement.dart';

class HomeFeedCategory {
  final String id;
  final String tileId;
  final String title;
  final List<String> aliases;

  const HomeFeedCategory({
    required this.id,
    required this.tileId,
    required this.title,
    this.aliases = const [],
  });

  static const zlotaRaczka = HomeFeedCategory(
    id: 'zlota_raczka',
    tileId: 'Złota Rączka',
    title: 'Złota Rączka',
    aliases: ['zlota_raczka', 'Złota Rączka', 'Złota rączka'],
  );

  static const remont = HomeFeedCategory(
    id: 'remont',
    tileId: 'Remont',
    title: 'Remont',
    aliases: ['remont', 'remonty', 'Remont', 'Remonty'],
  );

  static const jednorazowe = HomeFeedCategory(
    id: 'jednorazowe_zlecenia',
    tileId: 'Jednorazowe zlecenia',
    title: 'Jednorazowe zlecenia',
    aliases: ['jednorazowe_zlecenia', 'Jednorazowe zlecenia'],
  );

  static const fachowcy = HomeFeedCategory(
    id: 'fachowcy',
    tileId: 'Fachowcy',
    title: 'Fachowcy',
    aliases: ['fachowcy', 'Fachowcy'],
  );

  static const zwierzaki = HomeFeedCategory(
    id: 'zwierzaki',
    tileId: 'Zwierzaki',
    title: 'Opieka nad zwierzętami',
    aliases: [
      'zwierzaki',
      Announcement.petCategory,
      Announcement.wildlifeCategory,
    ],
  );

  static const zgubione = HomeFeedCategory(
    id: 'zgubione_znalezione',
    tileId: 'Zgubione / znalezione',
    title: 'Zgubione / znalezione',
    aliases: [
      'zgubione_znalezione',
      'Zgubione / znalezione',
      'Zgubione',
      'Znalezione',
      'Zgubiono',
      'Znaleziono',
    ],
  );

  static const oddam = HomeFeedCategory(
    id: 'oddam_kupie',
    tileId: 'Oddam/Kupię',
    title: 'Oddam/Kupię',
    aliases: ['oddam_kupie', 'Oddam/Kupię'],
  );

  static const alerty = HomeFeedCategory(
    id: 'alerty_awarie',
    tileId: 'Dzikie zwierzęta',
    title: 'Alerty / awarie',
    aliases: [
      'alerty_awarie',
      Announcement.alertCategory,
      Announcement.wildlifeCategory,
      'Uwaga/Ostrzeżenie',
    ],
  );

  static const jedzenie = HomeFeedCategory(
    id: 'jedzenie',
    tileId: 'Jedzenie',
    title: 'Jedzenie',
    aliases: ['jedzenie', 'Jedzenie'],
  );

  static const sasiedzi = HomeFeedCategory(
    id: 'sasiedzi',
    tileId: 'Sąsiedzi',
    title: 'Lokalne ogłoszenia',
    aliases: ['sasiedzi', 'Sąsiedzi'],
  );

  static const wydarzenia = HomeFeedCategory(
    id: 'wydarzenia',
    tileId: 'Wydarzenia',
    title: 'Wydarzenia',
    aliases: ['wydarzenia', 'Wydarzenia'],
  );

  static const wiecej = HomeFeedCategory(
    id: 'wiecej',
    tileId: 'Inne',
    title: 'Inne',
    aliases: ['wiecej', 'Więcej', Announcement.otherCategory],
  );

  static const all = [
    zlotaRaczka,
    remont,
    jednorazowe,
    fachowcy,
    zwierzaki,
    zgubione,
    oddam,
    alerty,
    jedzenie,
    sasiedzi,
    wydarzenia,
    wiecej,
  ];

  static List<HomeFeedCategory> get exclusiveFilters =>
      all.where((item) => item.id != wiecej.id).toList();

  static HomeFeedCategory? byTile(String tileId) => resolve(tileId);

  static HomeFeedCategory? resolve(String? value) {
    if (value == null || value.isEmpty) return null;
    for (final item in all) {
      if (item.id == value || item.tileId == value) return item;
      for (final alias in item.aliases) {
        if (alias == value) return item;
      }
    }
    return null;
  }

  static String canonicalId(String value) => resolve(value)?.id ?? value;

  static String titleFor(String? value) {
    if (value == null || value.isEmpty) return '';
    return resolve(value)?.title ?? value;
  }

  bool mentions(Announcement announcement) {
    final tokens = <String>{
      announcement.category.trim(),
      ...announcement.category.split(' / ').map((part) => part.trim()),
    };
    bool same(String left, String right) =>
        left.toLowerCase() == right.toLowerCase();
    return tokens.any((token) {
      if (token.isEmpty) return false;
      if (same(token, id) || same(token, tileId)) return true;
      return aliases.any((alias) => same(token, alias));
    });
  }

  bool matchesAnnouncement(Announcement announcement) {
    if (id == wiecej.id) {
      return exclusiveFilters.every(
        (item) => !item.matchesAnnouncement(announcement),
      );
    }
    if (id == alerty.id) {
      return announcement.isAlert || mentions(announcement);
    }
    if (id == zgubione.id) {
      return announcement.isLostFound || mentions(announcement);
    }
    if (id == zwierzaki.id) {
      return mentions(announcement) && !announcement.isLostFound;
    }
    if (id == fachowcy.id) {
      return mentions(announcement) &&
          !zlotaRaczka.mentions(announcement) &&
          !remont.mentions(announcement);
    }
    return mentions(announcement);
  }
}
