enum SchoolGearKind { pencilCase, backpack, artSet, geometry }

extension SchoolGearKindX on SchoolGearKind {
  String get label => switch (this) {
    SchoolGearKind.pencilCase => 'Piórnik',
    SchoolGearKind.backpack => 'Tornister',
    SchoolGearKind.artSet => 'Artykuły plastyczne',
    SchoolGearKind.geometry => 'Zestaw geometryczny',
  };
}

class SchoolGearOffer {
  final String id;
  final SchoolGearKind kind;
  final String title;
  final String authorName;

  const SchoolGearOffer({
    required this.id,
    required this.kind,
    required this.title,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'authorName': authorName,
  };

  factory SchoolGearOffer.fromJson(Map<String, dynamic> json) {
    return SchoolGearOffer(
      id: json['id'] as String? ?? '',
      kind: SchoolGearKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => SchoolGearKind.backpack,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Rodzic',
    );
  }

  static List<SchoolGearOffer> seeded() => const [
    SchoolGearOffer(
      id: 'sg-torn',
      kind: SchoolGearKind.backpack,
      title: 'Tornister klasa 1–3 — przed nowym rokiem szkolnym',
      authorName: 'Hania',
    ),
    SchoolGearOffer(
      id: 'sg-geom',
      kind: SchoolGearKind.geometry,
      title: 'Cyrkiel i ekierki — komplet, prawie nowy',
      authorName: 'Kasia',
    ),
  ];
}
