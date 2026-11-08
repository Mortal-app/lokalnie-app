import 'announcement.dart';

class NeighborhoodTag {
  final String label;
  final List<String> categories;
  final List<String> keywords;

  const NeighborhoodTag({
    required this.label,
    this.categories = const [],
    this.keywords = const [],
  });

  static const all = [
    NeighborhoodTag(
      label: '#hydraulik',
      keywords: ['hydraulik'],
    ),
    NeighborhoodTag(
      label: '#remont',
      keywords: ['remont', 'napraw'],
    ),
    NeighborhoodTag(
      label: '#pies',
      keywords: ['pies', 'psa', 'psem'],
    ),
    NeighborhoodTag(
      label: '#oddam_za_darmo',
      categories: ['Oddam/Kupię'],
      keywords: ['oddam', 'za darmo'],
    ),
    NeighborhoodTag(label: '#Usługi', categories: ['Fachowcy']),
    NeighborhoodTag(label: '#Sprzedam', categories: ['Oddam/Kupię']),
    NeighborhoodTag(
      label: '#Zgubiono',
      categories: ['Zwierzaki', 'Zgubione'],
    ),
    NeighborhoodTag(
      label: '#Spotkanie',
      categories: ['Wydarzenia', 'Sąsiedzi'],
    ),
    NeighborhoodTag(
      label: '#wypozyczalnia',
      categories: [Announcement.lendingCategory],
      keywords: ['wiertarka', 'drabina', 'kosiarka', 'wypożycz'],
    ),
  ];

  bool matches(String category) {
    if (categories.isEmpty) return false;
    final parts = category
        .split(' / ')
        .map((part) => part.trim().toLowerCase())
        .toList();
    return categories.any(
      (tagCategory) =>
          category.toLowerCase() == tagCategory.toLowerCase() ||
          parts.contains(tagCategory.toLowerCase()),
    );
  }

  bool matchesAnnouncement(Announcement announcement) {
    if (matches(announcement.category)) return true;
    if (keywords.isEmpty) return false;
    final haystack =
        '${announcement.title} ${announcement.description} ${announcement.category}'
            .toLowerCase();
    return keywords.any((keyword) => haystack.contains(keyword.toLowerCase()));
  }
}
