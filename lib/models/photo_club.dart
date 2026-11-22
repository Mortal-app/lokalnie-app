enum PhotoGearKind { analog, digital, lens }

extension PhotoGearKindX on PhotoGearKind {
  String get label => switch (this) {
    PhotoGearKind.analog => 'Analog (Zenit / Praktica)',
    PhotoGearKind.digital => 'Cyfra',
    PhotoGearKind.lens => 'Obiektyw',
  };
}

class PhotoClubItem {
  final String id;
  final PhotoGearKind kind;
  final String title;
  final String place;
  final String authorName;
  final bool isPleinAir;

  const PhotoClubItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.place,
    required this.authorName,
    this.isPleinAir = false,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'place': place,
    'authorName': authorName,
    'isPleinAir': isPleinAir,
  };

  factory PhotoClubItem.fromJson(Map<String, dynamic> json) {
    return PhotoClubItem(
      id: json['id'] as String? ?? '',
      kind: PhotoGearKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => PhotoGearKind.digital,
      ),
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? 'Okolica',
      authorName: json['authorName'] as String? ?? 'Fotograf',
      isPleinAir: json['isPleinAir'] as bool? ?? false,
    );
  }

  static List<PhotoClubItem> seeded() => const [
    PhotoClubItem(
      id: 'ph-zenit',
      kind: PhotoGearKind.analog,
      title: 'Zenit-E — wymiana na Prakticę',
      place: 'centrum handlowe',
      authorName: 'Jacek',
    ),
    PhotoClubItem(
      id: 'ph-plener',
      kind: PhotoGearKind.digital,
      title: 'Plener: wielka płyta o złotej godzinie',
      place: 'osiedle wschodnie, klatki przy głównej arterii',
      authorName: 'Klub foto',
      isPleinAir: true,
    ),
  ];
}
