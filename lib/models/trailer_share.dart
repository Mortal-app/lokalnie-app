enum TrailerKind { trailer, roofBox, bikeRack }

extension TrailerKindX on TrailerKind {
  String get label => switch (this) {
    TrailerKind.trailer => 'Przyczepka samochodowa',
    TrailerKind.roofBox => 'Box dachowy',
    TrailerKind.bikeRack => 'Platforma rowerowa na hak',
  };
}

class TrailerShare {
  final String id;
  final TrailerKind kind;
  final String title;
  final String owner;
  final bool borrowed;

  const TrailerShare({
    required this.id,
    required this.kind,
    required this.title,
    required this.owner,
    this.borrowed = false,
  });

  TrailerShare copyWith({bool? borrowed}) {
    return TrailerShare(
      id: id,
      kind: kind,
      title: title,
      owner: owner,
      borrowed: borrowed ?? this.borrowed,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'owner': owner,
    'borrowed': borrowed,
  };

  factory TrailerShare.fromJson(Map<String, dynamic> json) {
    return TrailerShare(
      id: json['id'] as String? ?? '',
      kind: TrailerKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => TrailerKind.trailer,
      ),
      title: json['title'] as String? ?? '',
      owner: json['owner'] as String? ?? 'Sąsiad',
      borrowed: json['borrowed'] as bool? ?? false,
    );
  }

  static List<TrailerShare> seeded() => const [
    TrailerShare(
      id: 'ts-przycz',
      kind: TrailerKind.trailer,
      title: 'Przyczepka 750 kg — weekend',
      owner: 'Arek, Olechów',
    ),
    TrailerShare(
      id: 'ts-box',
      kind: TrailerKind.roofBox,
      title: 'Box dachowy Thule-like — urlop',
      owner: 'Kasia',
    ),
    TrailerShare(
      id: 'ts-hak',
      kind: TrailerKind.bikeRack,
      title: 'Platforma na 2 rowery, hak 13-pin',
      owner: 'Tomek',
    ),
  ];
}
