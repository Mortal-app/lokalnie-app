enum BlockToolKind { washer, compactor, hammerDrill }

extension BlockToolKindX on BlockToolKind {
  String get label => switch (this) {
    BlockToolKind.washer => 'Myjka ciśnieniowa',
    BlockToolKind.compactor => 'Zagęszczarka',
    BlockToolKind.hammerDrill => 'Wiertarka udarowa',
  };
}

class BlockToolItem {
  final String id;
  final BlockToolKind kind;
  final String staircase;
  final bool available;
  final String note;

  const BlockToolItem({
    required this.id,
    required this.kind,
    required this.staircase,
    required this.available,
    required this.note,
  });

  BlockToolItem copyWith({bool? available}) {
    return BlockToolItem(
      id: id,
      kind: kind,
      staircase: staircase,
      available: available ?? this.available,
      note: note,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'staircase': staircase,
    'available': available,
    'note': note,
  };

  factory BlockToolItem.fromJson(Map<String, dynamic> json) {
    return BlockToolItem(
      id: json['id'] as String? ?? '',
      kind: BlockToolKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => BlockToolKind.washer,
      ),
      staircase: json['staircase'] as String? ?? 'Klatka I',
      available: json['available'] as bool? ?? true,
      note: json['note'] as String? ?? '',
    );
  }

  static List<BlockToolItem> seeded() => const [
    BlockToolItem(
      id: 'bt-myjka',
      kind: BlockToolKind.washer,
      staircase: 'Klatka II, Widzew Wschód',
      available: true,
      note: 'Kupiona ze składek — zwrot tego samego dnia.',
    ),
    BlockToolItem(
      id: 'bt-zageszcz',
      kind: BlockToolKind.compactor,
      staircase: 'Klatka I, Olechów',
      available: false,
      note: 'Wypożyczona do piątku (podjazd).',
    ),
    BlockToolItem(
      id: 'bt-udar',
      kind: BlockToolKind.hammerDrill,
      staircase: 'Klatka III',
      available: true,
      note: 'Udar + wiertła do betonu w skrzynce.',
    ),
  ];
}
