class NeighborQuestBadge {
  final String id;
  final String title;
  final String description;

  const NeighborQuestBadge({
    required this.id,
    required this.title,
    required this.description,
  });

  static const catalog = [
    NeighborQuestBadge(
      id: 'nq-dlon',
      title: 'Pomocna Dłoń',
      description: 'Interwencja domowa albo pomoc na klatce.',
    ),
    NeighborQuestBadge(
      id: 'nq-eko',
      title: 'Eko-Sąsiad',
      description: 'Zbiórka, gabaryt, LED albo szkolne puszki i nakrętki.',
    ),
    NeighborQuestBadge(
      id: 'nq-autor',
      title: 'Lokalny Autor',
      description: 'Ogłoszenie na tablicy albo relacja z osiedla.',
    ),
  ];

  static bool isCatalogId(String id) => catalog.any((badge) => badge.id == id);
}
