enum BlockPushKind { water, elevator, cleaning, other }

extension BlockPushKindX on BlockPushKind {
  String get label => switch (this) {
    BlockPushKind.water => 'Woda / ogrzewanie',
    BlockPushKind.elevator => 'Winda',
    BlockPushKind.cleaning => 'Sprzątanie klatki',
    BlockPushKind.other => 'Inne z bloku',
  };
}

class BlockPushNotice {
  final String id;
  final String title;
  final String body;
  final String blockNumber;
  final String staircase;
  final BlockPushKind kind;

  const BlockPushNotice({
    required this.id,
    required this.title,
    required this.body,
    required this.blockNumber,
    required this.staircase,
    required this.kind,
  });

  bool matches({
    required String userBlock,
    required String userStaircase,
    required List<BlockPushKind> kinds,
  }) {
    if (userBlock.isNotEmpty &&
        blockNumber.toLowerCase() != userBlock.toLowerCase()) {
      return false;
    }
    if (userStaircase.isNotEmpty &&
        staircase.toLowerCase() != userStaircase.toLowerCase()) {
      return false;
    }
    if (kinds.isNotEmpty && !kinds.contains(kind)) return false;
    return true;
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'blockNumber': blockNumber,
    'staircase': staircase,
    'kind': kind.name,
  };

  factory BlockPushNotice.fromJson(Map<String, dynamic> json) {
    return BlockPushNotice(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      blockNumber: json['blockNumber'] as String? ?? '',
      staircase: json['staircase'] as String? ?? '',
      kind: BlockPushKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => BlockPushKind.other,
      ),
    );
  }

  static List<BlockPushNotice> seeded() => const [
    BlockPushNotice(
      id: 'bp-woda',
      title: 'Wyłączenie ciepłej wody',
      body: 'Blok 140, klatka II — jutro 8:00–14:00.',
      blockNumber: '140',
      staircase: 'Klatka II',
      kind: BlockPushKind.water,
    ),
    BlockPushNotice(
      id: 'bp-winda',
      title: 'Przegląd windy',
      body: 'Blok 77, klatka I — serwis 10:00.',
      blockNumber: '77',
      staircase: 'Klatka I',
      kind: BlockPushKind.elevator,
    ),
    BlockPushNotice(
      id: 'bp-sprzat',
      title: 'Mycie klatki',
      body: 'Blok 140, klatka III — czwartek rano.',
      blockNumber: '140',
      staircase: 'Klatka III',
      kind: BlockPushKind.cleaning,
    ),
  ];
}
