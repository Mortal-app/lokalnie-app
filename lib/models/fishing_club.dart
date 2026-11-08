enum FishingKind { trip, bait, spot }

extension FishingKindX on FishingKind {
  String get label => switch (this) {
    FishingKind.trip => 'Wyjazd nad wodę',
    FishingKind.bait => 'Wymiana przynęt',
    FishingKind.spot => 'Akwen / zbiornik',
  };
}

class FishingPost {
  final String id;
  final FishingKind kind;
  final String title;
  final String place;
  final String authorName;

  const FishingPost({
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

  factory FishingPost.fromJson(Map<String, dynamic> json) {
    return FishingPost(
      id: json['id'] as String? ?? '',
      kind: FishingKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => FishingKind.spot,
      ),
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Wędkarz',
    );
  }

  static List<FishingPost> seeded() => const [
    FishingPost(
      id: 'fi-olech',
      kind: FishingKind.spot,
      title: 'Zbiornik na Olechowie — spokojny brzeg od południa',
      place: 'Olechów',
      authorName: 'Jarek',
    ),
    FishingPost(
      id: 'fi-przyn',
      kind: FishingKind.bait,
      title: 'Oddam gumy i spławiki — biorę kukurydzę',
      place: 'Widzew Wschód',
      authorName: 'Tomek',
    ),
  ];
}
