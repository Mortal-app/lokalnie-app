enum CollectorKind { coin, banknote, stamp, militaria }

extension CollectorKindX on CollectorKind {
  String get label => switch (this) {
    CollectorKind.coin => 'Monety',
    CollectorKind.banknote => 'Banknoty',
    CollectorKind.stamp => 'Znaczki pocztowe',
    CollectorKind.militaria => 'Militaria (łódzkie)',
  };
}

class CollectorItem {
  final String id;
  final CollectorKind kind;
  final String title;
  final String authorName;

  const CollectorItem({
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

  factory CollectorItem.fromJson(Map<String, dynamic> json) {
    return CollectorItem(
      id: json['id'] as String? ?? '',
      kind: CollectorKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => CollectorKind.coin,
      ),
      title: json['title'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Kolekcjoner',
    );
  }

  static List<CollectorItem> seeded() => const [
    CollectorItem(
      id: 'cf-moneta',
      kind: CollectorKind.coin,
      title: 'Giełda numizmatyczna — 5 zł II RP, wymiana',
      authorName: 'Pan Jacek',
    ),
    CollectorItem(
      id: 'cf-znaczki',
      kind: CollectorKind.stamp,
      title: 'Znaczki Poczty Polskiej, okolica — albumy',
      authorName: 'Pani Halina',
    ),
  ];
}
