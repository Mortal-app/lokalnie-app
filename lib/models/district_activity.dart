class BlockRanking {
  final String id;
  final String blockName;
  final int score;
  final int activeStaircases;

  const BlockRanking({
    required this.id,
    required this.blockName,
    required this.score,
    required this.activeStaircases,
  });

  Map<String, Object?> toJson() => {
    'id': id,
    'blockName': blockName,
    'score': score,
    'activeStaircases': activeStaircases,
  };

  factory BlockRanking.fromJson(Map<String, dynamic> json) {
    return BlockRanking(
      id: json['id'] as String? ?? '',
      blockName: json['blockName'] as String? ?? '',
      score: json['score'] as int? ?? 0,
      activeStaircases: json['activeStaircases'] as int? ?? 0,
    );
  }

  static List<BlockRanking> seeded() => const [
    BlockRanking(
      id: 'blk-rok',
      blockName: 'Rokicińska 140–146',
      score: 86,
      activeStaircases: 4,
    ),
    BlockRanking(
      id: 'blk-pusz',
      blockName: 'Puszkina 77–83',
      score: 71,
      activeStaircases: 3,
    ),
    BlockRanking(
      id: 'blk-olech',
      blockName: 'Olechów — bloki przy SP 141',
      score: 64,
      activeStaircases: 5,
    ),
  ];
}
