enum LostFoundKind { keys, wallet, documents, pet }

enum LostFoundSide { lost, found }

extension LostFoundKindX on LostFoundKind {
  String get label => switch (this) {
    LostFoundKind.keys => 'Klucze',
    LostFoundKind.wallet => 'Portfel',
    LostFoundKind.documents => 'Dokumenty',
    LostFoundKind.pet => 'Kot / pies',
  };
}

extension LostFoundSideX on LostFoundSide {
  String get label => switch (this) {
    LostFoundSide.lost => 'Zgubiono',
    LostFoundSide.found => 'Znaleziono',
  };
}

class LostFoundItem {
  final String id;
  final String title;
  final String description;
  final LostFoundKind kind;
  final LostFoundSide side;
  final String place;
  final String authorName;
  final String subDistrict;
  final bool returned;

  const LostFoundItem({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    required this.side,
    required this.place,
    required this.authorName,
    required this.subDistrict,
    this.returned = false,
  });

  LostFoundItem copyWith({bool? returned}) {
    return LostFoundItem(
      id: id,
      title: title,
      description: description,
      kind: kind,
      side: side,
      place: place,
      authorName: authorName,
      subDistrict: subDistrict,
      returned: returned ?? this.returned,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'kind': kind.name,
    'side': side.name,
    'place': place,
    'authorName': authorName,
    'subDistrict': subDistrict,
    'returned': returned,
  };

  factory LostFoundItem.fromJson(Map<String, dynamic> json) {
    return LostFoundItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      kind: LostFoundKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => LostFoundKind.keys,
      ),
      side: json['side'] == LostFoundSide.found.name
          ? LostFoundSide.found
          : LostFoundSide.lost,
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      subDistrict: json['subDistrict'] as String? ?? 'Widzew Wschód',
      returned: json['returned'] as bool? ?? false,
    );
  }

  static List<LostFoundItem> seeded() => const [
    LostFoundItem(
      id: 'lf-keys',
      title: 'Zgubiono klucze przy klatce',
      description: 'Brelok z herbem Widzewa, trzy klucze.',
      kind: LostFoundKind.keys,
      side: LostFoundSide.lost,
      place: 'Olechów, klatka II',
      authorName: 'Sąsiadka z Olechowa',
      subDistrict: 'Olechów',
    ),
    LostFoundItem(
      id: 'lf-wallet',
      title: 'Znaleziono portfel na ławce',
      description: 'Czarny portfel, bez dokumentów na wierzchu.',
      kind: LostFoundKind.wallet,
      side: LostFoundSide.found,
      place: 'Park Górka Widzewska',
      authorName: 'Sąsiad ze Starego Widzewa',
      subDistrict: 'Stary Widzew',
    ),
    LostFoundItem(
      id: 'lf-cat',
      title: 'Zagubiony kot w okolicy',
      description: 'Rudy, bez obroży, płochliwy.',
      kind: LostFoundKind.pet,
      side: LostFoundSide.lost,
      place: 'ul. Rokicińska',
      authorName: 'Sąsiad z Widzewa Wschód',
      subDistrict: 'Widzew Wschód',
    ),
  ];
}
