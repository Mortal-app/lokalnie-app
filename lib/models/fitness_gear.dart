enum FitnessGearKind { dumbbell, yogaMat, band, exerciseBike }

extension FitnessGearKindX on FitnessGearKind {
  String get label => switch (this) {
    FitnessGearKind.dumbbell => 'Hantle',
    FitnessGearKind.yogaMat => 'Mata do jogi',
    FitnessGearKind.band => 'Guma oporowa',
    FitnessGearKind.exerciseBike => 'Rower stacjonarny',
  };
}

class FitnessGearItem {
  final String id;
  final FitnessGearKind kind;
  final String title;
  final String owner;
  final bool borrowed;

  const FitnessGearItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.owner,
    this.borrowed = false,
  });

  FitnessGearItem copyWith({bool? borrowed}) {
    return FitnessGearItem(
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

  factory FitnessGearItem.fromJson(Map<String, dynamic> json) {
    return FitnessGearItem(
      id: json['id'] as String? ?? '',
      kind: FitnessGearKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => FitnessGearKind.yogaMat,
      ),
      title: json['title'] as String? ?? '',
      owner: json['owner'] as String? ?? 'Sąsiad',
      borrowed: json['borrowed'] as bool? ?? false,
    );
  }

  static List<FitnessGearItem> seeded() => const [
    FitnessGearItem(
      id: 'fg-hantle',
      kind: FitnessGearKind.dumbbell,
      title: 'Hantle 2×4 kg',
      owner: 'Kasia',
    ),
    FitnessGearItem(
      id: 'fg-mata',
      kind: FitnessGearKind.yogaMat,
      title: 'Mata do jogi — dwie sztuki',
      owner: 'Ania',
    ),
    FitnessGearItem(
      id: 'fg-guma',
      kind: FitnessGearKind.band,
      title: 'Zestaw gum oporowych',
      owner: 'Bartek',
    ),
    FitnessGearItem(
      id: 'fg-rower',
      kind: FitnessGearKind.exerciseBike,
      title: 'Rower stacjonarny w piwnicy klatki II',
      owner: 'Klub osiedlowy',
    ),
  ];
}
