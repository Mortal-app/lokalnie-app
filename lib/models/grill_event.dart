enum GrillSpot { badenPowell, stawyStefanski, courtyard }

extension GrillSpotX on GrillSpot {
  String get label => switch (this) {
    GrillSpot.badenPowell => 'Park Baden-Powella',
    GrillSpot.stawyStefanski => 'Stawy Stefańskiego',
    GrillSpot.courtyard => 'Dziedziniec bloku',
  };
}

class GrillEvent {
  final String id;
  final GrillSpot spot;
  final String title;
  final String whenLabel;
  final String authorName;
  final bool grillReserved;

  const GrillEvent({
    required this.id,
    required this.spot,
    required this.title,
    required this.whenLabel,
    required this.authorName,
    this.grillReserved = false,
  });

  GrillEvent copyWith({bool? grillReserved}) {
    return GrillEvent(
      id: id,
      spot: spot,
      title: title,
      whenLabel: whenLabel,
      authorName: authorName,
      grillReserved: grillReserved ?? this.grillReserved,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'spot': spot.name,
    'title': title,
    'whenLabel': whenLabel,
    'authorName': authorName,
    'grillReserved': grillReserved,
  };

  factory GrillEvent.fromJson(Map<String, dynamic> json) {
    return GrillEvent(
      id: json['id'] as String? ?? '',
      spot: GrillSpot.values.firstWhere(
        (item) => item.name == json['spot'],
        orElse: () => GrillSpot.badenPowell,
      ),
      title: json['title'] as String? ?? '',
      whenLabel: json['whenLabel'] as String? ?? '',
      authorName: json['authorName'] as String? ?? 'Sąsiad',
      grillReserved: json['grillReserved'] as bool? ?? false,
    );
  }

  static List<GrillEvent> seeded() => const [
    GrillEvent(
      id: 'gr-bp',
      spot: GrillSpot.badenPowell,
      title: 'Grill klatek I–II — kiełbasa i warzywa',
      whenLabel: 'Sobota 16:00',
      authorName: 'Tomek',
    ),
    GrillEvent(
      id: 'gr-stawy',
      spot: GrillSpot.stawyStefanski,
      title: 'Wieczór przy stawach — koc i głośnik',
      whenLabel: 'Niedziela 17:30',
      authorName: 'Ania',
      grillReserved: true,
    ),
  ];
}

class PortableGrill {
  final String id;
  final String name;
  final String owner;
  final bool reserved;

  const PortableGrill({
    required this.id,
    required this.name,
    required this.owner,
    this.reserved = false,
  });

  PortableGrill copyWith({bool? reserved}) {
    return PortableGrill(
      id: id,
      name: name,
      owner: owner,
      reserved: reserved ?? this.reserved,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'owner': owner,
    'reserved': reserved,
  };

  factory PortableGrill.fromJson(Map<String, dynamic> json) {
    return PortableGrill(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Grill przenośny',
      owner: json['owner'] as String? ?? 'Klub osiedlowy',
      reserved: json['reserved'] as bool? ?? false,
    );
  }

  static List<PortableGrill> seeded() => const [
    PortableGrill(
      id: 'pg-weber',
      name: 'Grill kulisty z pokrywą',
      owner: 'Rada osiedla',
    ),
    PortableGrill(
      id: 'pg-skladany',
      name: 'Grill składany turystyczny',
      owner: 'Sąsiad z klatki V',
    ),
  ];
}
