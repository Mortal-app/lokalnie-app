enum ArcheryKind { target, bow, arrow, outdoor }

extension ArcheryKindX on ArcheryKind {
  String get label => switch (this) {
    ArcheryKind.target => 'Tarcza',
    ArcheryKind.bow => 'Łuk rekreacyjny',
    ArcheryKind.arrow => 'Strzały',
    ArcheryKind.outdoor => 'Sprzęt terenowy',
  };
}

class ArcheryGearOffer {
  final String id;
  final ArcheryKind kind;
  final String title;
  final String authorName;

  const ArcheryGearOffer({
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

  factory ArcheryGearOffer.fromJson(Map<String, dynamic> json) {
    return ArcheryGearOffer(
      id: json['id'] as String? ?? '',
      kind: ArcheryKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => ArcheryKind.target,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Łucznik',
    );
  }

  static List<ArcheryGearOffer> seeded() => const [
    ArcheryGearOffer(
      id: 'ag-tar',
      kind: ArcheryKind.target,
      title: 'Tarcza piankowa 80 cm — oddam za strzały',
      authorName: 'Bartek',
    ),
    ArcheryGearOffer(
      id: 'ag-luk',
      kind: ArcheryKind.bow,
      title: 'Łuk rekreacyjny — trening na działce',
      authorName: 'Ola',
    ),
  ];
}
