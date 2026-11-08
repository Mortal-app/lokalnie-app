enum PreserveKind { jam, pickles, emptyJar }

extension PreserveKindX on PreserveKind {
  String get label => switch (this) {
    PreserveKind.jam => 'Dżem',
    PreserveKind.pickles => 'Ogórki kiszone',
    PreserveKind.emptyJar => 'Puste słoiki',
  };
}

class PreserveJarOffer {
  final String id;
  final PreserveKind kind;
  final String title;
  final String authorName;

  const PreserveJarOffer({
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

  factory PreserveJarOffer.fromJson(Map<String, dynamic> json) {
    return PreserveJarOffer(
      id: json['id'] as String? ?? '',
      kind: PreserveKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => PreserveKind.jam,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<PreserveJarOffer> seeded() => const [
    PreserveJarOffer(
      id: 'pj-dzem',
      kind: PreserveKind.jam,
      title: 'Dżem śliwkowy 2026 — wymienię na kiszone ogórki',
      authorName: 'Pani Krysia',
    ),
    PreserveJarOffer(
      id: 'pj-sloik',
      kind: PreserveKind.emptyJar,
      title: 'Oddam puste słoiki 0,9 l — zwrot po przetworach',
      authorName: 'Ewa',
    ),
  ];
}
