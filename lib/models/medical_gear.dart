enum MedicalGearKind { crutches, wheelchair, rehabBed }

extension MedicalGearKindX on MedicalGearKind {
  String get label => switch (this) {
    MedicalGearKind.crutches => 'Kule łokciowe',
    MedicalGearKind.wheelchair => 'Wózek inwalidzki',
    MedicalGearKind.rehabBed => 'Łóżko rehabilitacyjne',
  };
}

class MedicalGearItem {
  final String id;
  final MedicalGearKind kind;
  final String owner;
  final String place;
  final bool borrowed;

  const MedicalGearItem({
    required this.id,
    required this.kind,
    required this.owner,
    required this.place,
    this.borrowed = false,
  });

  MedicalGearItem copyWith({bool? borrowed}) {
    return MedicalGearItem(
      id: id,
      kind: kind,
      owner: owner,
      place: place,
      borrowed: borrowed ?? this.borrowed,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'owner': owner,
    'place': place,
    'borrowed': borrowed,
  };

  factory MedicalGearItem.fromJson(Map<String, dynamic> json) {
    return MedicalGearItem(
      id: json['id'] as String? ?? '',
      kind: MedicalGearKind.values.firstWhere(
        (item) => item.name == json['kind'],
        orElse: () => MedicalGearKind.crutches,
      ),
      owner: json['owner'] as String? ?? 'Sąsiad',
      place: json['place'] as String? ?? 'Okolica',
      borrowed: json['borrowed'] as bool? ?? false,
    );
  }

  static List<MedicalGearItem> seeded() => const [
    MedicalGearItem(
      id: 'med-kule',
      kind: MedicalGearKind.crutches,
      owner: 'Pani Irena',
      place: 'okolica, klatka II',
    ),
    MedicalGearItem(
      id: 'med-wozek',
      kind: MedicalGearKind.wheelchair,
      owner: 'Klub seniora',
      place: 'Okolica',
    ),
    MedicalGearItem(
      id: 'med-lozko',
      kind: MedicalGearKind.rehabBed,
      owner: 'Rodzina z okolicy',
      place: 'Okolica',
    ),
  ];
}
