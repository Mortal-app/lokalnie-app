enum AvGearKind { mic, stand, ringLight, camera }

extension AvGearKindX on AvGearKind {
  String get label => switch (this) {
    AvGearKind.mic => 'Mikrofon pojemnościowy',
    AvGearKind.stand => 'Statyw',
    AvGearKind.ringLight => 'Ring-light',
    AvGearKind.camera => 'Kamera',
  };
}

class AvGearItem {
  final String id;
  final AvGearKind kind;
  final String title;
  final String owner;
  final bool borrowed;

  const AvGearItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.owner,
    this.borrowed = false,
  });

  AvGearItem copyWith({bool? borrowed}) {
    return AvGearItem(
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

  factory AvGearItem.fromJson(Map<String, dynamic> json) {
    return AvGearItem(
      id: json['id'] as String? ?? '',
      kind: AvGearKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => AvGearKind.mic,
      ),
      title: json['title'] as String? ?? '',
      owner: json['owner'] as String? ?? 'Sąsiad',
      borrowed: json['borrowed'] as bool? ?? false,
    );
  }

  static List<AvGearItem> seeded() => const [
    AvGearItem(
      id: 'av-mic',
      kind: AvGearKind.mic,
      title: 'Mikrofon pojemnościowy USB do podcastu',
      owner: 'Klub osiedlowy',
    ),
    AvGearItem(
      id: 'av-ring',
      kind: AvGearKind.ringLight,
      title: 'Ring-light 26 cm',
      owner: 'Ania',
    ),
    AvGearItem(
      id: 'av-cam',
      kind: AvGearKind.camera,
      title: 'Kamera + statyw do amatorskich relacji',
      owner: 'Bartek',
    ),
  ];
}
