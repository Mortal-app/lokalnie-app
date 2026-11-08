enum KidsToyKind { lego, board, didactic }

extension KidsToyKindX on KidsToyKind {
  String get label => switch (this) {
    KidsToyKind.lego => 'Klocki LEGO',
    KidsToyKind.board => 'Gry planszowe dla dzieci',
    KidsToyKind.didactic => 'Zabawki dydaktyczne',
  };
}

class LegoSwapItem {
  final String id;
  final KidsToyKind kind;
  final String title;
  final String authorName;

  const LegoSwapItem({
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

  factory LegoSwapItem.fromJson(Map<String, dynamic> json) {
    return LegoSwapItem(
      id: json['id'] as String? ?? '',
      kind: KidsToyKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => KidsToyKind.lego,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Rodzic',
    );
  }

  static List<LegoSwapItem> seeded() => const [
    LegoSwapItem(
      id: 'lg-city',
      kind: KidsToyKind.lego,
      title: 'Komplet LEGO City — wymiana na Friends',
      authorName: 'Ola',
    ),
    LegoSwapItem(
      id: 'lg-gra',
      kind: KidsToyKind.board,
      title: 'Dobble i memory — oddam za puzzle 100',
      authorName: 'Kasia',
    ),
  ];
}
