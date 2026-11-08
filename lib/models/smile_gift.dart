enum SmileGiftKind { clothes, toys, furniture }

extension SmileGiftKindX on SmileGiftKind {
  String get label => switch (this) {
    SmileGiftKind.clothes => 'Odzież',
    SmileGiftKind.toys => 'Zabawki',
    SmileGiftKind.furniture => 'Meble',
  };
}

class SmileGift {
  final String id;
  final SmileGiftKind kind;
  final String title;
  final String place;
  final String authorName;

  const SmileGift({
    required this.id,
    required this.kind,
    required this.title,
    required this.place,
    required this.authorName,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'place': place,
    'authorName': authorName,
  };

  factory SmileGift.fromJson(Map<String, dynamic> json) {
    return SmileGift(
      id: json['id'] as String? ?? '',
      kind: SmileGiftKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => SmileGiftKind.clothes,
      ),
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? 'Widzew',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
    );
  }

  static List<SmileGift> seeded() => const [
    SmileGift(
      id: 'sg-ubrania',
      kind: SmileGiftKind.clothes,
      title: 'Kurtki dziecięce 116–128 — oddam za uśmiech',
      place: 'Klatka IV, Olechów',
      authorName: 'Kasia',
    ),
    SmileGift(
      id: 'sg-zabawki',
      kind: SmileGiftKind.toys,
      title: 'Klocki i pluszaki po synku',
      place: 'Janów',
      authorName: 'Pani Zosia',
    ),
    SmileGift(
      id: 'sg-meble',
      kind: SmileGiftKind.furniture,
      title: 'Stolik kawowy — odbiór własny',
      place: 'Widzew Wschód',
      authorName: 'Sąsiad z Wschodu',
    ),
  ];
}
